import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hq/pages/auth/login.dart';
import 'package:hq/widgets/constant.dart';
import 'package:hq/widgets/helper.dart';
import 'package:hq/pages/home/home_page.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, streamSnapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                      body: Center(
                    child: Text("Error: ${streamSnapshot.error}"),
                  ));
                }
                if (streamSnapshot.connectionState == ConnectionState.active) {
                  User _user = streamSnapshot.data;
                  if (_user == null) {
                    return Login();
                  } else {
                    return HomePage();
                  }
                }

                return Scaffold(
                  body: Container(
                    width: Helper.getScreenWidth(context),
                    height: Helper.getScreenHeight(context),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.network(
                              "https://firebasestorage.googleapis.com/v0/b/home-321408.appspot.com/o/gaioga.gif?alt=media&token=2091c9fa-721e-4dd6-9de9-bd3edc3be0f8"),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity * 0.5,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(children: [
                              Flexible(child: Text("HAPPY DAY!")),
                              Spacer(),
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        }
        return Scaffold(
          body: Center(
            child: Text(
              "Initialization App...",
              style: Constants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}
