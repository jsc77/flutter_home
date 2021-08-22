import 'package:flutter/material.dart';
import 'package:hq/pages/home/home_page.dart';
import 'package:hq/pages/pika/pika_list.dart';
import 'package:hq/pages/pika/upload.dart';

class PikaHome extends StatefulWidget {
  @override
  _PikaHomeState createState() => _PikaHomeState();
}

class _PikaHomeState extends State<PikaHome> {
  Future<void> moveToLastScreen() async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (cts) => HomePage()));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => moveToLastScreen(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepOrangeAccent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back_ios_new),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (cts) => HomePage()));
                  }),
              Text(
                '起床一覧',
                style: TextStyle(
                  fontFamily: 'Kyo',
                  fontSize: 20,
                ),
              ),
              ElevatedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Upload(),
                    ),
                  )
                },
                child: Text(
                  '追加',
                  style: TextStyle(
                    fontFamily: 'Kyo',
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.indigo),
              )
            ],
          ),
        ),
        body: ListStudentPage(),
      ),
    );
  }
}
