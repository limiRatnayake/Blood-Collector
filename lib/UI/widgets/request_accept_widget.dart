import 'package:blood_collector/UI/pages/rootPages/editCampaignView.dart';
import 'package:blood_collector/UI/pages/rootPages/editRequestView.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AcceptRequestWidget extends StatefulWidget {
  final String uid;
  final String docRef;

  AcceptRequestWidget({
    Key key,
    this.uid,
    this.docRef,
  }) : super(key: key);
  @override
  _AcceptRequestWidgetState createState() => _AcceptRequestWidgetState();
}

class _AcceptRequestWidgetState extends State<AcceptRequestWidget> {
  DocumentReference requestedRef;
  Map<String, dynamic> requestedData;
  String requesterId;
  bool requestStatus;
  // @override
  // void initState() {
  //   //get the requster sub collection data
  //   Firestore.instance
  //       .collection("events")
  //       .document(widget.docRef)
  //       .collection("likes")
  //       .getDocuments()
  //       .then((QuerySnapshot snapshot) => snapshot.documents.forEach((element) {
  //             setState(() {
  //               requesterId = element.documentID;
  //             });
  //           }));
  //   requestedRef = Firestore.instance
  //       .collection("events")
  //       .document(widget.docRef)
  //       .collection("requested")
  //       .document(requesterId);

  //   requestedRef.get().then((value) {
  //     requestedData = value.data;
  //   });
  //   super.initState();
  //   // eventRef = Firestore.instance.collection("events");
  // }

  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);
    final EventService _eventServices = Provider.of<EventService>(context);
    print(widget.docRef);
    print(requesterId);
    return Container(
        child: Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
                leading: Icon(Icons.picture_in_picture),
                title: Text("event Name "),
                subtitle: Text("Reason"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: Icon(Icons.done),
                        onPressed: () {
                          print("pressed");
                          requestedRef.updateData({
                            "requestStatus": "accept",
                          });
                          setState(() {
                            requestedRef.get().then((value) {
                              requestedData = value.data;
                            });
                          });
                        }),
                    IconButton(icon: Icon(Icons.clear), onPressed: () {})
                  ],
                ))));
  }
}
