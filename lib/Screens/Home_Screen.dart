import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestoreproject2/Models/reqmodel.dart';
import 'package:firestoreproject2/Screens/Chat_Screen.dart';
import 'package:firestoreproject2/Models/Model.dart';
import 'package:firestoreproject2/Screens/Login_Screen.dart';
import 'package:firestoreproject2/Screens/Request_Screen.dart';
import 'package:firestoreproject2/Screens/profile.dart';
import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:firestoreproject2/components/snackbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController pageController;

  int _index = 0;

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
