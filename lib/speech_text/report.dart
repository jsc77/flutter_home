import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('report').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('Something worng');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Row(
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      "データ読み込み中",
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              );
            }
            final List storedocs = [];
            snapshot.data.docs.map((DocumentSnapshot document) {
              Map a = document.data() as Map<String, dynamic>;
              storedocs.add(a);
              a['id'] = document.id;
            }).toList();
            return ListView.builder(
                itemCount: storedocs.length,
                itemBuilder: (_, index) {
                  return SingleChildScrollView(
                    child: Card(
                      margin: EdgeInsets.all(15),
                      color: Colors.indigo[900],
                      child: Container(
                        color: Colors.white,
                        margin: EdgeInsets.all(1.5),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Image.network(
                              storedocs[index]["imageURL"],
                              fit: BoxFit.cover,
                              height: 100,
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Text(
                              storedocs[index]["name"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Kyo",
                                  fontSize: 25),
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Text(
                              "内容： " + storedocs[index]["body"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Ryo",
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
