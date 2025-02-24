import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestoreproject2/Models/friend.dart';
import 'package:firestoreproject2/Models/reqmodel.dart';
import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  List<ReqModel> allrequests = [];
  getAllRequets() async {
    allrequests.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('reciverId', isEqualTo: StaticData.model!.userid)
        .get();

    for (var data in snapshot.docs) {
      ReqModel model = ReqModel.fromMap(data.data() as Map<String, dynamic>);
      setState(() {
        allrequests.add(model);
      });
    }
  }

  @override
  void initState() {
    getAllRequets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Friend requets!"),
        ),
        body: allrequests.isEmpty
            ? const Center(
                child: Text("no requests"),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: allrequests.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(),
                            title: Text(allrequests[index].senderName!),
                            trailing: InkWell(
                                onTap: () {
                                  // make instace for making unique id
                                  Uuid nuid = Uuid();

                                  //
                                  // sender name data
                                  String reqone = nuid.v4();
                                  FriendModel model1 = FriendModel(
                                      friendId: allrequests[index].senderId,
                                      friendname: allrequests[index].senderName,
                                      id: reqone,
                                      userId: allrequests[index].reciverId);

                                  FirebaseFirestore.instance
                                      .collection('friendz')
                                      .doc(reqone)
                                      .set(model1.toMap());
                                  // reciver data model

                                  String reqtwo = nuid.v4();
                                  FriendModel model2 = FriendModel(
                                      friendId: allrequests[index].reciverId,
                                      friendname:
                                          allrequests[index].reciverName,
                                      id: reqtwo,
                                      userId: allrequests[index].senderId);
                                  FirebaseFirestore.instance
                                      .collection('friendz')
                                      .doc(reqtwo)
                                      .set(model2.toMap());
                                  FirebaseFirestore.instance
                                      .collection('requests')
                                      .doc(allrequests[index].requestId)
                                      .delete();
                                  setState(() {
                                    allrequests.removeAt(index);
                                  });
                                },
                                child: const Icon(Icons.people_alt_outlined)),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ));
  }
}
