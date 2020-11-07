import 'package:blood_collector/UI/pages/rootPages/settingView.dart';
import 'package:blood_collector/models/participant_model.dart';
import 'package:blood_collector/models/request_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/event_participant_service.dart';
import 'package:blood_collector/services/request_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DonatedRequestPostView extends StatefulWidget {
  final String participantId;
  final String imageUrl;
  final String currentUser;
  final String uid;
  final String docRef;
  final String description;
  final String createdAt;
  final String category;
  final bool approval;
  final String bloodGroup;
  final String unitsOfBlood;
  final Timestamp requestCloseDate;
  final String hospitalName;
  final String hospitalAddress;
  final String patientName;

  DonatedRequestPostView({
    Key key,
    this.participantId,
    this.imageUrl,
    this.currentUser,
    this.uid,
    this.docRef,
    this.createdAt,
    this.description,
    this.category,
    this.approval,
    this.bloodGroup,
    this.unitsOfBlood,
    this.requestCloseDate,
    this.hospitalName,
    this.hospitalAddress,
    this.patientName,
  }) : super(key: key);
  @override
  _DonatedRequestPostViewState createState() => _DonatedRequestPostViewState();
}

class _DonatedRequestPostViewState extends State<DonatedRequestPostView> {
  final participantRef = Firestore.instance;
  DocumentReference requestRef;
  DocumentReference requestedRef;
  String participateId;
  // String participatedStatus;
  String participatedStatus;
  String requestedStatus;
  @override
  void initState() {
    requestRef = Firestore.instance
        .collection("events")
        .document(widget.docRef)
        .collection("requested")
        .document(widget.currentUser);

    // requestRef.get().then((value) {
    //   setState(() {
    //     requestedStatus = value.data["requestStatus"];
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);
    final EventParticipantService _participantServices =
        Provider.of<EventParticipantService>(context);
    final RequestAcceptenceService _requestServices =
        Provider.of<RequestAcceptenceService>(context);
    String date;

    //get the event created date
    var checkedTime = DateTime.parse(widget.createdAt);

    //get the event created time
    String roughTimeString = DateFormat('jm').format(checkedTime);

    //get the current date
    DateTime currentTime = DateTime.now();
    if ((currentTime.year == checkedTime.year) &&
        (currentTime.month == checkedTime.month) &&
        (currentTime.day == checkedTime.day)) {
      date = "TODAY";
    } else if ((currentTime.year == checkedTime.year) &&
        (currentTime.month == checkedTime.month)) {
      if ((currentTime.day - checkedTime.day) == 1) {
        date = "YESTERDAY";
      } else {
        date = DateFormat('yMd').format(checkedTime) + " " + roughTimeString;
      }
    } else {
      date = DateFormat('yMd').format(checkedTime) + " " + roughTimeString;
    }

    DateTime createdOn = widget.requestCloseDate.toDate();
    DateTime currentDate = DateTime.now();

    String createdOnFormat = DateFormat.yMMMEd().format(createdOn);

    if (createdOn.compareTo(currentDate) > 0) {
      print(createdOn);
    }

