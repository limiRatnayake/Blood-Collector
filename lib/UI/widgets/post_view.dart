import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

class PostView extends StatefulWidget {
  final double _expandedBottomSheetBottomPosition = 0;
  final double _collapsedBottomSheetBottomPosition = -150;
  final double _completeCollapsedBottomSheetBottomPosition = -330;

  @override
  _PostViewState createState() => _PostViewState();
}

Widget _addPostTextField() {
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 4.0, left: 15.0, right: 16.0),
        child: TextField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
              border: InputBorder.none, hintText: "What's your need?"),
        ),
      )
    ],
  );
}

class _PostViewState extends State<PostView> with AfterLayoutMixin<PostView> {
  double _bottomSheetBottomPosition = -175;
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
        elevation: 0.3,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
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
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 8, left: 12),
                  child: _addPostTextField(),
                )
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
                color: Colors.yellow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: _onTap,
                    child: Container(
                      alignment: Alignment.center,
                      // padding: EdgeInsets.symmetric(horizontal: 32),
                      height: 80,
                      child: Icon(Icons.keyboard_arrow_up),
                    ),
                  ),
                  SingleChildScrollView(
                    child: _clipsWidget(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _clipsWidget() {
    return Container(
      height: 150,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Icon(Icons.photo_album),
              ),
            ],
          ),
          SizedBox(
            height:12.0 ,
          ),
          Row(
            children: <Widget>[
              Container(
                child: Icon(Icons.photo_album),
              ),
            ],
          ),
          SizedBox(
            height:12.0 ,
          ),
          Row(
            children: <Widget>[
              Container(
                child: Icon(Icons.photo_album),
              ),
            ],
          )
        ],
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
