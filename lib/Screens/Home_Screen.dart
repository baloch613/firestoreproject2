import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestoreproject2/Models/Model.dart';
import 'package:firestoreproject2/Screens/Login_Screen.dart';
import 'package:firestoreproject2/Screens/Request_Screen.dart';
import 'package:firestoreproject2/Screens/profile.dart';
import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:firestoreproject2/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController pageController;

  int _index = 0;
  List<Chatbox> allUsers = [];

  getAllUsers() async {
    allUsers.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("userid", isNotEqualTo: StaticData.model!.userid)
        .get();
    for (var user in snapshot.docs) {
      Chatbox model = Chatbox.fromMap(user.data() as Map<String, dynamic>);
      setState(() {
        allUsers.add(model);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    Future.delayed(Duration.zero, () => getAllUsers());
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: height,
          width: width,
          child: PageView(
            controller: pageController,
            onPageChanged: (value) {
              setState(() {
                _index = value;
              });
            },
            children: [
              //first page home screen
              Container(
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RequestScreen(),
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
                                              image: AssetImage(
                                                  "images/mazari.jpg"),
                                              fit: BoxFit.cover)),
                                    ),
                                    Text(
                                      allUsers[index].name!,
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
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
                              child: SizedBox(
                                height: height,
                                width: width,
                                child: ListView.builder(
                                  itemCount: allUsers.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          String chatId = chatRoomId(
                                              StaticData.model!.userid!,
                                              allUsers[index].userid!);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                  username:
                                                      allUsers[index].name!,
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
                                          subtitle:
                                              Text(allUsers[index].email!),
                                          trailing: Text("${index + 1}"),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //2nd page all users screen
              Container(
                height: height,
                width: width,
                color: Colors.black,
                child: Column(
                  children: [
                    Container(
                      height: height * 0.09,
                      width: width,
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text(
                            "Calls",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
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
                            Padding(
                              padding: EdgeInsets.only(
                                  right: width * 0.75, top: height * 0.02),
                              child: const Text(
                                "Recent",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: allUsers.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    color: Colors.white,
                                    child: ListTile(
                                      leading: const CircleAvatar(
                                        backgroundImage:
                                            AssetImage("images/mazari.jpg"),
                                      ),
                                      title: Text(allUsers[index].name!),
                                      subtitle: Row(
                                        children: const [
                                          Icon(
                                            Icons.phone_callback,
                                            size: 17,
                                            color: Colors.green,
                                          ),
                                          Text("  Today,09:30 AM"),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.wifi_calling_outlined),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                              onTap: () async {
                                                Uuid uid = Uuid();
                                                String reqId = uid.v4();

                                                ReqModel model = ReqModel(
                                                    reciverId:
                                                        allUsers[index].userid,
                                                    reciverName:
                                                        allUsers[index].name,
                                                    requestId: reqId,
                                                    senderId: StaticData
                                                        .model!.userid,
                                                    senderName:
                                                        StaticData.model!.name,
                                                    status: 'pending');

                                                await FirebaseFirestore.instance
                                                    .collection('requests')
                                                    .doc(reqId)
                                                    .set(model.toMap());
                                              },
                                              child: Icon(
                                                  Icons.person_add_outlined))
                                        ],
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
              //3rd page settings screen
              Container(
                height: height,
                width: width,
                color: Colors.black,
                child: Column(
                  children: [
                    Container(
                      height: height * 0.09,
                      width: width,
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              pageController.animateToPage(0,
                                  duration: const Duration(microseconds: 100),
                                  curve: Curves.easeInOut);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const Text(
                            "Settings",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const CircleAvatar(
                            backgroundColor: Colors.transparent,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListTile(
                                leading: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Profile(),
                                        ));
                                  },
                                  child: Container(
                                    height: height * 0.08,
                                    width: width * 0.14,
                                    decoration: const BoxDecoration(
                                        color: Colors.amber,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                "images/mazari.jpg"))),
                                  ),
                                ),
                                title: Text(
                                  StaticData.model!.name!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: const Text(
                                  "Never give up",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ),
                                trailing: const Icon(Icons.qr_code),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: height * 0.065,
                                    width: width * 0.2,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        shape: BoxShape.circle),
                                    child: const Icon(Icons.key_outlined),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Account",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        "Privacy, security change number",
                                        style: TextStyle(fontSize: 11),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: height * 0.065,
                                    width: width * 0.2,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        shape: BoxShape.circle),
                                    child: const Icon(Icons.chat_outlined),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Chat",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        "Chat history,theme,wallpapers",
                                        style: TextStyle(fontSize: 11),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: height * 0.065,
                                    width: width * 0.2,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        shape: BoxShape.circle),
                                    child: const Icon(Icons.key_outlined),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Notifications",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        "Messages, group and others",
                                        style: TextStyle(fontSize: 11),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: height * 0.065,
                                    width: width * 0.2,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        shape: BoxShape.circle),
                                    child: const Icon(Icons.help_outline),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Help",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        "Help center,contact us, privacy policy",
                                        style: TextStyle(fontSize: 11),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: height * 0.065,
                                    width: width * 0.2,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        shape: BoxShape.circle),
                                    child: const Icon(Icons.swap_vert_outlined),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Storage and data",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        "Network usage, storage usage",
                                        style: TextStyle(fontSize: 11),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: height * 0.065,
                                    width: width * 0.2,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        shape: BoxShape.circle),
                                    child: const Icon(Icons.logout_outlined),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await FirebaseAuth.instance.signOut();

                                      // ignore: use_build_context_synchronously
                                      showMySnackbar(
                                          context, "Logout successful");

                                      Get.offAll(() => const LoginScreen(),
                                          transition: Transition.rightToLeft);
                                    },
                                    child: const Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _index,
            onTap: (value) {
              pageController.animateToPage(value,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
              setState(() {
                _index = value;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.message), label: "All friends"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: "AllUsers"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "Settings",
                  backgroundColor: Colors.white)
            ]),
      ),
    );
  }
}
