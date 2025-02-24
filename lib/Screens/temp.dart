import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestoreproject2/Models/friend.dart';
import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:flutter/material.dart';

class TempScreen extends StatefulWidget {
  const TempScreen({super.key});

  @override
  State<TempScreen> createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen> {
  List<FriendModel> allfriendz = [];
  getAllfriendz() async {
    allfriendz.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('friendz')
        .where('userId', isEqualTo: StaticData.model!.userid)
        .get();
    for (var data in snapshot.docs) {
      FriendModel model =
          FriendModel.fromMap(data.data() as Map<String, dynamic>);
      setState(() {
        allfriendz.add(model);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllfriendz();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("all friends"),
      ),
      body: Column(
        children: [
          Container(height: 300,width: 400,
            child: ListView.builder(
              itemCount: allfriendz.length,
              itemBuilder: (context, index) {
                return Text(allfriendz[index].friendname!);
              },
            ),
          )
        ],
      ),
    );
  }
}
