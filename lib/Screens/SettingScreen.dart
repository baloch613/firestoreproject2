import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:firestoreproject2/Screens/Login_Screen.dart';
import 'package:firestoreproject2/Screens/profile.dart';
import 'package:firestoreproject2/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
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
                  onTap: () {},
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const Text(
                  "Settings",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                  image: AssetImage("images/mazari.jpg"))),
                        ),
                      ),
                      title: Text(
                        StaticData.model?.name ?? "mazari",
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Account",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Chat",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Notifications",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Help",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Storage and data",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
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
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            await FirebaseAuth.instance.signOut();

                            await pref.clear();
                            // ignore: use_build_context_synchronously
                            showMySnackbar(context, "Logout successful");

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
    );
  }
}
