import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestoreproject2/Models/Model.dart';
import 'package:firestoreproject2/Models/reqmodel.dart';
import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({super.key});

  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  List<Chatbox> allUsers = [];

  getAllUsers() async {
    allUsers.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("userid", isNotEqualTo: StaticData.model!.userid)
        .get();
    for (var user in snapshot.docs) {
      Chatbox model = Chatbox.fromMap(user.data() as Map<String, dynamic>);
      if (mounted) {
        setState(() {
          allUsers.add(model);
        });
      }
    }
  }

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ),
              Text(
                "Calls",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              CircleAvatar(
                backgroundColor: Colors.transparent,
              )
            ],
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: width * 0.75, top: height * 0.02),
                    child: const Text(
                      "Recent",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: allUsers.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.white,
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundImage: AssetImage("images/mazari.jpg"),
                            ),
                            title: Text(allUsers[index].name!),
                            subtitle: Row(
                              children: const [
                                Icon(
                                  Icons.phone_callback,
                                  size: 17,
                                  color: Colors.green,
                                ),
                                Text("  Today,09:30 AM"),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.wifi_calling_outlined),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                    onTap: () async {
                                      Uuid uid = const Uuid();
                                      String reqId = uid.v4();

                                      ReqModel model = ReqModel(
                                          reciverId: allUsers[index].userid,
                                          reciverName: allUsers[index].name,
                                          requestId: reqId,
                                          senderId: StaticData.model!.userid,
                                          senderName: StaticData.model!.name,
                                          status: 'pending');

                                      await FirebaseFirestore.instance
                                          .collection('requests')
                                          .doc(reqId)
                                          .set(model.toMap());
                                    },
                                    child:
                                        const Icon(Icons.person_add_outlined))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
