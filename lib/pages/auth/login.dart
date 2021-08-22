import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hq/pages/auth/signup.dart';
import 'package:hq/services/auth_class.dart';
import 'package:hq/pages/home/home_screen.dart';
import 'package:hq/widgets/mytextform_field.dart';
import 'package:hq/widgets/password_textformfield.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

bool obserText = true;

class _LoginState extends State<Login> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool circular = false;
  String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.indigo[800],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "ログイン",
                    style: TextStyle(
                        fontFamily: "Kyo",
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  googleLoginButton("assets/google.svg", "Googleログイン", 25, () {
                    AuthClass().googleSignIn(context);
                  }),
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                    "または",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  MyTextFormField(
                    name: "Eメール..",
                    onChanged: (value) {
                      setState(() {
                        email = value;
                        print(email);
                      });
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  PasswordTextFormField(
                      obserText: obserText,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                          print(password);
                        });
                      },
                      name: "パスワード..",
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          obserText = !obserText;
                        });
                      }),
                  SizedBox(
                    height: 40,
                  ),
                  colorButton(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "IDお持ちで方は",
                        style: TextStyle(
                          fontFamily: "Ryo",
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (builder) => SignUp()),
                              (route) => false);
                        },
                        child: Text(
                          "『会員登録』",
                          style: TextStyle(
                            fontFamily: "Ryo",
                            color: Colors.yellow[600],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget colorButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        try {
          loginUser();
        } on FirebaseAuthException catch (e) {
          // final snackbar = SnackBar(content: Text(e.toString()));
          // ScaffoldMessenger.of(context).showSnackBar(snackbar);
          // setState(() {
          //   circular = false;
          // });
          if (e.code == 'user-not-found') {
            final snackbar = SnackBar(
                backgroundColor: Colors.white,
                duration: Duration(seconds: 3),
                content: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: Colors.indigo[800],
                    ),
                    SizedBox(width: 20),
                    Expanded(
                        child: Text(
                      "登録されていないEメールです。",
                      style: TextStyle(
                          fontFamily: "Kyo",
                          color: Colors.indigo[800],
                          fontSize: 20),
                    ))
                  ],
                ));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            setState(() {
              circular = false;
            });
          } else if (e.code == 'wrong-password') {
            final snackbar = SnackBar(
                backgroundColor: Colors.white,
                duration: Duration(seconds: 3),
                content: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: Colors.indigo[800],
                    ),
                    SizedBox(width: 20),
                    Expanded(
                        child: Text(
                      "パスワードが一致しておりません。",
                      style: TextStyle(
                          fontFamily: "Kyo",
                          color: Colors.indigo[800],
                          fontSize: 20),
                    ))
                  ],
                ));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            setState(() {
              circular = false;
            });
          } else {
            final snackbar = SnackBar(
                backgroundColor: Colors.white,
                duration: Duration(seconds: 3),
                content: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: Colors.indigo[800],
                    ),
                    SizedBox(width: 20),
                    Expanded(
                        child: Text(
                      "正しいEメールを入力してください",
                      style: TextStyle(
                          fontFamily: "Kyo",
                          color: Colors.indigo[800],
                          fontSize: 20),
                    ))
                  ],
                ));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            setState(() {
              circular = false;
            });
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Center(
          child: circular
              ? CircularProgressIndicator()
              : Text(
                  "ログイン",
                  style: TextStyle(
                    fontFamily: "Kyo",
                    color: Colors.indigo[800],
                    fontSize: 20,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    setState(() {
      circular = false;
    });
    if (userCredential == null) {
      print(userCredential.toString());
    } else {
      await FirebaseFirestore.instance
          .collection('/profile')
          .where('uid', isEqualTo: userCredential.user.uid)
          .get()
          .then((e) {
        if (e.docs.isNotEmpty) {
          Map<String, dynamic> documentData = e.docs.single.data();
          final snackBar = SnackBar(
              backgroundColor: Colors.white,
              duration: Duration(seconds: 3),
              content: Row(
                children: [
                  Icon(
                    Icons.message_rounded,
                    color: Colors.indigo[800],
                  ),
                  SizedBox(width: 20),
                  Expanded(
                      child: Text(
                    documentData['displayName'] + "様への新着通知は３件です",
                    style: TextStyle(
                        fontFamily: "Kyo",
                        color: Colors.indigo[800],
                        fontSize: 20),
                  ))
                ],
              ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomeScreen()),
          (route) => false);
      setState(() {
        circular = false;
      });
    }
  }

  Widget googleLoginButton(
      String imagepath, String buttonName, double size, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          color: Colors.black,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagepath,
                height: size,
                width: size,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                buttonName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
