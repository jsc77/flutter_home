import 'package:cloud_firestore/cloud_firestore.dart';

class DM {
  final CollectionReference profileList =
      FirebaseFirestore.instance.collection('profile');
  Future<void> createUserData(
      String name, String role, int time, String uid) async {
    return await profileList
        .doc(uid)
        .set({'displayName': name, 'role': role, 'time': time, 'uid': uid});
  }

  Future updateUserList(String name, int time, String uid) async {
    return await profileList
        .doc(uid)
        .update({'displayName': name, 'time': time, 'uid': uid});
  }

  Future getUsersList() async {
    List itemsList = [];
    try {
      await profileList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data);
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