    return Container(
        child: Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          widget.imageUrl != ""
              ? Container(
                  height: MediaQuery.of(context).size.width - 80,
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(22),
                      image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: NetworkImage(widget.imageUrl),
                  )),
                )
              : Container(),
          FutureBuilder(
              future: _userService.requestUserDetails(widget.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  UserModel data = UserModel.fromMap(snapshot.data.data);

                  return data != null
                      ? ExpansionTile(
                          leading: GestureDetector(
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(data.proPicUrl),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.firstName + " " + data.lastName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 9),

                              /*once it delete the participantId is gonna be null it through an error
                              so, as solution it check whether the id is null or not*/
                              widget.participantId != null
                                  ? FutureBuilder(
                                      future: _participantServices
                                          .getParticipantDetails(
                                              widget.participantId),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          ParticipantModel data =
                                              ParticipantModel.fromMap(
                                                  snapshot.data.data);
                                          participatedStatus =
                                              data.participatedStatus;

                                          return (data != null &&
                                                  data.participatedStatus !=
                                                      "Cancelled")
                                              ? data.participatedStatus !=
                                                      "Donated"
                                                  ? requestedStatus !=
                                                          "Accepted"
                                                      ? Text(
                                                          "Accepting..",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .purpleAccent),
                                                        )
                                                      : requestedStatus !=
                                                              "Rejected"
                                                          ? Text(
                                                              "Rejected!",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            )
                                                          : Container()
                                                  : Text(
                                                      "Donated",
                                                      style: TextStyle(
                                                          color: Colors.purple),
                                                    )
                                              : Text(
                                                  "Cancelled",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                );
                                        }
                                      })
                                  : Container()
                            ],
                          ),
                          subtitle: Text(
                            date,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500]),
                          ),
                          children: [
                            ListTile(
                              leading: Icon(Icons.opacity),
                              title: Text("Requested Blood Type"),
                              subtitle: Text(
                                widget.bloodGroup,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.check_box_outline_blank),
                              title: Text("Units of Blood"),
                              subtitle: Text(widget.unitsOfBlood),
                            ),
                            ListTile(
                                leading: Icon(Icons.event_available),
                                title: Text("When they need blood"),
                                subtitle:
                                    Text(widget.requestCloseDate.toString())),
                            ListTile(
                              leading: Icon(Icons.local_hospital),
                              title: Text("Hospital Name"),
                              subtitle: Text(widget.hospitalName),
                            ),
                            ListTile(
                              leading: Icon(Icons.directions),
                              title: Text("Hospital Address"),
                              subtitle: Text(widget.hospitalAddress),
                            ),
                            FutureBuilder(
                                future: _requestServices.getUserRequestDetails(
                                    widget.currentUser, widget.docRef),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    RequestAcceptModel reqData =
                                        RequestAcceptModel.fromMap(
                                            snapshot.data.data);
                                    requestedStatus = reqData.requestStatus;
                                    return reqData != null &&
                                            reqData.requestStatus == "Accepted"
                                        ? ListTile(
                                            leading: Icon(Icons.person),
                                            title: Text("Patient Name"),
                                            subtitle: Text(widget.patientName),
                                          )
                                        : Container();
                                  }
                                })
                          ],
                          trailing: PopupMenuButton<int>(
                            itemBuilder: (context) => [
                              participatedStatus != "Cancelled" &&
                                      participatedStatus != "Donated"
                                  ? PopupMenuItem(
                                      value: 1,
                                      child: Text(
                                        "Cancel the participation",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )
                                  : PopupMenuItem(
                                      value: 1,
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(
                                  "Mark as Interested",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              switch (value) {
                                case 1:
                                  participatedStatus != "Cancelled" &&
                                          participatedStatus != "Donated"
                                      ? Alert(
                                          context: context,
                                          type: AlertType.success,
                                          title:
                                              "Are you sure you want to cancel the participation?",
                                          style: AlertStyle(
                                              isCloseButton: false,
                                              isOverlayTapDismiss: false,
                                              backgroundColor: Colors.black,
                                              alertBorder:
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      side: BorderSide(
                                                          color: Colors.white)),
                                              titleStyle: TextStyle(
                                                  color: Colors.blueAccent)),
                                          buttons: [
                                              DialogButton(
                                                  child: Text(
                                                    "No",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }),
                                              DialogButton(
                                                  child: Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  onPressed: () async {
                                                    String response =
                                                        await _participantServices
                                                            .updateParticipation(
                                                                widget
                                                                    .currentUser,
                                                                DateTime.now()
                                                                    .toString(),
                                                                widget
                                                                    .participantId,
                                                                "Cancelled");
                                                    if (response == "Success") {
                                                      var snackBar = SnackBar(
                                                        content: Text(
                                                            'Participation is cancelled!',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueGrey)),
                                                      );
                                                      /* if user cancel on participting to an event
                                                       delete the request that sent
                                                       */
                                                      requestRef.delete();
                                                      Scaffold.of(context)
                                                          .showSnackBar(
                                                              snackBar);
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  })
                                            ]).show()
                                      : Alert(
                                          context: context,
                                          type: AlertType.warning,
                                          title: "Are you sure?",
                                          style: AlertStyle(
                                              isCloseButton: false,
                                              isOverlayTapDismiss: false,
                                              backgroundColor: Colors.black,
                                              alertBorder:
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      side: BorderSide(
                                                          color: Colors.white)),
                                              titleStyle: TextStyle(
                                                  color: Colors.blueAccent)),
                                          buttons: [
                                              DialogButton(
                                                  child: Text(
                                                    "No",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }),
                                              DialogButton(
                                                  child: Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  onPressed: () async {
                                                    String response =
                                                        await _participantServices
                                                            .deleteAParticipant(
                                                                widget
                                                                    .participantId);
                                                    if (response == "Success") {
                                                      var snackBar = SnackBar(
                                                        content: Text(
                                                            'It is successfully deleted!',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueGrey)),
                                                      );

                                                      Scaffold.of(context)
                                                          .showSnackBar(
                                                              snackBar);
                                                      Navigator.pop(context);
                                                    }
                                                  })
                                            ]).show();
                                  break;
                                case 2:
                                  {}
                                  break;
                              }
                            },
                          ),
                        )
                      : Text("try again later");
                }
              }),
          requestedStatus == "Accepted"
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (participatedStatus != "Cancelled" &&
                          participatedStatus != "Donated")
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Once you actually donated "),
                            RaisedButton(
                                color: Colors.blueAccent,
                                onPressed: () {
                                  Alert(
                                      context: context,
                                      type: AlertType.success,
                                      title: "Did you actually donated?",
                                      style: AlertStyle(
                                          isCloseButton: false,
                                          isOverlayTapDismiss: false,
                                          backgroundColor: Colors.black,
                                          alertBorder: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: BorderSide(
                                                  color: Colors.white)),
                                          titleStyle: TextStyle(
                                              color: Colors.blueAccent)),
                                      buttons: [
                                        DialogButton(
                                            child: Text(
                                              "No",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }),
                                        DialogButton(
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () async {
                                              String response =
                                                  await _participantServices
                                                      .updateDataOfParticipating(
                                                          widget.currentUser,
                                                          DateTime.now()
                                                              .toString(),
                                                          widget.participantId,
                                                          "Donated");
                                              if (response == "Success") {
                                                var snackBar = SnackBar(
                                                  content: Text(
                                                      'Your last donation date is updated!',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey)),
                                                  action: SnackBarAction(
                                                    label: 'Go',
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SettingView()));
                                                    },
                                                  ),
                                                );
                                                Scaffold.of(context)
                                                    .showSnackBar(snackBar);
                                                Navigator.of(context).pop();
                                              }
                                            })
                                      ]).show();
                                },
                                child: Text(
                                  "Mark as Donated",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        )
                      : Container())
              : Container()
        ],
      ),
    ));
  }
}
