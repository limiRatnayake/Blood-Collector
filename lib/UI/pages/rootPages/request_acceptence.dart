import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:flutter/material.dart';

class RequestAcceptenceView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<RequestAcceptenceView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: Icon(Icons.picture_in_picture),
                title: Text("Name"),
                subtitle: Text("Reason"),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.picture_in_picture),
                title: Text("Name"),
                subtitle: Text("Reason"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
