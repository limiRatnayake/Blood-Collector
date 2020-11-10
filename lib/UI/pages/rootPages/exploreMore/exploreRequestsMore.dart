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

class ExploreRequestsMore extends StatefulWidget {
  final String docRef;
  final String uid;

  ExploreRequestsMore({
    Key key,
    this.docRef,
    this.uid,
  }) : super(key: key);

  @override
  _ExploreRequestsMoreState createState() => _ExploreRequestsMoreState();
}

//timeline card
class _ExploreRequestsMoreState extends State<ExploreRequestsMore> {
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
                            DateTime requestClose = data.requestClose.toDate();
                            String requestCloseDate =
                                DateFormat('yMd').format(requestClose);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.opacity),
                                  title: Text("Requested Blood Type"),
                                  subtitle: Text(
                                    data.bloodGroup,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(Icons.check_box_outline_blank),
                                  title: Text("Units of Blood"),
                                  subtitle: Text(data.unitsOfBlood),
                                ),
                                ListTile(
                                    leading: Icon(Icons.event_available),
                                    title: Text("When they need blood"),
                                    subtitle: Text(requestCloseDate)),
                                ListTile(
                                  leading: Icon(Icons.local_hospital),
                                  title: Text("Hospital Name"),
                                  subtitle: Text(data.hospitalName),
                                ),
                                ListTile(
                                  leading: Icon(Icons.directions),
                                  title: Text("Hospital Address"),
                                  subtitle: Text(data.hospitalAddress),
                                ),
                                Divider(
                                  height: 1,
                                ),
                                Card(
                                    child: Column(
                                  children: [
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
                                                child: Icon(Icons.favorite,
                                                    size: 20),
                                              ),
                                              TextSpan(
                                                  text: " Likes",
                                                  style: TextStyle(
                                                      color: Colors.black)),
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
                                                child: Icon(Icons.bookmark,
                                                    size: 20),
                                              ),
                                              TextSpan(
                                                  text: " Saved",
                                                  style: TextStyle(
                                                      color: Colors.black)),
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
                                            Text(data.notifyCount.toString()),
                                            Text("Notified"),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("0"),
                                            Text("Unit Filled"),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(data.userAccepted.toString()),
                                            Text("User Accepted"),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ))
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
