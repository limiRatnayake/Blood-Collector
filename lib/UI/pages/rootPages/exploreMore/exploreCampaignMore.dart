import 'package:blood_collector/UI/pages/rootPages/participantListView.dart';
import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/preventDooubleTap.dart';
import 'package:blood_collector/UI/widgets/slider_campaign_widget.dart';
import 'package:blood_collector/UI/widgets/slider_request_widget.dart';
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
    final AuthServices _authServices = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);

    return Scaffold(
      appBar: AppBar(
        // actionsIconTheme: null,
        iconTheme: IconThemeData(color: Colors.black),

        title: Text("Request Explore"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
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
                  Container(
                    child: FutureBuilder(
                        future:
                            _eventServices.requestEventsDetails(widget.docRef),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            EventModel data =
                                EventModel.fromMap(snapshot.data.data);
                            var getRequestCloseDate =
                                DateTime.parse(data.requestClose);
                            String requestCloseDate =
                                DateFormat('yMd').format(getRequestCloseDate);
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
                                    subtitle:
                                        Text(requestCloseDate.toString())),

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
                                //if organizer checked to visible contact number to the public
                                data.visibleState != false
                                    ? ListTile(
                                        leading: Icon(Icons.phone),
                                        title: Text("Organizer Contact Number"),
                                        subtitle:
                                            Text(data.orgernizerConatctNo),
                                        // trailing: Text(data.userPhoneNumber),
                                      )
                                    : Container(),
                                ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text(
                                    "Participant List",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_right,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ParticipantListView(
                                                    docRef: widget.docRef)));
                                  },
                                )
                              ],
                            );
                          }
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
      // bottomSheet: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: PreventDoubleTap(),
      // ),
    );
  }
}
