import 'package:clip_shadow/clip_shadow.dart';
import 'package:flutter/material.dart';
import 'package:hq/widgets/helper.dart';

class BottomTabs extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;
  BottomTabs({this.selectedTab, this.tabPressed});

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedTab = 1;

  @override
  Widget build(BuildContext context) {
    _selectedTab = widget.selectedTab ?? 0;
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipShadow(
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)],
            clipper: CustomNavBarClipper(),
            child: Container(
              height: 80,
              width: Helper.getScreenWidth(context),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BottomTabBtn(
                      icon: Icon(Icons.home,
                          color:
                              _selectedTab == 0 ? Colors.amber : Colors.blue),
                      selected: _selectedTab == 0 ? true : false,
                      onPressed: () {
                        widget.tabPressed(0);
                      }),
                  BottomTabBtn(
                      icon: Icon(Icons.play_for_work_outlined,
                          color:
                              _selectedTab == 1 ? Colors.amber : Colors.blue),
                      selected: _selectedTab == 1 ? true : false,
                      onPressed: () {
                        widget.tabPressed(1);
                      }),
                  BottomTabBtn(),
                  BottomTabBtn(
                      icon: Icon(Icons.safety_divider,
                          color:
                              _selectedTab == 2 ? Colors.amber : Colors.blue),
                      selected: _selectedTab == 2 ? true : false,
                      onPressed: () {
                        widget.tabPressed(2);
                      }),
                  BottomTabBtn(
                      icon: Icon(Icons.account_circle,
                          color:
                              _selectedTab == 3 ? Colors.amber : Colors.blue),
                      selected: _selectedTab == 3 ? true : false,
                      onPressed: () {
                        widget.tabPressed(3);
                      }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BottomTabBtn extends StatelessWidget {
  final Icon icon;
  final int myWidth;
  final bool selected;
  final Function onPressed;
  BottomTabBtn({this.icon, this.selected, this.onPressed, this.myWidth});
  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 28,
            horizontal: 24,
          ),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: _selected ? Colors.orange : Colors.transparent,
            width: 6,
          ))),
          child: icon,
        ));
  }
}

class CustomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.3, 0);
    path.quadraticBezierTo(
      size.width * 0.375,
      0,
      size.width * 0.375,
      size.height * 0.1,
    );
    path.cubicTo(
      size.width * 0.4,
      size.height * 0.9,
      size.width * 0.6,
      size.height * 0.9,
      size.width * 0.625,
      size.height * 0.1,
    );
    path.quadraticBezierTo(
      size.width * 0.625,
      0,
      size.width * 0.7,
      0.1,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
