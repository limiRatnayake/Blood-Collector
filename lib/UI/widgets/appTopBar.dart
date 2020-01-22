
import 'package:blood_collector/UI/pages/rootPages/notificationView.dart';
import 'package:flutter/material.dart';

class AppTopBar extends StatefulWidget {
  final String title;

  AppTopBar({@required this.title});

  @override
  _AppTopBarState createState() => _AppTopBarState();
}

class _AppTopBarState extends State<AppTopBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, kToolbarHeight),
      child: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.redAccent),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            color: Colors.grey,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.grey,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationView()));
            },
          ),
        ],
      ),
    );
  }
}
