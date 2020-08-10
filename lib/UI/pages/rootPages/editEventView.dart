import 'dart:io';

import 'package:blood_collector/UI/pages/rootPages/editEmailAdd_view.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditEventView extends StatefulWidget {
  final String docRef;

  EditEventView({Key key, this.docRef}) : super(key: key);

  @override
  _EditEventViewState createState() => _EditEventViewState();
}

class _EditEventViewState extends State<EditEventView> {
  @override
  Widget build(BuildContext context) {
    final EventService _eventServices = Provider.of<EventService>(context);

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            appBar: AppBar(
              // actionsIconTheme: null,
              iconTheme: IconThemeData(color: Colors.black),

              title: Text("Edit Profile"),
            ),
            body: FutureBuilder(
                future: _eventServices.requestEventsDetails(widget.docRef),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    EventModel data = EventModel.fromMap(snapshot.data.data);
                    return Text(data.category);
                  }
                })));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to Discard Changes?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("NO, BY MISTAKE")),
                FlatButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("YES, I WANT TO"))
              ],
            ));
  }
}
