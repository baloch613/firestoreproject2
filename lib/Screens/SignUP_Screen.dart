// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestoreproject2/Screens/Login_Screen.dart';
import 'package:firestoreproject2/Models/Model.dart';
import 'package:firestoreproject2/components/clickbutton.dart';
import 'package:firestoreproject2/components/my_textfield.dart';
import 'package:firestoreproject2/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: emailController.text)
        .get();
    if (snapshot.docs.isNotEmpty) {
      // ignore: use_build_context_synchronously
      showMySnackbar(context, "This email is already registered");
      return;
    }
    var uid = const Uuid();
    String userId = uid.v4();

    Chatbox model = Chatbox(
        name: namecontroller.text,
        email: emailController.text,
        password: passwordController.text,
        userid: userId);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(model.toMap());
    emailController.clear();
    namecontroller.clear();
    passwordController.clear();
    // ignore: use_build_context_synchronously
    showMySnackbar(context, "Account Created Successfully");

    Future.delayed(const Duration(seconds: 2), () {
      Get.off(() => const LoginScreen());
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
                    "Welcome to chatbox! Sign up using your social\naccount or email to continue us",
                    textAlign: TextAlign.center,
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
                            controller: namecontroller,
                            lableText: "Your Name",
                            hinttext: "Name",
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
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            validator: (value) {
                              final emailRegex = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                              if (value == null || value.trim().isEmpty) {
                                emailController.clear();
                                return "Please Enter Your Email";
                              }
                              if (!emailRegex.hasMatch(value)) {
                                return "Enter a valid email";
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
                                builder: (context) => const LoginScreen(),
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
