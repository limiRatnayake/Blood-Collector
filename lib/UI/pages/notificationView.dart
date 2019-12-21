
import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppTopBar(
        title: "Notification",
      )),
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: Icon(Icons.picture_in_picture) ,
                title: Text("Name"),
                subtitle: Text("Reason"),
              ),
            ),
              Card(
              child: ListTile(
                leading: Icon(Icons.picture_in_picture) ,
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
