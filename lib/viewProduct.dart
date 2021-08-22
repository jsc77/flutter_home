import 'package:flutter/material.dart';
import 'package:hq/widgets/customClipper.dart';
import 'package:hq/dataset.dart';

class ViewProduct extends StatelessWidget {
  final Item product;
  ViewProduct(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 80, bottom: 50),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                      GestureDetector(
                        onTap: () {
                          print("home");
                        },
                        child: Icon(Icons.home_filled),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.width / 1.5,
                  padding: EdgeInsets.all(20),
                  child: Image(
                    image: AssetImage(product.profile),
                    width: 200,
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(product.name,
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold))),
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("名前：" + product.detail,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black54.withOpacity(0.5),
                            fontWeight: FontWeight.bold))),
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("血糖値：" + product.price.toString() + "/秒",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.redAccent.withOpacity(0.8),
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
                    Navigator.pop(context);
                  },
                  child: ClipPath(
                    clipper: BottomCustomClipper(),
                    child: Container(
                      color: Colors.red,
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
    );
  }
}
