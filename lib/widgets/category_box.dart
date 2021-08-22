import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hq/dataset.dart';
import 'package:hq/main.dart';
import 'package:hq/model/item.dart';
import 'package:hq/pages/pika/good_page.dart';
import 'package:hq/viewProduct.dart';

class RectWidth extends StatelessWidget {
  ItemModel model;
  RectWidth({this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10, left: 10),
      width: MediaQuery.of(context).size.width - 130,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width - 120,
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54.withOpacity(0.14), blurRadius: 1),
                  ],
                  color: Colors.white),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: model.img,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Text(model.name,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GoodPage(itemModel: model)));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 30, right: 30, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "詳細",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    @required ItemModel model,
  })  : _model = model,
        super(key: key);
  final ItemModel _model;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 180,
            height: 220,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(color: Colors.purple.withOpacity(0.99), blurRadius: 3),
            ], shape: BoxShape.circle, color: Colors.white),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                CachedNetworkImage(
                  imageUrl: _model.img,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Text(_model.name,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>
                                    GoodPage(itemModel: _model)));
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 5, bottom: 8),
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "詳細",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () async {
                          notify(_model);
                          AwesomeNotifications()
                              .actionStream
                              .listen((receivedNotification) {
                            Navigator.of(context).pushNamed('/list');
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 8, right: 8, top: 5, bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.blue[900],
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "通知",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NewCategoryRect extends StatelessWidget {
  final List<Item> list;
  NewCategoryRect({this.list});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('多床室',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "項目",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
        Container(
            height: 250,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return RectHeight(product: list[index]);
                }))
      ],
    );
  }
}

class RectHeight extends StatelessWidget {
  final Item product;
  RectHeight({this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10, left: 10, bottom: 10),
      padding: EdgeInsets.only(top: 15),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 140,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54.withOpacity(0.14), blurRadius: 1),
                  ],
                  color: Colors.white),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(product.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewProduct(product)));
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 15, right: 15, top: 8, bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "詳細",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 21,
            top: -80,
            bottom: 0,
            child: Align(child: Image(image: AssetImage(product.image))),
          )
        ],
      ),
    );
  }
}
