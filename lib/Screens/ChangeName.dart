// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestoreproject2/Models/Model.dart';
import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:firestoreproject2/components/clickbutton.dart';
import 'package:firestoreproject2/components/my_textfield.dart';
import 'package:firestoreproject2/components/snackbar.dart';
import 'package:flutter/material.dart';

class ChangeNameScreen extends StatefulWidget {
  const ChangeNameScreen({super.key});

  @override
  State<ChangeNameScreen> createState() => _ChangeNameScreenState();
}

class _ChangeNameScreenState extends State<ChangeNameScreen> {
  var height, width;
  String oldName = "";

  TextEditingController new_NameController = TextEditingController();
  @override
  void initState() {
    oldName = StaticData.model!.name!;
    new_NameController.text = oldName;
    super.initState();
  }

  void updateName() async {
    if (new_NameController.text.trim().isEmpty) {
      new_NameController.clear();

      showMySnackbar(context, "Name is requried!");

      return;
    }

    if (new_NameController.text == StaticData.model!.name) {
      showMySnackbar(context, "You are using same Name  Pleae try new one!");
      return;
    } else {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(StaticData.model!.userid)
          .update({"name": new_NameController.text});

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("userid", isEqualTo: StaticData.model!.userid)
          .get();
      Chatbox model =
          Chatbox.fromMap(snapshot.docs[0].data() as Map<String, dynamic>);
      StaticData.model = model;

      // ignore: use_build_context_synchronously
      showMySnackbar(context, "Name updated successfully!");

      setState(() {
        new_NameController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
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
                SizedBox(
                  height: height * 0.25,
                ),
                const Text(
                  "Change Name",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 17),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                MyTextfield(
                  lableText: "Update Your Name",
                  controller: new_NameController,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomdButton(text: "Update Name", onPressed: updateName)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
