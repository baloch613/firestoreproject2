import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestoreproject2/Models/Model.dart';
import 'package:firestoreproject2/Screens/AllUsers.dart';
import 'package:firestoreproject2/Screens/SettingScreen.dart';
import 'package:firestoreproject2/Screens/message_Screen.dart';
import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:flutter/material.dart';

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
            children: const[MessageScreen(), AllUserScreen(), SettingScreen()],
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
