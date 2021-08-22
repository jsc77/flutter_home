import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hq/services/firebase_api.dart';
import 'package:hq/pages/pika/saved_tab.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hq/widgets/helper.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

bool obserText = true;

class _UploadState extends State<Upload> {
  UploadTask task;
  File file;
  String url;
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file.path) : 'No File';

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: Colors.blue[900],
        width: Helper.getScreenWidth(context),
        height: Helper.getScreenHeight(context),
        child: SafeArea(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Column(
            children: [
              Text(
                "画像\n登録",
                style: TextStyle(
                    fontFamily: "Kyo", fontSize: 60, color: Colors.white),
              ),
              Spacer(),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Colors.orange),
                    shape: MaterialStateProperty.all(StadiumBorder(
                        side: BorderSide(color: Colors.orange, width: 2)))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_file, size: 28),
                    SizedBox(width: 16),
                    Text(
                      "画像選択",
                      style: TextStyle(fontFamily: "Kyo", fontSize: 20),
                    ),
                  ],
                ),
                onPressed: selectFile,
              ),
              Text(
                fileName,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.greenAccent),
              ),
              Spacer(),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Colors.orange),
                    shape: MaterialStateProperty.all(StadiumBorder(
                        side: BorderSide(color: Colors.orange, width: 2)))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload, size: 28),
                    SizedBox(width: 16),
                    Text(
                      "アップロード",
                      style: TextStyle(fontFamily: "Kyo", fontSize: 20),
                    ),
                  ],
                ),
                onPressed: uploadFile,
              ),
              Spacer(),
              task != null ? buildUploadStatus(task) : Container(),
              Spacer(),
              task != null
                  ? ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(StadiumBorder(
                              side:
                                  BorderSide(color: Colors.orange, width: 2)))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "次へ",
                            style: TextStyle(fontFamily: "Kyo", fontSize: 20),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: 28,
                            color: Colors.blue[900],
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SavedTab(imageURL: url)));
                      },
                    )
                  : Container(),
              Spacer(),
            ],
          ),
        )),
      ),
    ));
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;
    setState(() {
      file = File(path);
    });
  }

  Future uploadFile() async {
    if (file == null) return;
    final destination = basename(file.path);
    task = FirebaseApi.uploadFile("$destination", file);
    setState(() {});
    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');

    return url = urlDownload;
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '完了するまで\n少々お待ちください\n\n$percentage% 完了',
              style: TextStyle(
                  fontFamily: "Ryo", fontSize: 24, color: Colors.amber),
              textAlign: TextAlign.center,
            );
          } else {
            return Container();
          }
        },
      );
}
