import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestoreproject2/Splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.clearPersistence();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        scrollBehavior: NoOverGlow(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        home: const SplashScreen ());
  }
}

class NoOverGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return StretchingOverscrollIndicator(
      axisDirection: axisDirection,
      child: child,
    );
  }
}
