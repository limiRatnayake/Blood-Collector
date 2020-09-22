import 'package:blood_collector/UI/widgets/radioButtonWidget.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewCampaignDetails extends StatefulWidget {
  final String docRef;
  final String uid;
  final String currentUser;

  ViewCampaignDetails({Key key, this.docRef, this.uid, this.currentUser})
      : super(key: key);
  @override
  _ViewDetailsState createState() => _ViewDetailsState();
}

//timeline card
class _ViewDetailsState extends State<ViewCampaignDetails> {
  DocumentReference interestedRef;
  CollectionReference eventRef;

  Map<String, dynamic> interestedData;
  @override
  void initState() {
    print(widget.currentUser);
    interestedRef = Firestore.instance
        .collection("events")
        .document(widget.docRef)
        .collection("interested")
        .document(widget.currentUser);

    super.initState();
    interestedRef.get().then((value) {
      interestedData = value.data;
    });
    eventRef = Firestore.instance.collection("events");
  }

  @override
  Widget build(BuildContext context) {
    final EventService _eventServices = Provider.of<EventService>(context);
    final AuthServices _authServices = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);

    return Scaffold(
      appBar: AppBar(),
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
                          return Column(
                            children: <Widget>[
                              Center(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(
                                    data.proPicUrl,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(data.firstName + " " + data.lastName),
                              SizedBox(
                                height: 8.0,
                              ),
                            ],
                          );
                        }
                      })
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              child: FutureBuilder(
                  future: _eventServices.requestEventsDetails(widget.docRef),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      EventModel data = EventModel.fromMap(snapshot.data.data);
                      var getRequestCloseDate =
                          DateTime.parse(data.requestClose);
                      String requestCloseDate =
                          DateFormat('yMd').format(getRequestCloseDate);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            child: ListTile(
                              leading: Icon(Icons.opacity),
                              title: Text("Organizered By"),
                              subtitle: Text(
                                data.nameOftheOrganizer,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Card(
                            child: ListTile(
                              leading: Icon(Icons.access_time),
                              title: Text("Time"),
                              subtitle:
                                  Text(data.startTime + " " + data.endTime),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Card(
                            child: ListTile(
                                leading: Icon(Icons.event_available),
                                title: Text("When they need blood"),
                                subtitle: Text(requestCloseDate.toString())),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Card(
                            child: ListTile(
                              leading: Icon(Icons.local_hospital),
                              title: Text("Place Name"),
                              subtitle: Text(data.placeName),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Card(
                            child: ListTile(
                              leading: Icon(Icons.location_on),
                              title: Text("Place Address"),
                              subtitle: Text(data.placeAddress),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          data.visibleState != false
                              ? Card(
                                  child: ListTile(
                                    leading: Icon(Icons.phone),
                                    title: Text("Organizer Contact Number"),
                                    subtitle: Text(data.orgernizerConatctNo),
                                    // trailing: Text(data.userPhoneNumber),
                                  ),
                                )
                              : Container(),
                        ],
                      );
                    }
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  textColor: Colors.black,
                  color: Colors.red.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.red)),
                  child: Row(children: [
                    Text("Participating",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 18.0,
                            color: Colors.black)),
                  ]),
                  onPressed: () {
                    _settingModalBottomSheet(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
      // bottomSheet: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: PreventDoubleTap(),
      // ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        isDismissible: true,
        context: context,
        builder: (BuildContext buildContext) {
          return RadioButtonWidget(
            docRef: widget.docRef,
            uid: widget.uid,
            currentUser: widget.currentUser,
          );
        });
  }
}
