import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hq/speech_text/report.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainTab extends StatefulWidget {
  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  File imageFile;
  var _formKey = GlobalKey<FormState>();
  String name, body;

  final nameController = TextEditingController();
  final bodyController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  clearText() {
    nameController.clear();
    bodyController.clear();
    imageFile = null;
  }

  CollectionReference report = FirebaseFirestore.instance.collection('report');

  Future<void> upload() async {
    if (_formKey.currentState.validate()) {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("images")
          .child(new DateTime.now().millisecondsSinceEpoch.toString() +
              "." +
              imageFile.path);
      UploadTask uploadTask = reference.putFile(imageFile);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      var url = imageUrl.toString();
      report.add({
        'name': name,
        'body': body,
        'imageURL': url,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[800],
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  child: imageFile == null
                      ? TextButton(
                          onPressed: () {
                            _showDialog();
                          },
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.indigo,
                            size: 50,
                          ))
                      : Image.file(
                          imageFile,
                          width: 200,
                          height: 200,
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'お名前: ',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'お名前を入力してください';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: '内容: ',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    controller: bodyController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '内容を入力してください';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.indigo[900])),
                    )),
                    onPressed: () {
                      if (imageFile == null) {
                        Fluttertoast.showToast(
                            msg: "画像を選んでください",
                            gravity: ToastGravity.CENTER,
                            toastLength: Toast.LENGTH_LONG,
                            timeInSecForIosWeb: 2);
                      } else {
                        name = nameController.text;
                        body = bodyController.text;
                        upload();
                        clearText();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Report()));
                        if (this._formKey.currentState.validate()) {
                          Get.snackbar(
                            '저장완료!',
                            '폼 저장이 완료되었습니다!',
                            backgroundColor: Colors.white,
                          );
                        }
                      }
                    },
                    child: Text(
                      "アップロード",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("どこから写真を読み込みますか？"),
              content: TextButton(
                  child: Text('ギャラリー'),
                  onPressed: () {
                    openGallary();
                  }));
        });
  }

  Future<void> openGallary() async {
    final picker = ImagePicker();
    XFile pickedFile = await picker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = File(pickedFile.path);
    });
    Navigator.of(context, rootNavigator: true).pop();
  }
}
