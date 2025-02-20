

import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:firestoreproject2/Screens/audioController.dart';
import 'package:firestoreproject2/Screens/pdf.dart';
import 'package:firestoreproject2/video.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class ChatScreen extends StatefulWidget {
  final String? username;
  final String? chatroomId;
  const ChatScreen(
      {super.key, required this.username, required this.chatroomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var height, width;

  TextEditingController msgController = TextEditingController();
  bool isMessageEmpty = true;

  AudioController audioController = Get.put(AudioController());
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isRecording = false;
  bool isPlaying = false;
  int currentPlayingIndex = -1;

  String getFormattedTime(Timestamp? timestamp) {
    if (timestamp == null) {
      return "";
    }
    DateTime dateTime = timestamp.toDate();
    return DateFormat('h:mm a').format(dateTime);
  }

  String durationText = "00:00";
  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false;
        currentPlayingIndex = -1;
      });
    });

    msgController.addListener(() {
      setState(() {
        isMessageEmpty = msgController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    msgController.dispose();
    _audioPlayer.dispose();

    super.dispose();
  }

  void bottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: height * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    pickVideoFromGallery();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.play_circle)),
              IconButton(
                  onPressed: () {
                    pickImageFromGallary();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.image)),
              IconButton(
                  onPressed: () {
                    pickimagefromCamera();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.photo_camera)),
              IconButton(
                  onPressed: () {
                    pickPdf();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.file_present_outlined)),
            ],
          ),
        );
      },
    );
  }

  void sendText() {
    String textmessage = msgController.text.trim();
    if (textmessage.isEmpty) {
      msgController.clear();
      return;
    } else {
      _onSendMessage(textmessage, "text", "");
      msgController.clear();
    }
  }

  final Record _audioRecorder = Record();
  String? _recordedFilePath;
  Future<bool> checkPermissions() async {
    PermissionStatus micStatus = await Permission.microphone.request();

    if (micStatus.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> startRecording() async {
    bool hasPermission = await checkPermissions();
    if (!hasPermission) {
      print("Permission denied");
      return;
    }

    Directory tempDir = await getTemporaryDirectory();
    String filePath =
        '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _audioRecorder.start(
      path: filePath,
      encoder: AudioEncoder.aacLc, // Better compatibility
      bitRate: 128000,
    );

    setState(() {
      isRecording = true;
      _recordedFilePath = filePath;
    });
  }

  Future<void> stopRecording() async {
    if (!isRecording) return;

    String? path = await _audioRecorder.stop();
    setState(() {
      isRecording = false;
    });
    audioController.end.value = DateTime.now();
    audioController.calcDuration();
    // audioController.isRecording.value = false;
    // audioController.isSending.value = true;
    print("${audioController.total}");
    //audioController.isSending.value = false;
    // onSendMessage(strVal, TypeMessage.audio,
    //     duration: audioController.total);

    if (path != null) {
      File audioFile = File(path);
      final String fileName =
          "UserAudios/${DateTime.now().microsecondsSinceEpoch}.m4a";
      final reference = FirebaseStorage.instance.ref().child(fileName);

      await reference.putFile(audioFile);

      String downloadUrl = await reference.getDownloadURL();
      print("Audio uploaded successfully: $downloadUrl");

      _onSendMessage(downloadUrl, "audio", audioController.total);
    }
  }

  final double _sliderValue = 0.0;

  void _onSendMessage(String msg, String type, String audioDuration) async {
    Map<String, dynamic> messages = {
      "sendBy": StaticData.model!.name,
      "recievBy": widget.username!,
      "message": msg,
      "time": FieldValue.serverTimestamp(),
      "type": type,
      "duration": audioDuration
    };

    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(widget.chatroomId)
        .collection("chats")
        .add(messages);
  }

  Future<void> pickimagefromCamera() async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final file = File(image.path);
      final fileName =
          "UserImages/${DateTime.now().microsecondsSinceEpoch}.jpg";
      final reference = FirebaseStorage.instance.ref().child(fileName);
      await reference.putFile(file);
      String downloadUrl = await reference.getDownloadURL();
      _onSendMessage(downloadUrl, "image", "");
    }
  }

  final picker = ImagePicker();
  File? imageFile;

  Future<void> pickImageFromGallary() async {
    XFile? pickedimage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      imageFile = File(pickedimage.path);

      final String fileName =
          "UserImages/${DateTime.now().microsecondsSinceEpoch}.png";
      final reference = FirebaseStorage.instance.ref().child(fileName);

      await reference.putFile(imageFile!);

      String downloadUrl = await reference.getDownloadURL();

      _onSendMessage(downloadUrl, "img", "");
    }
  }

  Future<void> pickVideoFromGallery() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video != null) {
      File uploasVideoFile = File(video.path);
      var videoName = DateTime.now().microsecondsSinceEpoch.toString();
      var stroageRef =
          FirebaseStorage.instance.ref().child("video/$videoName.mp4");
      var uploadtask = stroageRef.putFile(uploasVideoFile);
      var downloadVideoUrl = await (await uploadtask).ref.getDownloadURL();
      _onSendMessage(downloadVideoUrl, "video", "");
    }
  }

  void pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result!.files.isNotEmpty) {
      File uploadpdfFile = File(result.files.first.path!);
      var imageName = DateTime.now().millisecondsSinceEpoch.toString();
      var storageRef =
          FirebaseStorage.instance.ref().child('file/$imageName.pdf');
      var uploadTask = storageRef.putFile(uploadpdfFile);
      var pdfdownloadUrl = await (await uploadTask).ref.getDownloadURL();

      _onSendMessage(pdfdownloadUrl, "pdf", "");
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          width: width,
          color: Colors.pink[50],
          child: Column(
            children: [
              Container(
                height: height * 0.1,
                width: width,
                color: Colors.white,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.green,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Text(
                      widget.username!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {},
                          child: const Icon(Icons.call_outlined),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.videocam_outlined,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.05,
                    )
                  ],
                ),
              ),
              Expanded(
                  child: SizedBox(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("chatRoom")
                      .doc(widget.chatroomId)
                      .collection("chats")
                      .orderBy("time", descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          return onSendmessage(
                              MediaQuery.of(context).size, map, index);
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                            controller: msgController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                hintText: "write something here...",
                                suffixIcon: InkWell(
                                    onTap: () {
                                      bottomSheet();
                                    },
                                    child: const Icon(Icons.attach_file))),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                        onTap: () {
                          sendText();
                        },
                        onLongPress: () async {
                          startRecording();
                          //    audioController.isRecording.value = true;
                          // audioController.start.value = DateTime.now();
                          audioController.start.value = DateTime.now();
                          print(DateTime.now());
                          setState(() {
                            isRecording = true;
                          });
                        },
                        onLongPressEnd: (details) async {
                          if (isRecording) {
                            await stopRecording();

                            setState(() {
                              isRecording = false;
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.green,
                          child: Center(
                              child: isMessageEmpty
                                  ? Icon(
                                      Icons.mic,
                                      color: Colors.white,
                                      size: isRecording ? 50 : 30,
                                    )
                                  : const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    )),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.01,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget onSendmessage(Size size, Map<String, dynamic> map, int index) {
    Timestamp? time = map["time"];
    bool isSender = map["sendBy"] == StaticData.model!.name;
    String senderName = isSender ? "You" : map["sendBy"];
    return Container(
      width: size.width,
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Container(
        constraints: BoxConstraints(maxWidth: size.width * 0.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isSender ? const Color(0xFF25D366) : const Color(0xFFF0F0F0),
        ),
        child: IntrinsicWidth(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                map['type'] == "pdf"
                    ? PdfContainer(
                        url: map["message"],
                      )
                    : map['type'] == "audio"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                senderName,
                                style: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: height * 0.05,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        audioController.onPressedPlayButton(
                                            index, map["message"]);
                                        // changeProg(duration: duration);
                                      },
                                      onSecondaryTap: () {
                                        _audioPlayer.stop();
                                        //   audioController.completedPercentage.value = 0.0;
                                      },
                                      child: Obx(
                                        () =>
                                            (audioController.isRecordPlaying &&
                                                    audioController.currentId ==
                                                        index)
                                                ? Icon(
                                                    Icons.pause,
                                                    color: isSender
                                                        ? Colors.white
                                                        : Colors.red,
                                                  )
                                                : Icon(
                                                    Icons.play_arrow,
                                                    color: isSender
                                                        ? Colors.white
                                                        : Colors.red,
                                                  ),
                                      ),
                                    ),
                                    Obx(() => Expanded(
                                          child: SizedBox(
                                            width: width * 0.3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: LinearProgressIndicator(
                                                key: ValueKey(map['sendBy']),
                                                minHeight: 5,
                                                backgroundColor: Colors.grey,
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(
                                                       
                                                  (isSender)
                                                      ? (audioController
                                                                  .isRecordPlaying &&
                                                              audioController
                                                                      .currentId ==
                                                                  index)
                                                          ? Colors
                                                              .white // Change to white when playing
                                                          : Colors
                                                              .red // Change to red when sent
                                                      : Colors
                                                          .white, // Keep white for received messages
                                                ),
                                                value: (audioController
                                                            .isRecordPlaying &&
                                                        audioController
                                                                .currentId ==
                                                            index)
                                                    ? audioController
                                                        .completedPercentage
                                                        .value
                                                    : audioController
                                                        .totalDuration.value
                                                        .toDouble(),
                                              ),
                                            ),
                                          ),
                                        )),
                                    Obx(() => Text(
                                          (audioController.isRecordPlaying &&
                                                  audioController.currentId ==
                                                      index)
                                              ? audioController
                                                  .getRemainingTime() // Show countdown
                                              : "${map['duration']} s", // Show default duration if not playing
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: isSender
                                                  ? Colors.white
                                                  : Colors.red),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          )
                        : map['type'] == "img"
                            ? Container(
                                height: size.height * 0.2,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(map['message']))),
                              )
                            : map["type"] == "video"
                                ? VideoContainer(videoUrl: map['message'])
                                : Text(
                                    map["message"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: map["sendBy"] ==
                                              StaticData.model!.name
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    getFormattedTime(time),
                    style: const TextStyle(fontSize: 10),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
