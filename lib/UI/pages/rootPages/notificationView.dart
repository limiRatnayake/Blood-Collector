import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/models/notification_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/push_notification_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> _messages;
  // _getToken() {
  //   _firebaseMessaging.getToken().then((token) {

  //   });
  // }

  _configureFirebaseListners() {
    _firebaseMessaging.configure(
      onMessage: (message) async {
        print("onMessage: $message");
        // _setMessage(message);
      },
      // onResume: (message) async {
      //   print("onMessage: $message");
      //   // _setMessage(message);
      // },
      // onLaunch: (message) async {
      //   print("onMessage: $message");
      //   // _setMessage(message);
      // },
    );
  }

  handleNotificationMsg(Map<String, dynamic> message) {
    Alert(
        context: context,
        title: message['notification']['title'],
        desc: message['notification']['body'],
        buttons: [
          DialogButton(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ]).show();
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
    // _getToken();
    _configureFirebaseListners();
    _messages = List<Message>();
  }

  @override
  Widget build(BuildContext context) {
    final PushNotificationService _notificationsService =
        Provider.of<PushNotificationService>(context);
    final AuthServices _authServices = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: FutureBuilder(
          future: _notificationsService
              .getUserNotifications(_authServices.user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              List<NotificationModel> dataList = snapshot.data.documents
                  .map<NotificationModel>(
                      (doc) => NotificationModel.fromMap(doc.data))
                  .toList();

              return dataList.length > 0
                  ? ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        NotificationModel notifyData = dataList[index];

                        return Card(
                            child: FutureBuilder(
                                future: _userService
                                    .requestUserDetails(_authServices.user.uid),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    UserModel userData =
                                        UserModel.fromMap(snapshot.data.data);

                                    return ListTile(
                                      leading: GestureDetector(
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundImage:
                                              NetworkImage(userData.proPicUrl),
                                        ),
                                      ),
                                      title: Text(notifyData.message),
                                      trailing: IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: null),
                                    );
                                  }
                                }));
                      },
                    )
                  : Padding(
                      padding: EdgeInsets.all(15),
                      child: Center(
                        child: Text(
                          "There Is not Notifications",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
            }
          }),
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
