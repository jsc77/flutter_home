import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hq/dataset.dart';
import 'package:hq/pages/auth/login.dart';
import 'package:hq/model/item.dart';
import 'package:hq/pages/pika/good_page.dart';
import 'package:hq/pages/pika/pika_home.dart';
import 'package:hq/speech_text/maintab.dart';
import 'package:hq/services/um.dart';
import 'package:hq/speech_text/speech_text.dart';
import 'package:hq/widgets/category_box.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _search.dispose();
    super.dispose();
  }

  Map<String, dynamic> userMap;
  bool isLoading = false;
  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    setState(() {
      isLoading = true;
    });
    _firestore
        .collection('pika')
        .where("name", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        if (value.docs.length != 0) {
          userMap = value.docs[0].data();
          isLoading = false;
        } else {
          _firestore
              .collection('admin')
              .where("name", isEqualTo: "やり直してください")
              .get()
              .then((value2) => setState(() {
                    userMap = value2.docs[0].data();
                    isLoading = false;
                  }));
        }
      });
    });
  }

  bool homeColor = true;
  bool cartColor = false;
  bool aboutColor = false;
  bool contactColor = false;
  final user = FirebaseAuth.instance.currentUser;

  final ButtonStyle cancelButton = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );
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
    return WillPopScope(
      onWillPop: () async => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('ログアウト'),
            content: Text('ログアウトしますか?'),
            actions: [
              ElevatedButton(
                style: cancelButton,
                onPressed: () => Navigator.pop(context, false),
                child: Text('いいえ'),
              ),
              ElevatedButton(
                style: preceedButton,
                onPressed: () async {
                  // AuthClass().signOut(context: context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                      (route) => false);
                },
                child: Text('はい'),
              ),
            ],
          );
        },
      ),
      child: Scaffold(
        drawer: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('/profile')
                .doc(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              var profile = snapshot.data;
              return Drawer(
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                        accountName: Text(
                          profile["displayName"],
                          style: TextStyle(
                              fontFamily: "Kyo",
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.indigo[800],
                        ),
                        currentAccountPicture: CircleAvatar(
                            backgroundImage: AssetImage("assets/pika.png")),
                        accountEmail: Text(user.email)),
                    ListTile(
                      selected: homeColor,
                      onTap: () {
                        setState(() {
                          homeColor = true;
                          contactColor = false;
                          cartColor = false;
                          aboutColor = false;
                        });
                      },
                      leading: Icon(Icons.home),
                      title: Text("ホーム"),
                    ),
                    ListTile(
                      selected: aboutColor,
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (cts) => MainTab()));
                        setState(() {
                          aboutColor = true;
                          contactColor = false;
                          cartColor = false;
                          homeColor = false;
                        });
                      },
                      leading: Icon(Icons.image),
                      title: Text("報告"),
                    ),
                    ListTile(
                      selected: contactColor,
                      onTap: () {
                        UM().reportAccess(context);
                        setState(() {
                          contactColor = true;
                          homeColor = false;
                          cartColor = false;
                          aboutColor = false;
                        });
                      },
                      leading: Icon(Icons.receipt),
                      title: Text("報告事項"),
                    ),
                    ListTile(
                      onTap: () async => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('ログアウト'),
                            content: Text('ログアウトしますか?'),
                            actions: [
                              ElevatedButton(
                                style: cancelButton,
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('いいえ'),
                              ),
                              ElevatedButton(
                                style: preceedButton,
                                onPressed: () async {
                                  // await AuthClass().signOut(context: context);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => Login()),
                                      (route) => false);
                                },
                                child: Text('はい'),
                              ),
                            ],
                          );
                        },
                      ),
                      leading: Icon(Icons.exit_to_app),
                      title: Text("ログアウト"),
                    ),
                  ],
                ),
              );
            }),
        appBar: AppBar(
          title: Text(
            "ようこそ！",
            style: TextStyle(
              fontFamily: 'Kyo',
              fontSize: 20,
              color: Colors.indigo[900],
            ),
          ),
          backgroundColor: Colors.deepOrangeAccent,
          actions: [
            IconButton(
                icon: Icon(Icons.notification_add),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Speech()));
                }),
          ],
        ),
        backgroundColor: Colors.orange[300],
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: ShapeDecoration(
                      shape: StadiumBorder(), color: Colors.white),
                  child: TextField(
                    controller: _search,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        hintText: "名前を入れてください",
                        hintStyle: TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontFamily: "Kyo"),
                        helperStyle:
                            TextStyle(color: Colors.amber, fontSize: 18),
                        contentPadding: const EdgeInsets.all(15)),
                  ),
                ),
                Center(
                    child: ElevatedButton(
                  onPressed: onSearch,
                  child: Text("検索！",
                      style: TextStyle(fontSize: 20, fontFamily: "Kyo")),
                )),
                userMap != null
                    ? Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 10.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(10, 10))
                            ],
                            color: Colors.green[400],
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          onTap: () {
                            ItemModel model = ItemModel.fromJson(userMap);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GoodPage(itemModel: model)));
                          },
                          tileColor: Colors.amber,
                          selectedTileColor: Colors.blue[900],
                          leading: CachedNetworkImage(
                            imageUrl: userMap['img'],
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          trailing: Icon(Icons.important_devices_outlined),
                          title: Text(
                            userMap['name'],
                            style: TextStyle(fontSize: 25, fontFamily: "Kyo"),
                          ),
                          subtitle: Text(
                            userMap['time'],
                            style: TextStyle(fontSize: 20, fontFamily: "Kyo"),
                          ),
                        ),
                      )
                    : Container(),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('pika')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
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
                        height: 200,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: storedocs.length,
                            itemBuilder: (BuildContext context, int index) {
                              ItemModel model = ItemModel.fromJson(
                                  snapshot.data.docs[index].data());
                              return RectWidth(model: model);
                            }),
                      );
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('個人室',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PikaHome()));
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 8, bottom: 8),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "項目",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('pika')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
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
                        height: 200,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: storedocs.length,
                            itemBuilder: (BuildContext context, int index) {
                              ItemModel model = ItemModel.fromJson(
                                  snapshot.data.docs[index].data());
                              return CategoryCard(model: model);
                            }),
                      );
                    }),
                NewCategoryRect(list: suggestList),
                SizedBox(
                  height: 120,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
