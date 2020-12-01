import 'package:blood_collector/UI/pages/rootPages/ListOfParticipantView.dart';
import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/preventDooubleTap.dart';
import 'package:blood_collector/UI/widgets/slider_campaign_widget.dart';
import 'package:blood_collector/UI/widgets/slider_request_widget.dart';
import 'package:blood_collector/UI/widgets/submittedParticipantList.dart';
import 'package:blood_collector/UI/widgets/viewInsights.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExploreCampaignMore extends StatefulWidget {
  final String docRef;
  final String uid;

  ExploreCampaignMore({
    Key key,
    this.docRef,
    this.uid,
  }) : super(key: key);

  @override
  _ExploreCampaignMoreState createState() => _ExploreCampaignMoreState();
}

//timeline card
class _ExploreCampaignMoreState extends State<ExploreCampaignMore> {
  final participantRef = Firestore.instance;
  bool participated = false;
  String participateId;
  bool inclueInParticipantList;

  _isParticipated() {
    setState(() {
      participated = !participated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final EventService _eventServices = Provider.of<EventService>(context);
    final UserService _userService = Provider.of<UserService>(context);

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Request Explore"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xffA22447).withOpacity(.05),
                      offset: Offset(0, 1),
                      blurRadius: 20,
                      spreadRadius: 3)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //get user profile data
                  FutureBuilder(
                      future: _userService.requestUserDetails(widget.uid),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          UserModel data =
                              UserModel.fromMap(snapshot.data.data);
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                data.proPicUrl,
                              ),
                            ),
                            title: Text(
                              data.firstName + " " + data.lastName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                      }),

                  SizedBox(
                    height: 8.0,
                  ),
                  FutureBuilder(
                      future:
                          _eventServices.requestEventsDetails(widget.docRef),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          EventModel data =
                              EventModel.fromMap(snapshot.data.data);
                          DateTime requestClose = data.requestClose.toDate();
                          String requestCloseDate =
                              DateFormat('yMd').format(requestClose);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.opacity),
                                title: Text("Organizered By"),
                                subtitle: Text(
                                  data.nameOftheOrganizer,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.access_time),
                                title: Text("Time"),
                                subtitle:
                                    Text(data.startTime + " " + data.endTime),
                              ),
                              ListTile(
                                  leading: Icon(Icons.event_available),
                                  title: Text("When they need blood"),
                                  subtitle: Text(requestCloseDate)),
                              ListTile(
                                leading: Icon(Icons.local_hospital),
                                title: Text("Place Name"),
                                subtitle: Text(data.placeName),
                              ),
                              ListTile(
                                leading: Icon(Icons.location_on),
                                title: Text("Place Address"),
                                subtitle: Text(data.placeAddress),
                              ),
                              ListTile(
                                leading: Icon(Icons.phone),
                                title: Text("Organizer Contact Number"),
                                subtitle: Text(data.orgernizerConatctNo),
                                // trailing: Text(data.userPhoneNumber),
                              ),

                              Divider(
                                height: 1,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FlatButton.icon(
                                      onPressed: () {
                                        data.submitListStatus != "submitted"
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ListOfParticipantView(
                                                        uid: widget.uid,
                                                        docRef: widget.docRef,
                                                        totalEngage: data
                                                            .totalParticipants,
                                                        actualEngage: data
                                                            .actualParticipants,
                                                        avoidParticipants: data
                                                            .avoidParticipants,
                                                        submitListStatus: data
                                                            .submitListStatus)))
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SubmittedParticipantListView(
                                                          docRef: widget.docRef,
                                                        )));
                                      },
                                      icon: Icon(
                                        Icons.supervised_user_circle,
                                        color: Colors.blue,
                                      ),
                                      label: Text(
                                        "Participant List",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  FlatButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TaskHomePage(
                                                        docRef: widget.docRef,
                                                        submitStatus: data
                                                            .submitListStatus)));
                                      },
                                      icon: Icon(
                                        Icons.analytics_rounded,
                                        color: Colors.blue,
                                      ),
                                      label: Text(
                                        "Insights",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),

                              // ListTile(
                              //   leading: Icon(Icons.person),
                              //   title: Text(
                              //     "Participant List",
                              //     style: TextStyle(color: Colors.black),
                              //   ),
                              //   trailing: Icon(
                              //     Icons.arrow_right,
                              //     color: Colors.black,
                              //   ),
                              //   onTap: () {
                              //     data.submitListStatus != "submitted"
                              //         ? Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     ListOfParticipantView(
                              //                         uid: widget.uid,
                              //                         docRef: widget.docRef,
                              //                         totalEngage:
                              //                             data.totalParticipants,
                              //                         actualEngage:
                              //                             data.actualParticipants,
                              //                         avoidParticipants:
                              //                             data.avoidParticipants,
                              //                         submitListStatus:
                              //                             data.submitListStatus)))
                              //         : Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     SubmittedParticipantListView(
                              //                       docRef: widget.docRef,
                              //                     )));
                              //   },
                              // ),
                              // ListTile(
                              //   leading: Icon(Icons.analytics),
                              //   title: Text(
                              //     "Analytics",
                              //     style: TextStyle(color: Colors.black),
                              //   ),
                              //   trailing: Icon(
                              //     Icons.arrow_right,
                              //     color: Colors.black,
                              //   ),
                              //   onTap: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) => TaskHomePage(
                              //                 docRef: widget.docRef,
                              //                 submitStatus:
                              //                     data.submitListStatus)));
                              //   },
                              // ),
                              SizedBox(
                                height: 15,
                              ),
                              Divider(
                                height: 1,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(data.likes.toString()),
                                      RichText(
                                          text: TextSpan(children: [
                                        WidgetSpan(
                                          child: Icon(Icons.favorite, size: 20),
                                        ),
                                        TextSpan(
                                            text: " Likes",
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ]))
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(data.savedEvents.toString()),
                                      RichText(
                                          text: TextSpan(children: [
                                        WidgetSpan(
                                          child: Icon(Icons.bookmark, size: 20),
                                        ),
                                        TextSpan(
                                            text: " Saved",
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ]))
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(data.totalParticipants.toString()),
                                      Text("Total Engage"),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(data.actualParticipants.toString()),
                                      Text("Actual Engage"),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(data.avoidParticipants.toString()),
                                      Text("Avoidance"),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
