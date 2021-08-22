import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hq/pages/auth/login.dart';
import 'package:hq/pages/home/home_screen.dart';
import 'package:hq/services/Authentication.dart';
import 'package:hq/widgets/mytextform_field.dart';
import 'package:hq/widgets/password_textformfield.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

bool obserText = true;

class _SignUpState extends State<SignUp> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool circular = false;
  String name, email, password;

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
              Text(
                "会員登録",
                style: TextStyle(
                  fontFamily: "Kyo",
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              MyTextFormField(
                name: "お名前..",
                onChanged: (value) {
                  setState(() {
                    name = value;
                    print(name);
                  });
                },
              ),
              SizedBox(
                height: 15,
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
                  name: "パスワード",
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
                    "IDお持ちの方は",
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
                          MaterialPageRoute(builder: (builder) => Login()),
                          (route) => false);
                    },
                    child: Text(
                      "『ログイン』",
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
          createUser();
        } on FirebaseAuthException catch (e) {
          // final snackbar = SnackBar(content: Text(e.toString()));
          // ScaffoldMessenger.of(context).showSnackBar(snackbar);
          // setState(() {
          //   circular = false;
          // });
          if (e.code == 'email-already-in-use') {
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
                      "すでに登録されているEメールです。",
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
          } else if (e.code == 'weak-password') {
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
                      "パスワードは６文字以上でお願いします。",
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
                  "新規登録",
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

  Widget textItem(String labeltext, TextEditingController controller) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1.5,
              color: Colors.amber,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createUser() async {
    dynamic result =
        await AuthenticationServices().createNewUser(name, email, password);
    setState(() {
      circular = false;
    });
    if (result == null) {
      print(result.toString());
    } else {
      await FirebaseFirestore.instance
          .collection('/profile')
          .where('uid', isEqualTo: result.user.uid)
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
}
