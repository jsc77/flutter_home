import 'package:clip_shadow/clip_shadow.dart';
import 'package:flutter/material.dart';
import 'package:hq/widgets/helper.dart';

class UploadTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: Helper.getScreenWidth(context),
            height: Helper.getScreenHeight(context),
            child: Stack(children: [
              Align(
                alignment: Alignment.topCenter,
                child: ClipShadow(
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
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    "アップロード",
                    style: TextStyle(fontSize: 40),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text("本当にアップロードしますか？")
                ]),
              ),
              SizedBox(
                height: 50,
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  Helper.getAssetName("upload.png"),
                  width: 200,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: Helper.getScreenHeight(context) * 0.3,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(children: [
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "確認",
                          style: TextStyle(fontFamily: "Kyo", fontSize: 20),
                        ),
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.orange),
                            shape: MaterialStateProperty.all(StadiumBorder(
                                side: BorderSide(
                                    color: Colors.orange, width: 2)))),
                        onPressed: () {},
                        child: Text(
                          "戻る",
                          style: TextStyle(fontFamily: "Kyo", fontSize: 20),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 20,
                    ),
                  ]),
                ),
              )
            ])));
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Offset controlPoint = Offset(size.width * 0.24, size.height);
    Offset endPoint = Offset(size.width * 0.25, size.height * 0.96);
    Offset controlPoint2 = Offset(size.width * 0.3, size.height * 0.78);
    Offset endPoint2 = Offset(size.width * 0.5, size.height * 0.78);
    Offset controlPoint3 = Offset(size.width * 0.7, size.height * 0.78);
    Offset endPoint3 = Offset(size.width * 0.75, size.height * 0.96);
    Offset controlPoint4 = Offset(size.width * 0.76, size.height);
    Offset endPoint4 = Offset(size.width * 0.79, size.height);
    Path path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width * 0.21, size.height)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..quadraticBezierTo(
          controlPoint2.dx, controlPoint2.dy, endPoint2.dx, endPoint2.dy)
      ..quadraticBezierTo(
          controlPoint3.dx, controlPoint3.dy, endPoint3.dx, endPoint3.dy)
      ..quadraticBezierTo(
          controlPoint4.dx, controlPoint4.dy, endPoint4.dx, endPoint4.dy)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
