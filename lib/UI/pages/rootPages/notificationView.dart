//pages
import 'package:blood_collector/UI/pages/rootPages/viewRequestDetails.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/user_notification_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/push_notification_service.dart';
import 'package:blood_collector/services/user_service.dart';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _configureFirebaseListners() {
    _firebaseMessaging.configure(
      onMessage: (message) async {
        print("onMessage: $message");
        // _setMessage(message);
      },
      onResume: (message) async {
        print("onMessage: $message");
        // _setMessage(message);
      },
      onLaunch: (message) async {
        print("onMessage: $message");
        // _setMessage(message);
      },
    );
  }

  _updateNotificationCount() {
    FirebaseAuth.instance.currentUser().then((currentUser) => {
          Firestore.instance
              .collection("users")
              .document(currentUser.uid)
              .updateData({"notificationCount": 0})
        });
  }

  @override
  void initState() {
    super.initState();
    // _getToken();
    _configureFirebaseListners();
    _updateNotificationCount();
  }

  @override
  Widget build(BuildContext context) {
    final PushNotificationService _notificationsService =
        Provider.of<PushNotificationService>(context);
    final AuthServices _authServices = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);
    final EventService _eventServices = Provider.of<EventService>(context);
    String category;
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
                        // createdAt = notifyData.createdOn;
                        // var checkedTime = DateTime.parse(createdAt);
                        // var newDt = DateFormat.yMMMEd().format(checkedTime);
                        // Timestamp myTimeStamp = Timestamp.fromDate(
                        //     notifyData.createdOn); //To TimeStamp

                        // DateTime createdOn = notifyData.createdOn.toDate();

                        // String createdOnFormat =
                        // DateFormat.yMMMEd().format(createdOn);

                        return Card(
                            child: FutureBuilder(
                                future: _userService
                                    .requestUserDetails(notifyData.notifyBy),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    UserModel userData =
                                        UserModel.fromMap(snapshot.data.data);

                                    return ListTile(
                                      onTap: () async {
                                        DocumentSnapshot doc =
                                            await _eventServices
                                                .requestEventsDetails(
                                                    notifyData.docRef);
                                        EventModel data =
                                            EventModel.fromMap(doc.data);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewRequestDetails(
                                                      docRef: notifyData.docRef,
                                                      uid: notifyData.notifyBy,
                                                      currentUser: _authServices
                                                          .user.uid,
                                                      image: data.imageUrl,
                                                    )));
                                      },
                                      leading: GestureDetector(
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundImage:
                                              NetworkImage(userData.proPicUrl),
                                        ),
                                      ),
                                      title: notifyData.hospitalName != ""
                                          ? Text(
                                              notifyData.message +
                                                  " " +
                                                  "Blood Group",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(notifyData.message,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                      subtitle: notifyData.hospitalName != ""
                                          ? Text(
                                              "In" +
                                                  " " +
                                                  notifyData.hospitalName +
                                                  " " +
                                                  "\n" +
                                                  "Tap to view more",
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            )
                                          : Text(
                                              notifyData.organizersName +
                                                  "\n" +
                                                  notifyData.eventHeldOn,
                                              style: TextStyle(
                                                fontSize: 14,
                                              )),
                                      isThreeLine: true,
                                      trailing: IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () async {
                                            String message =
                                                await _notificationsService
                                                    .deleteNotification(
                                                        _authServices.user.uid,
                                                        notifyData.notifyId);
                                            print(message);
                                            final snackBar = SnackBar(
                                              content: Text(
                                                  'Notification has been deleted',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            );
                                            Scaffold.of(context)
                                                .showSnackBar(snackBar);
                                          }),
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
