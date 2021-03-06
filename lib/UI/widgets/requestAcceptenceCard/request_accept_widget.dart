//pages
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/request_service.dart';
import 'package:blood_collector/services/user_service.dart';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AcceptRequestCard extends StatefulWidget {
  final String docRef;
  final String requestSentOn;
  final String requestStatus;
  final String requesterId;
  final String participantsID;

  AcceptRequestCard(
      {Key key,
      this.requesterId,
      this.docRef,
      this.requestSentOn,
      this.requestStatus,
      this.participantsID})
      : super(key: key);
  @override
  _AcceptRequestCardState createState() => _AcceptRequestCardState();
}

class _AcceptRequestCardState extends State<AcceptRequestCard> {
  CollectionReference eventRef;
  DocumentReference events;

  Map<String, dynamic> requestData;
  bool _isReqDisabled;
  bool inclueInRequestList;
  String reqId;
  int userAccepted;

  @override
  void initState() {
    super.initState();
    events = FirebaseFirestore.instance.collection("events").doc(widget.docRef);
    events.get().then((value) {
      userAccepted = value.data()["userAccepted"];
    });
    eventRef = FirebaseFirestore.instance.collection("events");
  }

  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);
    final RequestAcceptenceService _requestsServices =
        Provider.of<RequestAcceptenceService>(context);

    return Container(
        child: Card(
            clipBehavior: Clip.antiAlias,
            child: FutureBuilder(
                future: _userService.requestUserDetails(widget.requesterId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    UserModel data = UserModel.fromMap(snapshot.data.data());

                    return ListTile(
                        leading: GestureDetector(
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(data.proPicUrl),
                          ),
                        ),
                        title: Text(data.firstName + " " + data.lastName),
                        subtitle: Text(widget.requestSentOn),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widget.requestStatus != "Accepted" &&
                                    widget.requestStatus != "Rejected"
                                ? IconButton(
                                    icon: Icon(Icons.done),
                                    color: Colors.blue,
                                    onPressed: () async {
                                      if (widget.requestStatus != "Accepted") {
                                        FirebaseFirestore.instance
                                            .runTransaction(
                                                (Transaction tx) async {
                                          DocumentSnapshot docSnapshot =
                                              await tx.get(
                                                  eventRef.doc(widget.docRef));
                                          if (docSnapshot.exists) {
                                            tx.update(
                                                eventRef.doc(widget.docRef),
                                                <String, dynamic>{
                                                  'userAccepted':
                                                      docSnapshot.data()[
                                                              "userAccepted"] +
                                                          1
                                                });
                                          }
                                        });
                                        String response =
                                            await _requestsServices
                                                .updateAcceptRequests(
                                          widget.docRef,
                                          widget.requesterId,
                                          "Accepted",
                                          false,
                                        );
                                        if (response != "Success") {
                                          final snackBar = SnackBar(
                                            content: Text(
                                                'Error accepting the requests',
                                                style: TextStyle(
                                                    color: Colors.blueGrey)),
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                        } else {
                                          Alert(
                                              context: context,
                                              type: AlertType.success,
                                              title: "Request was accepted!",
                                              style: AlertStyle(
                                                  backgroundColor: Colors.white,
                                                  alertBorder:
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          side: BorderSide(
                                                              color: Colors
                                                                  .white)),
                                                  titleStyle: TextStyle(
                                                      color:
                                                          Colors.blueAccent)),
                                              buttons: [
                                                DialogButton(
                                                    width: 120,
                                                    child: Text(
                                                      "ok",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    })
                                              ]).show();
                                        }
                                      } else if (widget.requestStatus ==
                                          "Accepted") {
                                        final snackBar = SnackBar(
                                          content: Text('It already accepted',
                                              style: TextStyle(
                                                  color: Colors.blueGrey)),
                                        );
                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    })
                                : Container(),
                            IconButton(
                                color: Colors.black,
                                icon: Icon(Icons.clear),
                                onPressed: () async {
                                  if (widget.requestStatus != "Rejected") {
                                    if (userAccepted > 0) {
                                      await FirebaseFirestore.instance
                                          .runTransaction(
                                              (Transaction tx) async {
                                        DocumentSnapshot docSnapshot = await tx
                                            .get(eventRef.doc(widget.docRef));

                                        if (docSnapshot.exists) {
                                          tx.update(
                                              eventRef.doc(widget.docRef),
                                              <String, dynamic>{
                                                'userAccepted':
                                                    docSnapshot.data()[
                                                            "userAccepted"] -
                                                        1
                                              });
                                        }
                                      });
                                    }

                                    String response = await _requestsServices
                                        .updateRejectedRequests(
                                            widget.docRef,
                                            widget.requesterId,
                                            "Rejected",
                                            true,
                                            widget.participantsID);
                                    if (response != "Success") {
                                      final snackBar = SnackBar(
                                        content: Text(
                                            'Error accepting the requests',
                                            style: TextStyle(
                                                color: Colors.blueGrey)),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      final snackBar = SnackBar(
                                        content: Text('It  Rejected',
                                            style: TextStyle(
                                                color: Colors.blueGrey)),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  }
                                })
                          ],
                        ));
                  }
                })));
  }
}
