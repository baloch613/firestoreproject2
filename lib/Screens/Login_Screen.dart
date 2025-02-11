// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestoreproject2/Screens/Home_Screen.dart';
import 'package:firestoreproject2/Models/Model.dart';
import 'package:firestoreproject2/Screens/SignUP_Screen.dart';
import 'package:firestoreproject2/components/clickbutton.dart';
import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:firestoreproject2/components/my_textfield.dart';
import 'package:firestoreproject2/components/snackbar.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

// ignore: camel_case_types
class _Login_ScreenState extends State<Login_Screen> {
  var height, width;
  bool isPasswordVisible = false;

  late TextEditingController namecontroller;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final _formKey = GlobalKey<FormState>();
  Future<void> userLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: namecontroller.text)
        // .where("email", isEqualTo: emailController.text)
        .where("password", isEqualTo: passwordController.text)
        .get();

    if (snapshot.docs.isEmpty) {
      namecontroller.clear();
      passwordController.clear();

      // ignore: use_build_context_synchronously
      // MySnackbar.showSnackbar(context, "Name or password is incorrect!",
      // bgColor: Colors.red);

      // ignore: use_build_context_synchronously
      showMySnackbar(context, "Name or password is incorrect!");

      return;
    } else {
      Chatbox model =
          Chatbox.fromMap(snapshot.docs[0].data() as Map<String, dynamic>);

      StaticData.model = model;
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));

      passwordController.clear();

      // ignore: use_build_context_synchronously
      showMySnackbar(context, "Succefully logged in ${namecontroller.text}!");
      namecontroller.clear();
    }
  }

  @override
  void initState() {
    passwordController = TextEditingController();
    namecontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    namecontroller.dispose();
    super.dispose();
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.17,
                  ),
                  const Text(
                    "Login to Chatbox",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const Text(
                    "Welcome back! Sign in using your social\n     account or email to continue us",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: height * 0.06,
                        width: width * 0.15,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                            )),
                        child: const Icon(
                          Icons.facebook,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: height * 0.06,
                        width: width * 0.15,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            image: const DecorationImage(
                                image: AssetImage("images/googleicon.png"))),
                      ),
                      Container(
                        height: height * 0.06,
                        width: width * 0.15,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                            )),
                        child: const Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: height * 0.005,
                        width: width * 0.4,
                        color: Colors.white,
                      ),
                      const Text(
                        " or ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: height * 0.005,
                        width: width * 0.4,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyTextfield(
                            // lableText: "Your Name",
                            hinttext: "Name",
                            controller: namecontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Your Name";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          MyTextfield(
                            hinttext: "Password",
                            controller: passwordController,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Your Password";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          CustomdButton(
                              onPressed: () {
                                userLogin();
                              },
                              text: 'Login'),
                        ],
                      )),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("don't have an account?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      TextButton(
                        style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.white)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUp_Screen(),
                              ));
                        },
                        child: const Text(
                          "SignUp",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
