import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hq/pages/auth/login.dart';
import 'package:hq/pages/home/landing_page.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebasePushHandler);
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'key1',
        channelName: 'proto',
        channelDescription: 'noti',
        ledColor: Colors.white,
        playSound: true,
        enableLights: true,
        enableVibration: true)
  ]);
  runApp(MyApp());
}

Future<void> _firebasePushHandler(RemoteMessage message) async {
  print(message.data);
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

void notify(_model) async {
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'key1',
        channelName: 'proto',
        channelDescription: 'noti',
        ledColor: Colors.white,
        playSound: true,
        enableLights: true,
        enableVibration: true)
  ]);
  String timezone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 1,
        channelKey: 'key1',
        title: _model.name,
        body: _model.profile,
        bigPicture: _model.profile,
        notificationLayout: NotificationLayout.BigPicture),
    schedule:
        NotificationInterval(interval: 3, timeZone: timezone, repeats: false),
  );
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("エラー");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              theme: ThemeData(
                  elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue[900]),
                    shape: MaterialStateProperty.all(StadiumBorder()),
                    elevation: MaterialStateProperty.all(0),
                  )),
                  textTheme: TextTheme(
                      bodyText2:
                          TextStyle(color: Colors.black45, fontFamily: "Kyo"))),
              title: 'Flutter',
              home: Login(),
            );
          }
          return CircularProgressIndicator();
        });
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User>();
    if (firebaseuser != null) {
      return Text("ログイン");
    }
    return Text("ログイン失敗");
  }
}
