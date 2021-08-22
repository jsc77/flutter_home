import 'package:firebase_auth/firebase_auth.dart';
import 'package:hq/services/dm.dart';

class AuthenticationServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createNewUser(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await DM().createUserData(name, "admin", 100, user.uid);
      return user;
    } catch (e) {
      print(e.toString());
    }
  }
}
