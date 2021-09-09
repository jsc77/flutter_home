import 'package:flutter/material.dart';

class NoAuthWait extends StatefulWidget {
  @override
  _NoAuthWaitState createState() => _NoAuthWaitState();
}

class _NoAuthWaitState extends State<NoAuthWait> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "承認待ち中…\nお問い合わせ：jofew7@gmail.com",
              style: TextStyle(
                  fontSize: 20, fontFamily: "Kyo", color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
