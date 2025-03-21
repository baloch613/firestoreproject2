import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestoreproject2/Models/Model.dart';
import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:firestoreproject2/Screens/Chat_Screen.dart';
import 'package:firestoreproject2/Screens/Request_Screen.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<Chatbox> allUsers = [];

  getAllUsers() async {
    allUsers.clear();

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("userid", isNotEqualTo: StaticData.loginId)
        .get();
    for (var user in snapshot.docs) {
      Chatbox model = Chatbox.fromMap(user.data() as Map<String, dynamic>);
      if (mounted) {
        setState(() {
          allUsers.add(model);
        });
      }
    }
  }

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: Colors.black,
        child: Column(
          children: [
            SizedBox(
              height: height * 0.09,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const Text(
                    "HOME",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RequestScreen(),
                            ));
                      },
                      child: const Text(
                        "Requests",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            SizedBox(
              height: height * 0.11,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allUsers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: height * 0.08,
                              width: width * 0.155,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: index == 0
                                          ? Colors.white
                                          : Colors.pink,
                                      width: width * 0.005),
                                  image: const DecorationImage(
                                      image: AssetImage("images/mazari.jpg"),
                                      fit: BoxFit.cover)),
                            ),
                            Text(
                              allUsers[index].name!,
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        if (index == 0)
                          Positioned(
                              top: height * 0.05,
                              left: width * 0.1,
                              child: const Icon(
                                Icons.add_circle,
                                color: Colors.white,
                                size: 20,
                              )),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Expanded(
              child: Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.006,
                    ),
                    Container(
                      height: height * 0.005,
                      width: width * 0.1,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(100)),
                    ),
                    Expanded(
                      child: allUsers.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              itemCount: allUsers.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      String chatId = chatRoomId(
                                          StaticData.model!.userid!,
                                          allUsers[index].userid!);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                              username: allUsers[index].name!,
                                              chatroomId: chatId,
                                            ),
                                          ));
                                    },
                                    child: ListTile(
                                      leading: const CircleAvatar(
                                        backgroundImage:
                                            AssetImage("images/mazari.jpg"),
                                      ),
                                      title: Text(allUsers[index].name!),
                                      subtitle: Text(allUsers[index].email!),
                                      trailing: Text("${index + 1}"),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
