import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hq/model/item.dart';
import 'package:hq/pages/home/home_page.dart';

class GoodPage extends StatefulWidget {
  ItemModel itemModel;
  GoodPage({this.itemModel});
  @override
  _GoodPageState createState() => _GoodPageState();
}

class _GoodPageState extends State<GoodPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("現在状況",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.amber.withOpacity(0.8),
                            fontWeight: FontWeight.bold))),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("更新時間：" + widget.itemModel.time,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54.withOpacity(0.5),
                            fontWeight: FontWeight.bold))),
                Container(
                  height: MediaQuery.of(context).size.width * 0.3,
                  padding: EdgeInsets.all(20),
                  child: CachedNetworkImage(
                    imageUrl: widget.itemModel.img,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("利用者様",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.amber.withOpacity(0.8),
                            fontWeight: FontWeight.bold))),
                Container(
                  height: MediaQuery.of(context).size.width * 0.5,
                  padding: EdgeInsets.all(20),
                  child: CachedNetworkImage(
                    imageUrl: widget.itemModel.profile,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("名前：" + widget.itemModel.name,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black54.withOpacity(0.5),
                            fontWeight: FontWeight.bold))),
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("部屋番号：" + widget.itemModel.room,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black54.withOpacity(0.5),
                            fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Positioned(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (builder) => HomePage()));
                  },
                  child: ClipPath(
                    clipper: BottomCustomClipper(),
                    child: Container(
                      color: Colors.orange,
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.only(bottom: 30),
                          child: Text("戻る",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class BottomCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, 40);
    path.quadraticBezierTo(size.width / 4, 0, size.width / 2, 0);
    path.quadraticBezierTo(size.width - size.width / 4, 0, size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
