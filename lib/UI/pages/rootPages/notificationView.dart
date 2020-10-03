import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> _messages;
  _getToken() {
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });
  }

  _configureFirebaseListners() {
    _firebaseMessaging.configure(
      onMessage: (message) async {
        print("onMessage: $message");
        _setMessage(message);
      },
      onResume: (message) async {
        print("onMessage: $message");
        _setMessage(message);
      },
      onLaunch: (message) async {
        print("onMessage: $message");
        _setMessage(message);
      },
    );
  }

//get the firebase message
  _setMessage(Map<String, dynamic> messages) {
    final notification = messages['notification'];
    final data = messages['data'];
    final String titile = notification['title'];
    final String body = notification['body'];
    final String message = data['message'];
    setState(() {
      Message m = Message(titile, body, message);
      _messages.add(m);
    });
  }

  @override
  void initState() {
    super.initState();
    _getToken();
    _configureFirebaseListners();
    _messages = List<Message>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppTopBar(
            title: "Notification",
          )),
      body: ListView.builder(
        itemCount: null == _messages ? 0 : _messages.length,
        itemBuilder: (context, index) {
          print(_messages[index].message);
          return Card(
            child: ListTile(
              leading: Icon(Icons.picture_in_picture),
              title: Text(_messages[index].message),
              // subtitle: Text(_messages[index].message),
            ),
          );
        },
      ),
    );
  }
}

class Message {
  String titile;
  String body;
  String message;

  Message(titile, body, message) {
    this.titile = titile;
    this.body = body;
    this.message = message;
  }
}
