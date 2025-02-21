import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestoreproject2/Models/reqmodel.dart';
import 'package:firestoreproject2/Models/staticdata.dart';
import 'package:flutter/material.dart';


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
                            trailing: const Icon(Icons.people_alt_outlined),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ));
  }
}
