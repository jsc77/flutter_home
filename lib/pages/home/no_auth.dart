import 'package:flutter/material.dart';
import 'package:hq/services/auth_class.dart';

class NoAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(Colors.orange),
                  shape: MaterialStateProperty.all(StadiumBorder(
                      side: BorderSide(color: Colors.orange, width: 2)))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.portrait_outlined, size: 28),
                  SizedBox(width: 16),
                  Text(
                    "職員接続",
                    style: TextStyle(fontFamily: "Kyo", fontSize: 20),
                  ),
                ],
              ),
              onPressed: () {
                AuthClass().haveAuth(context);
              },
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(Colors.orange),
                  shape: MaterialStateProperty.all(StadiumBorder(
                      side: BorderSide(color: Colors.orange, width: 2)))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.mail_outlined, size: 28),
                  SizedBox(width: 16),
                  Text(
                    "権限リクエスト",
                    style: TextStyle(fontFamily: "Kyo", fontSize: 20),
                  ),
                ],
              ),
              onPressed: () {
                AuthClass().requestAuth(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
