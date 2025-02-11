// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:firestoreproject2/Screens/ChangeName.dart';
import 'package:firestoreproject2/Screens/Change_Pass.dart';
import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  var height, width;
  final picker = ImagePicker();
  File? image;

  void show() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeNameScreen(),
                      ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.edit),
                    Text(
                      "Edit Name",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePassScreen(),
                      ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.change_circle),
                    Text(
                      "Change Password",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.logout),
                  Text(
                    "Logout",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: width,
          height: height,
          color: Colors.black,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Stack(
                children: [
                  Container(
                    height: height * 0.11,
                    width: width * 0.2,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                  Positioned(
                    top: height * .05,
                    left: width * .085,
                    child: MaterialButton(
                        shape: const CircleBorder(),
                        color: Colors.white,
                        minWidth: width * .0,
                        height: height * .035,
                        onPressed: () {},
                        child: const Icon(Icons.edit)),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Text(
                StaticData.model!.name!,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xffFFFFFF),
                    fontSize: 20),
              ),
              Text(
                StaticData.model!.email!,
                style: const TextStyle(fontSize: 14, color: Color(0xff797C7B)),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(
                    Icons.message_outlined,
                    color: Colors.white,
                  ),
                  const Icon(
                    Icons.videocam_outlined,
                    color: Colors.white,
                  ),
                  const Icon(
                    Icons.call_outlined,
                    color: Colors.white,
                  ),
                  InkWell(
                    onTap: () {
                      show();
                    },
                    child: const Icon(
                      Icons.more_horiz_outlined,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Expanded(
                child: Container(
                  width: width,
                  height: height,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Display Name",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            StaticData.model!.name!,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          const Text(
                            "Email Address",
                            style: TextStyle(
                                fontSize: 15, color: Color(0xff797C7B)),
                          ),
                          Text(
                            StaticData.model!.email!,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          const Text(
                            "Address",
                            style: TextStyle(
                                fontSize: 15, color: Color(0xff797C7B)),
                          ),
                          const Text(
                            "Near Abbasea campus,Bawalpur",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          const Text(
                            "Phone Number",
                            style: TextStyle(
                                fontSize: 15, color: Color(0xff797C7B)),
                          ),
                          const Text(
                            "03494250613",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Media Shared",
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xff797C7B)),
                              ),
                              Text(
                                "View All",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: height * 0.12,
                                width: width * 0.25,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "images/Rectangle 1154.png"))),
                              ),
                              Container(
                                height: height * 0.12,
                                width: width * 0.25,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "images/Rectangle 1155.png"))),
                              ),
                              Container(
                                height: height * 0.12,
                                width: width * 0.25,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("images/255.jpg"))),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
