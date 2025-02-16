import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class MyAudioController extends GetxController {
  static MyAudioController get to => Get.find();

  bool isRecording = false;
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  String total = "";

  void changeRecordingStatus(bool v) {
    isRecording = v;
    update();
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

    isRecording = true;
    _recordedFilePath = filePath;

    update();
  }

  Future<void> stopRecording(String name, String chatID) async {
    String? path = await _audioRecorder.stop();

    end = DateTime.now();
    calcDuration();

    if (path != null) {
      File audioFile = File(path);
      final String fileName =
          "UserAudios/${DateTime.now().microsecondsSinceEpoch}.m4a";
      final reference = FirebaseStorage.instance.ref().child(fileName);

      await reference.putFile(audioFile);

      String downloadUrl = await reference.getDownloadURL();

      onSendMessage(downloadUrl, "audio", total, name, chatID);
    }
  }

  void calcDuration() {
    var a = end.difference(start).inSeconds;
    total = "$a"; // Store only seconds

    update();
  }

  void onSendMessage(String msg, String type, String audioDuration, String name,
      String? chtId) async {
    Map<String, dynamic> messages = {
      "sendBy": StaticData.model!.name,
      "recievBy": name,
      "message": msg,
      "time": FieldValue.serverTimestamp(),
      "type": type,
      "duration": audioDuration
    };

    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chtId)
        .collection("chats")
        .add(messages);
  }

  // final double _sliderValue = 0.0;
}
