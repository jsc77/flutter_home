import 'package:clip_shadow/clip_shadow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hq/pages/pika/upload_tab.dart';
import 'package:hq/widgets/helper.dart';

class UpdatePage extends StatefulWidget {
  final String id;
  UpdatePage({Key key, this.id}) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final _formKey = GlobalKey<FormState>();

  // Updaing Student
  CollectionReference pika = FirebaseFirestore.instance.collection('pika');

  Future<void> updateUser(id, name, room) {
    return pika
        .doc(id)
        .update({'name': name, 'room': room})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("情報更新"),
      ),
      body: Form(
          key: _formKey,
          // Getting Specific Data by ID
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('pika')
                .doc(widget.id)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                print('Something Went Wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var data = snapshot.data.data();
              var name = data['name'];
              var room = data['room'];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Stack(
                      children: [
                        ClipShadow(
                          clipper: MyClipper(),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 15),
                                blurRadius: 10),
                          ],
                          child: Container(
                            width: double.infinity,
                            height: Helper.getScreenHeight(context) * 0.5,
                            decoration: ShapeDecoration(
                                color: Colors.orange,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        Center(
                          heightFactor: 4,
                          child: Image.asset(
                            Helper.getAssetName("upload.png"),
                            width: 100,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        initialValue: name,
                        autofocus: false,
                        onChanged: (value) => name = value,
                        decoration: InputDecoration(
                          labelText: 'お名前: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        initialValue: room,
                        autofocus: false,
                        onChanged: (value) => room = value,
                        decoration: InputDecoration(
                          labelText: '部屋: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Email';
                          } else if (!value.contains('番')) {
                            return 'Please Enter Valid Email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, otherwise false.
                                if (_formKey.currentState.validate()) {
                                  updateUser(widget.id, name, room);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                '更新',
                                style:
                                    TextStyle(fontFamily: "Kyo", fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                pika.doc(widget.id).update({
                                  'img':
                                      'https://firebasestorage.googleapis.com/v0/b/home-321408.appspot.com/o/normal.png?alt=media&token=3dc2582f-1378-4676-8dd8-299d65614b93'
                                });
                                Navigator.pop(context);
                              },
                              child: Text(
                                '復旧',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.orange),
                                  shape: MaterialStateProperty.all(
                                      StadiumBorder(
                                          side: BorderSide(
                                              color: Colors.orange,
                                              width: 2)))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
