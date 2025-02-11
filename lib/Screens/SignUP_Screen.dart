// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestoreproject2/Screens/Login_Screen.dart';
import 'package:firestoreproject2/Models/Model.dart';
import 'package:firestoreproject2/components/clickbutton.dart';
import 'package:firestoreproject2/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SignUp_Screen extends StatefulWidget {
  const SignUp_Screen({super.key});

  @override
  State<SignUp_Screen> createState() => _SignUp_ScreenState();
}

// ignore: camel_case_types
class _SignUp_ScreenState extends State<SignUp_Screen> {
  var height, width;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  bool isPasswordVisible = false;

  Future<void> userSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    var uid = const Uuid();
    String userId = uid.v4();

    Chatbox model = Chatbox(
        name: namecontroller.text,
        email: emailController.text,
        password: passwordController.text,
        userid: userId);

    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(model.toMap());
    emailController.clear();
    namecontroller.clear();
    passwordController.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Account Created Successfully",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      backgroundColor: Colors.blue,
    ));

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Login_Screen(),
          ));
    });
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.11,
                  ),
                  const Text(
                    "Sign Up to Chatbox",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const Text(
                    "Welcome to chatbox! Sign up using your social\n              account or email to continue us",
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
                            lableText: "Your Name",
                            hinttext: "Name",
                            controller: namecontroller,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Name Cannot be Empty";
                              } else if (value.length < 3) {
                                return "name must be at least 3 charachtor";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          MyTextfield(
                            lableText: "Your Email",
                            hinttext: "Email",
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please Enter Your Email";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          MyTextfield(
                            lableText: "Your Password",
                            hinttext: "Password",
                            controller: passwordController,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please Enter Your Password";
                              } else if (value.length < 6) {
                                return "Password must be at least 6 charactors";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          CustomdButton(
                              onPressed: () {
                                userSignUp();
                              },
                              text: 'SignUp'),
                        ],
                      )),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Existing account?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      TextButton(
                        style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.white)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login_Screen(),
                              ));
                        },
                        child: const Text(
                          "Login",
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
