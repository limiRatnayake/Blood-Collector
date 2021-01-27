//pages
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:blood_collector/UI/pages/rootPages/userProfileSetting/settingView.dart';
import 'package:blood_collector/models/participant_model.dart';
import 'package:blood_collector/models/request_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/event_participant_service.dart';
import 'package:blood_collector/services/request_service.dart';
import 'package:blood_collector/services/user_service.dart';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DonatedRequestPostView extends StatefulWidget {
  final String participantId;
  final String participatedStatus;
  final String imageUrl;
  final String currentUser;
  final String uid;
  final String docRef;
  final String userPhoneNumber;
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
  final String status;

  DonatedRequestPostView({
    Key key,
    this.participantId,
    this.participatedStatus,
    this.imageUrl,
    this.currentUser,
    this.uid,
    this.docRef,
    this.createdAt,
    this.userPhoneNumber,
    this.description,
    this.category,
    this.approval,
    this.bloodGroup,
    this.unitsOfBlood,
    this.requestCloseDate,
    this.hospitalName,
    this.hospitalAddress,
    this.patientName,
    this.status,
  }) : super(key: key);
  @override
  _DonatedRequestPostViewState createState() => _DonatedRequestPostViewState();
}

class _DonatedRequestPostViewState extends State<DonatedRequestPostView> {
  final participantRef = FirebaseFirestore.instance;
  DocumentReference requestRef;
  DocumentReference requestedRef;
  DocumentReference participatedRef;
  CollectionReference userRef;
  String participateId;
  // String participatedStatus;
  String participatedStatus;
  String requestedStatus;
  @override
  void initState() {
    requestRef = FirebaseFirestore.instance
        .collection("events")
        .doc(widget.docRef)
        .collection("requested")
        .doc(widget.currentUser);

    DateTime today = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd').format(today);
    final closeDate =
        DateFormat('yyyy-MM-dd').format(widget.requestCloseDate.toDate());

    if (dateFormat == closeDate) {
      FirebaseFirestore.instance
          .collection("events")
          .doc(widget.docRef)
          .update({
        "status": "Close",
      }).then((value) => {
                if (widget.participatedStatus != "Donated")
                  {
                    FirebaseFirestore.instance
                        .collection("participants")
                        .doc(widget.participantId)
                        .update({
                      "participatedStatus": "Not Participated",
                    })
                  }
              });
    }

    super.initState();
    userRef = FirebaseFirestore.instance.collection("users");
  }

  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);
    final EventParticipantService _participantServices =
        Provider.of<EventParticipantService>(context);
    final RequestAcceptenceService _requestServices =
        Provider.of<RequestAcceptenceService>(context);
    String date;
    DateTime requestClose = widget.requestCloseDate.toDate();
    String requestCloseDate = DateFormat('yMd').format(requestClose);

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
                  UserModel data = UserModel.fromMap(snapshot.data.data());

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
                                                  snapshot.data.data());
                                          participatedStatus =
                                              data.participatedStatus;

                                          return (data != null &&
                                                  data.participatedStatus !=
                                                      "Cancelled")
                                              ? requestedStatus == "Sent"
                                                  ? Text(
                                                      "Accepting..",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .purpleAccent),
                                                    )
                                                  : Container()
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                date,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500]),
                              ),
                              FutureBuilder(
                                  future: _participantServices
                                      .getParticipantDetails(
                                          widget.participantId),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      ParticipantModel data =
                                          ParticipantModel.fromMap(
                                              snapshot.data.data());
                                      participatedStatus =
                                          data.participatedStatus;

                                      return data != null
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                data.participatedStatus ==
                                                        "Not Participated"
                                                    ? Text(
                                                        "Not participated",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green),
                                                      )
                                                    : Container(),
                                                data.participatedStatus ==
                                                        "Donated"
                                                    ? Text(
                                                        "Donated",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.purple),
                                                      )
                                                    : Container()
                                              ],
                                            )
                                          : Container();
                                    }
                                  })
                            ],
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
                                title: Text("Request Close On"),
                                subtitle: Text(requestCloseDate)),
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
                          ],
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_drop_down),
                              PopupMenuButton<int>(
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
                                  participatedStatus != "Cancelled"
                                      ? PopupMenuItem(
                                          value: 2,
                                          child: Text(
                                            "Add to Calender",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        )
                                      : PopupMenuItem(
                                          value: 2, child: Container()),
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
                                                  alertBorder: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      side: BorderSide(
                                                          color: Colors.white)),
                                                  titleStyle: TextStyle(
                                                      color:
                                                          Colors.blueAccent)),
                                              buttons: [
                                                  DialogButton(
                                                      child: Text(
                                                        "No",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }),
                                                  DialogButton(
                                                      child: Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                      onPressed: () async {
                                                        String response = await _participantServices
                                                            .updateParticipation(
                                                                widget
                                                                    .currentUser,
                                                                DateTime.now()
                                                                    .toString(),
                                                                widget
                                                                    .participantId,
                                                                "Cancelled");
                                                        if (response ==
                                                            "Success") {
                                                          var snackBar =
                                                              SnackBar(
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
                                                              color: Colors
                                                                  .white)),
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
                                                        Navigator.of(context)
                                                            .pop();
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
                                                        if (response ==
                                                            "Success") {
                                                          var snackBar =
                                                              SnackBar(
                                                            content: Text(
                                                                'It is successfully deleted!',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blueGrey)),
                                                          );

                                                          Scaffold.of(context)
                                                              .showSnackBar(
                                                                  snackBar);
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      })
                                                ]).show();
                                      break;
                                    case 2:
                                      {
                                        DateTime endDate =
                                            widget.requestCloseDate.toDate();

                                        print(endDate);
                                        Event event = Event(
                                          title: "Donating to " +
                                              widget.patientName +
                                              " request",
                                          description: widget.description,
                                          location: widget.hospitalAddress,
                                          startDate: DateTime.now(),
                                          endDate: endDate,
                                          allDay: false,
                                        );

                                        Add2Calendar.addEvent2Cal(event)
                                            .then((success) {
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(success
                                                      ? 'Success'
                                                      : 'Error')));
                                        });
                                      }
                                      break;
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      : Text("try again later");
                }
              }),
          requestedStatus == "Accepted" && widget.status != "Close"
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
                              child: Text(
                                "Mark as Donated",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
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
                                                        DateTime.now()
                                                            .toString(),
                                                        widget.participantId,
                                                        "Donated");
                                            if (response == "Success") {
                                              FirebaseFirestore.instance
                                                  .runTransaction(
                                                      (Transaction tx) async {
                                                DocumentSnapshot docSnapshot =
                                                    await tx.get(userRef.doc(
                                                        widget.currentUser));
                                                if (docSnapshot.exists) {
                                                  tx.update(
                                                      userRef.doc(
                                                          widget.currentUser),
                                                      <String, dynamic>{
                                                        "userPreviouslyDonatedOrNot":
                                                            "Yes",
                                                        "dateOfLastDonation":
                                                            DateTime.now()
                                                                .toString(),
                                                        "lastDonationDateCheck":
                                                            false,
                                                        'ifYesHowManyTimes':
                                                            docSnapshot.data()[
                                                                    "ifYesHowManyTimes"] +
                                                                1
                                                      });
                                                }
                                              });
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
                            ),
                          ],
                        )
                      : Container())
              : Container(),
          participatedStatus != "Cancelled"
              ? ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton.icon(
                      icon: Icon(Icons.explore),
                      label: Text('View Patient Details'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return FutureBuilder(
                                future: _requestServices.getUserRequestDetails(
                                    widget.currentUser, widget.docRef),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    RequestAcceptModel reqData =
                                        RequestAcceptModel.fromMap(
                                            snapshot.data.data());
                                    requestedStatus = reqData.requestStatus;
                                    return reqData != null &&
                                            reqData.requestStatus == "Accepted"
                                        ? Dialog(
                                            child: Container(
                                              color: Colors.black,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25,
                                              child: Card(
                                                  child: Column(
                                                children: [
                                                  ListTile(
                                                    leading: Icon(Icons.person),
                                                    title: Text("Patient Name"),
                                                    subtitle: Text(
                                                        widget.patientName),
                                                  ),
                                                  ListTile(
                                                    leading: Icon(Icons.phone),
                                                    title:
                                                        Text("Phone Number:"),
                                                    subtitle: Text(
                                                        widget.userPhoneNumber),
                                                  )
                                                ],
                                              )),
                                            ),
                                          )
                                        : Dialog(
                                            child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                child: Center(
                                                  child: Text(
                                                      "Still request is not accepted"),
                                                )),
                                          );
                                  }
                                });
                          },
                        );
                      },
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    ));
  }
}
