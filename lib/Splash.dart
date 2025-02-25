// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:firestoreproject2/Screens/Home_Screen.dart';
import 'package:firestoreproject2/Screens/Login_Screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  getdataFromShrdprf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? fetchdata = prefs.getString("userId");
    if (fetchdata == null) {

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    } else {
      StaticData.loginId = fetchdata;

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    }
  }

  @override
  void initState() {
    getdataFromShrdprf();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
