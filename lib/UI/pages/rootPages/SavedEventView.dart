import 'package:flutter/material.dart';

class SavedEventView extends StatefulWidget {
  @override
  _SavedEventViewState createState() => _SavedEventViewState();
}

class _SavedEventViewState extends State<SavedEventView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Save Events"),
        ),
        body: Container());
  }
}
