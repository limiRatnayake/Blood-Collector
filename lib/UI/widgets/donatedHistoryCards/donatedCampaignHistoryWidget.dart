//pages
import 'package:blood_collector/models/participant_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/event_participant_service.dart';
import 'package:blood_collector/services/user_service.dart';

//packages
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DonatedCampaignPostView extends StatefulWidget {
  final String participantId;
  final String participatedStatus;
  final String imageUrl;
  final String uid;
  final String docRef;
  final String description;
  final String createdAt;
  final String category;
  final String currentUser;
  final bool approval;
  final String rejectedReason;
  final String nameOftheOrganizer;
  final String startTime;
  final String endTime;
  final Timestamp requestCloseDate;
  final String placeName;
  final String placeAddress;
  final String submitListStatus;

  DonatedCampaignPostView({
    Key key,
    this.participantId,
    this.participatedStatus,
    this.imageUrl,
    this.uid,
    this.docRef,
    this.createdAt,
    this.description,
    this.category,
    this.currentUser,
    this.approval,
    this.rejectedReason,
    this.nameOftheOrganizer,
    this.startTime,
    this.endTime,
    this.requestCloseDate,
    this.placeName,
    this.placeAddress,
    this.submitListStatus,
  }) : super(key: key);
  @override
  _DonatedCampaignPostViewState createState() =>
      _DonatedCampaignPostViewState();
}

class _DonatedCampaignPostViewState extends State<DonatedCampaignPostView> {
  final participantRef = FirebaseFirestore.instance;
  CollectionReference eventRef;

  String participateId;
  String participatedStatus;

  String cancelParticipatedStatus;

  @override
  void initState() {
    eventRef = FirebaseFirestore.instance.collection("events");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);
    final EventParticipantService _participantServices =
        Provider.of<EventParticipantService>(context);
    DateTime requestClose = widget.requestCloseDate.toDate();
    String requestCloseDate = DateFormat('yMd').format(requestClose);

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
                                      cancelParticipatedStatus =
                                          data.participatedStatus;

                                      return (data != null &&
                                              data.participatedStatus !=
                                                  "Cancelled")
                                          ? Container()
                                          : Text(
                                              "Cancelled",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            );
                                    }
                                  })
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
                              widget.submitListStatus == "submitted"
                                  ? Text(
                                      widget.participatedStatus,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[500]),
                                    )
                                  : Container(),
                            ],
                          ),
                          children: [
                            ListTile(
                              leading: Icon(Icons.opacity),
                              title: Text("Organizered By"),
                              subtitle: Text(
                                widget.nameOftheOrganizer,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.access_time),
                              title: Text("Time"),
                              subtitle:
                                  Text(widget.startTime + " " + widget.endTime),
                            ),
                            ListTile(
                                leading: Icon(Icons.event_available),
                                title: Text("When they need blood"),
                                subtitle: Text(requestCloseDate)),
                            ListTile(
                              leading: Icon(Icons.local_hospital),
                              title: Text("Place Name"),
                              subtitle: Text(widget.placeName),
                            ),
                            ListTile(
                              leading: Icon(Icons.location_on),
                              title: Text("Place Address"),
                              subtitle: Text(widget.placeAddress),
                            ),
                            ListTile(
                              leading: Icon(Icons.opacity),
                              title: Text("Description"),
                              subtitle: Text(
                                widget.description,
                              ),
                            ),
                          ],
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_drop_down),
                              PopupMenuButton<int>(
                                itemBuilder: (context) => [
                                  cancelParticipatedStatus != "Cancelled" &&
                                          widget.participatedStatus ==
                                              "participating"
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
                                  cancelParticipatedStatus != "Cancelled"
                                      ? PopupMenuItem(
                                          value: 2,
                                          child: Text(
                                            "Add to Calender",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        )
                                      : null
                                ],
                                onSelected: (value) {
                                  switch (value) {
                                    case 1:
                                      cancelParticipatedStatus != "Cancelled"
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
                                                          FirebaseFirestore
                                                              .instance
                                                              .runTransaction(
                                                                  (tx) async {
                                                            DocumentSnapshot
                                                                docSnapshot =
                                                                await tx.get(eventRef
                                                                    .doc(widget
                                                                        .docRef));
                                                            if (docSnapshot
                                                                .exists) {
                                                              int newFollowerCount =
                                                                  docSnapshot.data()[
                                                                          'totalParticipants'] -
                                                                      1;
                                                              // Perform an update on the document
                                                              tx.update(
                                                                  eventRef.doc(
                                                                      widget
                                                                          .docRef),
                                                                  {
                                                                    'totalParticipants':
                                                                        newFollowerCount
                                                                  });
                                                            }
                                                          });
                                                          var snackBar =
                                                              SnackBar(
                                                            content: Text(
                                                                'Participation is cancelled!',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blueGrey)),
                                                          );

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
                                                              BorderRadius
                                                                  .circular(5),
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
                                          title: 'Participating on' +
                                              " " +
                                              widget.nameOftheOrganizer +
                                              " " +
                                              "blood campaign",
                                          description: widget.description,
                                          location: widget.placeAddress,
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
        ],
      ),
    ));
  }
}
