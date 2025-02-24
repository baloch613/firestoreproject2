// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:firestoreproject2/Screens/Home_Screen.dart';
import 'package:firestoreproject2/Screens/Login_Screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  var height, width;

  getDataFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? action = prefs.getString('userid');
    if (action == null) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }));
      });
    } else {
      StaticData.userid = action;
      Future.delayed(Duration(seconds: 3), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const HomeScreen();
        }));
      });
    }
  }

  @override
  void initState() {
    getDataFromSF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "C",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.green),
            ),
            Text(
              "Chatbox",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
