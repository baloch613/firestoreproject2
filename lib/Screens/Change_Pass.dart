// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestoreproject2/Models/Model.dart';
import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:firestoreproject2/components/clickbutton.dart';
import 'package:firestoreproject2/components/my_textfield.dart';
import 'package:firestoreproject2/components/snackbar.dart';
import 'package:flutter/material.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({super.key});

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  var height, width;
  String oldpass = "";
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  @override
  void initState() {
    oldpass = StaticData.model!.password!;
    super.initState();
  }

  void updatePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (oldpass != oldPasswordController.text) {
      showMySnackbar(context, "Incorrect old password. Please try again!");

      oldPasswordController.clear();
      newPassController.clear();
      confirmPassController.clear();
      return;
    } else {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(StaticData.model!.userid)
          .update({"password": newPassController.text});

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("userid", isEqualTo: StaticData.model!.userid)
          .get();
      Chatbox model =
          Chatbox.fromMap(snapshot.docs[0].data() as Map<String, dynamic>);
      StaticData.model = model;

  

      setState(() {
        oldpass = model.password!;
        oldPasswordController.clear();
        newPassController.clear();
        confirmPassController.clear();
        showMySnackbar(context, "Password Updaded successfully");
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back)),
                  ),
                  SizedBox(height: height * 0.15),
                  const Text(
                    "Update Your Password Now!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 17),
                  ),
                  SizedBox(height: height * 0.05),
                  MyTextfield(
                    controller: oldPasswordController,
                    lableText: "Current Password",
                    isPassword: true,
                    validator: (p0) {
                      if (p0 == null || p0.trim().isEmpty) {
                        return "Enter Your Current Password";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  MyTextfield(
                    controller: newPassController,
                    lableText: "New Password",
                    isPassword: true,
                    validator: (p0) {
                      if (p0 == null ||
                          p0.length < 6 ||
                          newPassController.text.trim().isEmpty) {
                        newPassController.clear();
                        return "Password must be at least 6 characters long!";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  MyTextfield(
                    controller: confirmPassController,
                    lableText: "Confirm  Password",
                    isPassword: true,
                    validator: (p0) {
                      if (newPassController.text.trim() !=
                              confirmPassController.text.trim() ||
                          newPassController.text.trim().isEmpty) {
                        confirmPassController.clear();
                        return "New and Confirm Password do not match!";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  CustomdButton(
                      text: "Update Password", onPressed: updatePassword)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
