import 'package:firestoreproject2/Models/Model.dart';

class StaticData {
  static Chatbox? model;
}
//static for allusers list
// class StaticDataAlluser {
//   static List<Chatbox> allUsers = [];

//   static Future<void> getAllUsers() async {
//     allUsers.clear();
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection("users")
//         .where("userid", isNotEqualTo: StaticData.model!.userid)
//         .get();
//     for (var user in snapshot.docs) {
//       Chatbox model = Chatbox.fromMap(user.data() as Map<String, dynamic>);
//       allUsers.add(model);
//     }
//   }
// }
