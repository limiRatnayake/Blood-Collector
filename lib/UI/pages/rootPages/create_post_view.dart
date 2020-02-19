import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';

class CreatePostView extends StatefulWidget {
  final double _expandedBottomSheetBottomPosition = 0;
  final double _collapsedBottomSheetBottomPosition = -250;
  // final double _completeCollapsedBottomSheetBottomPosition = -330;

  @override
  _PostViewState createState() => _PostViewState();
}

Widget _descriptionTextField() {
  return Column(
    children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
          child: TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration.collapsed(
                border: InputBorder.none, hintText: "What's your need?"),
          ))
    ],
  );
}

class _PostViewState extends State<CreatePostView> with AfterLayoutMixin<CreatePostView> {
  double _bottomSheetBottomPosition = -330;
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Post",
          ),
          elevation: 0.3,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                child: Text(
                  "POST",
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                onTap: () {},
              ),
            )
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12),
                      child: _descriptionTextField()),
                ],
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.decelerate,
              bottom: _bottomSheetBottomPosition,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: _onTap,
                      child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          height: 80,
                          child: Icon(Icons.keyboard_arrow_up)),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: _clipsWidget(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _clipsWidget() {
    return Container(
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              roundedContainer(Colors.redAccent),
              SizedBox(width: 15),
              roundedContainer(Colors.greenAccent),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: <Widget>[
              roundedContainer(Colors.orangeAccent),
              SizedBox(width: 15),
              roundedContainer(Colors.purple),
            ],
          ),
          // SizedBox(height: 16),
          // Row(
          //   children: <Widget>[
          //     roundedContainer(Colors.grey),
          //     SizedBox(height: 20),
          //     roundedContainer(Colors.blueGrey),
          //   ],
          // ),
          // SizedBox(height: 16),
          // Row(
          //   children: <Widget>[
          //     roundedContainer(Colors.lightGreenAccent),
          //     SizedBox(height: 20),
          //     roundedContainer(Colors.pinkAccent),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget roundedContainer(Color color) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(20)),  
      ),
    );
  }

  _onTap() {
    setState(() {
      _bottomSheetBottomPosition = isCollapsed
          ? widget._expandedBottomSheetBottomPosition
          : widget._collapsedBottomSheetBottomPosition;
      isCollapsed = !isCollapsed;
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isCollapsed = true;
        _bottomSheetBottomPosition = widget._collapsedBottomSheetBottomPosition;
      });
    });
  }
}
