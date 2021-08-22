import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hq/pages/home/no_auth.dart';
import 'package:hq/pages/home/no_auth_wait.dart';
import 'package:hq/services/dm.dart';
import 'package:hq/pages/home/home_page.dart';

class AuthClass {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> googleSignIn(BuildContext context) async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    if (googleSignInAccount != null) {
      await _auth.signInWithCredential(credential);
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new NoAuth()));
    }
  }

  Future<void> requestAuth(BuildContext context) async {
    await DM().createUserData(
        _auth.currentUser.displayName, "guest", 100, _auth.currentUser.uid);
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new NoAuthWait()));
  }

  Future<void> haveAuth(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('profile')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((docs) {
      if (docs.docs[0].exists) {
        if (docs.docs[0].data()['role'] == 'guest') {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new NoAuthWait()));
        } else if (docs.docs[0].data()['role'] == 'admin') {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new HomePage()));
        }
      }
    });
  }

  Future<void> signOut({BuildContext context}) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      final snackBar = SnackBar(
          backgroundColor: Colors.white,
          duration: Duration(seconds: 3),
          content: Row(
            children: [
              Icon(
                Icons.logout_outlined,
                color: Colors.indigo[800],
              ),
              SizedBox(width: 20),
              Expanded(
                  child: Text(
                "ご利用ありがとうございました。",
                style: TextStyle(
                    fontFamily: "Kyo", color: Colors.indigo[800], fontSize: 20),
              ))
            ],
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
