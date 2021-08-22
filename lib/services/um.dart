import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hq/pages/auth/login.dart';
import 'package:hq/pages/home/home_page.dart';
import 'package:hq/pages/home/no_auth.dart';
import 'package:hq/pages/home/no_auth_wait.dart';
import 'package:hq/speech_text/report.dart';

class UM {
  Widget handle() {
    return new StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        }
        return NoAuth();
      },
    );
  }

  homeAccess(BuildContext context) {
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
      } else {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new NoAuth()));
      }
    });
  }

  reportAccess(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('/profile')
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((docs) {
      if (docs.docs[0].exists) {
        if (docs.docs[0].data()['role'] == 'admin') {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new Report()));
        } else {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new NoAuth()));
        }
      }
    });
  }
}
