import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hq/pages/pika/update_student_page.dart';

class ListStudentPage extends StatefulWidget {
  @override
  _ListStudentPageState createState() => _ListStudentPageState();
}

class _ListStudentPageState extends State<ListStudentPage> {
  final Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection('pika').snapshots();
  CollectionReference people = FirebaseFirestore.instance.collection('pika');
  Future<void> deleteUser(id) {
    return people
        .doc(id)
        .delete()
        .then((value) => print('削除'))
        .catchError((error) => print('削除失敗：$error'));
  }

  final ButtonStyle preceedButton = ElevatedButton.styleFrom(
    onPrimary: Colors.amber,
    primary: Colors.indigo[900],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: studentsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            storedocs.sort((a, b) {
              return b['time'].compareTo(a['time']);
            });
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(0.4),
                        1: FlexColumnWidth(0.2),
                        2: FlexColumnWidth(0.6),
                        3: FlexColumnWidth(0.5),
                      },
                      border: TableBorder.all(),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(children: [
                          TableCell(
                              child: Container(
                            height: 50,
                            color: Colors.indigo,
                            child: Center(
                              child: Text(
                                '写真',
                                style: TextStyle(
                                    fontFamily: 'Kyo',
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          )),
                          TableCell(
                              child: Container(
                            height: 50,
                            color: Colors.indigo,
                            child: Center(
                              child: Text(
                                '名前',
                                style: TextStyle(
                                    fontFamily: 'Kyo',
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          )),
                          TableCell(
                              child: Container(
                            height: 50,
                            color: Colors.indigo,
                            child: Center(
                              child: Text(
                                '更新時間',
                                style: TextStyle(
                                    fontFamily: 'Kyo',
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          )),
                          TableCell(
                              child: Container(
                            height: 50,
                            color: Colors.indigo,
                            child: Center(
                              child: Text(
                                '編集',
                                style: TextStyle(
                                    fontFamily: 'Kyo',
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          )),
                        ]),
                        for (var i = 0; i < storedocs.length; i++) ...[
                          TableRow(children: [
                            TableCell(
                              child: Container(
                                height: 50,
                                color: Colors.orangeAccent,
                                child: CachedNetworkImage(
                                  imageUrl: storedocs[i]['profile'],
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                height: 50,
                                color: Colors.orangeAccent,
                                child: Center(
                                  child: Text(
                                    storedocs[i]['name'],
                                    style: TextStyle(
                                        fontFamily: 'Ryo',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                                child: Container(
                              height: 50,
                              color: Colors.orangeAccent,
                              child: Center(
                                child: Text(
                                  storedocs[i]['time'],
                                  style: TextStyle(
                                      fontFamily: 'Ryo',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo),
                                ),
                              ),
                            )),
                            TableCell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () => {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateStudentPage(
                                                          id: storedocs[i]
                                                              ['id']),
                                                ))
                                          },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.indigo,
                                      )),
                                  IconButton(
                                      onPressed: () =>
                                          {deleteUser(storedocs[i]['id'])},
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ],
                              ),
                            ),
                          ]),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
