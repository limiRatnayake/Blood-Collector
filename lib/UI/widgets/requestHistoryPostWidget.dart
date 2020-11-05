import 'package:blood_collector/UI/pages/rootPages/editCampaignView.dart';
import 'package:blood_collector/UI/pages/rootPages/editRequestView.dart';
import 'package:blood_collector/UI/pages/rootPages/exploreMore/exploreCampaignMore.dart';
import 'package:blood_collector/UI/pages/rootPages/exploreMore/exploreRequestsMore.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RaisedRequestedPostView extends StatefulWidget {
  final String imageUrl;
  final String uid;
  final String docRef;
  final String description;
  final String createdAt;
  final String category;
  final bool approval;
  final String rejectedReason;
  final String status;
  final Timestamp requestClose;

  RaisedRequestedPostView(
      {Key key,
      this.imageUrl,
      this.uid,
      this.docRef,
      this.createdAt,
      this.description,
      this.category,
      this.approval,
      this.rejectedReason,
      this.status,
      this.requestClose})
      : super(key: key);
  @override
  _RaisedRequestedPostViewState createState() =>
      _RaisedRequestedPostViewState();
}

class _RaisedRequestedPostViewState extends State<RaisedRequestedPostView> {
  EventService _eventServices;

  @override
  void initState() {
    print(widget.rejectedReason);
    // DateTime requestClose = DateTime.parse(widget.requestClose);
    // TODO: implement initState
    super.initState();
    Firestore.instance
        .collection("events")
        .where("requestClose", isLessThanOrEqualTo: DateTime.now())
        .getDocuments()
        .then((value) async {
      await Firestore.instance
          .collection("events")
          .document(widget.docRef)
          .updateData({
        "status": "Close",
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);
    _eventServices = Provider.of<EventService>(context);
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
          FutureBuilder(
              future: _userService.requestUserDetails(widget.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  UserModel data = UserModel.fromMap(snapshot.data.data);

                  return data != null
                      ? ListTile(
                          leading: GestureDetector(
                            child: CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(data.proPicUrl),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                data.firstName + " " + data.lastName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 9),
                              widget.approval == true
                                  ? Text(
                                      widget.status,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : widget.rejectedReason != "None"
                                      ? Text("Rejected",
                                          style: TextStyle(color: Colors.red))
                                      : Text("Approving",
                                          style: TextStyle(color: Colors.red)),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              // Text(
                              //   date,
                              //   style: TextStyle(
                              //       fontSize: 12,
                              //       fontWeight: FontWeight.bold,
                              //       color: Colors.grey[500]),
                              // ),
                            ],
                          ),
                          trailing: PopupMenuButton<int>(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              switch (value) {
                                case 1:
                                  if (widget.category != "campaign") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditRequestView(
                                                  docRef: widget.docRef,
                                                )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditCampaignView(
                                                  docRef: widget.docRef,
                                                )));
                                  }

                                  break;
                                case 2:
                                  {
                                    Alert(
                                        context: context,
                                        type: AlertType.success,
                                        title:
                                            "Are you sure you want to delete this event?",
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
                                                    await _eventServices
                                                        .deleteEvent(
                                                            widget.docRef);
                                                if (response == "Success") {
                                                  var snackBar = SnackBar(
                                                    content: Text(
                                                        'Your event is Successfully deleted',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blueGrey)),
                                                  );
                                                  if (widget.imageUrl != null) {
                                                    _eventServices
                                                        .deleteEventImage(
                                                            widget.imageUrl);
                                                  }
                                                  Scaffold.of(context)
                                                      .showSnackBar(snackBar);
                                                  Navigator.of(context).pop();
                                                }
                                              })
                                        ]).show();
                                  }
                                  break;
                              }
                            },
                          ))
                      : Text("try again later");
                }
              }),

          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.description,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ),
          widget.imageUrl != ""
              ? Container(
                  height: MediaQuery.of(context).size.width - 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(widget.imageUrl),
                      )),
                )
              : Container(),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton.icon(
                icon: Icon(Icons.explore),
                label: Text('Explore More'),
                onPressed: () {
                  if (widget.category != "campaign") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExploreRequestsMore(
                                  docRef: widget.docRef,
                                  uid: widget.uid,
                                )));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExploreCampaignMore(
                                  docRef: widget.docRef,
                                  uid: widget.uid,
                                )));
                  }
                },
              ),
            ],
          ),
          // Image.asset()
        ],
      ),
    ));
  }
}
