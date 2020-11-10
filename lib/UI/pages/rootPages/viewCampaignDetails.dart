import 'package:blood_collector/UI/widgets/slider_campaign_widget.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewCampaignDetails extends StatefulWidget {
  final String docRef;
  final String uid;
  final String currentUser;
  final String image;

  ViewCampaignDetails(
      {Key key, this.docRef, this.uid, this.currentUser, this.image})
      : super(key: key);
  @override
  _ViewCampaignDetailsState createState() => _ViewCampaignDetailsState();
}

class _ViewCampaignDetailsState extends State<ViewCampaignDetails> {
  UserService _userService;
  EventService _eventServices;
  final participantRef = Firestore.instance;
  bool participated = false;
  String participateId;
  bool participatedStatus;
  bool inclueInParticipantList;

  _isParticipated() {
    setState(() {
      participated = !participated;
    });
  }

  @override
  void initState() {
    participantRef
        .collection("participants")
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.forEach((element) {
              participateId = element.documentID;

              if (element.data.containsValue(widget.docRef) &&
                  element.data.containsValue(widget.currentUser) &&
                  !(element.data.containsValue("Cancelled"))) {
                setState(() {
                  inclueInParticipantList = true;
                });
              }
              //if user mark as a participant they can't participate for another one
              //until this one is finished
              if (element.data.containsValue("participating") &&
                  element.data.containsValue(widget.currentUser)) {
                setState(() {
                  participatedStatus = true;
                });
              }
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);
    _eventServices = Provider.of<EventService>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // expandedHeight: 156.0,
            title: Text(
              "View Details",
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder(
                future: _userService.requestUserDetails(widget.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    UserModel data = UserModel.fromMap(snapshot.data.data);
                    return Column(
                      children: [
                        widget.image != ""
                            ? Stack(
                                overflow: Overflow.visible,
                                alignment: Alignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (builder) {
                                          return GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: Container(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/loading.png',
                                                image: widget.image,
                                                placeholderScale: 1,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Image(
                                      // color: Colors.blue,
                                      image: NetworkImage(widget.image),
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -50,
                                    child: CircleAvatar(
                                      radius: 45,
                                      backgroundColor: Colors.grey,
                                      backgroundImage: NetworkImage(
                                        data.proPicUrl,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(
                                    data.proPicUrl,
                                  ),
                                ),
                              ),
                        widget.image != ""
                            ? SizedBox(
                                height: 50,
                              )
                            : SizedBox(
                                height: 10,
                              ),
                        Text(data.firstName + " " + data.lastName,
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            )),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    );
                  }
                }),
          ),
          SliverList(
              delegate: SliverChildListDelegate(<Widget>[
            AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                              Card(
                                child: Column(
                                  children: [
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
                                      subtitle: Text(
                                          data.startTime + " " + data.endTime),
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
                                    data.visibleState != false
                                        ? ListTile(
                                            leading: Icon(Icons.phone),
                                            title: Text(
                                                "Organizer Contact Number"),
                                            subtitle:
                                                Text(data.orgernizerConatctNo),
                                            // trailing: Text(data.userPhoneNumber),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                ))
          ])),
          //  wrapping the raisedbutton with the builder to display the snackbar so,
          //snackbar uses the context from builder
          //I used it bcz the current container doesn't conatain a builder(in the body)
          SliverToBoxAdapter(
            child: Builder(
                builder: (context) => Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 25, top: 10, bottom: 10),
                      child: Container(
                          child: (RaisedButton(
                              textColor: Colors.black,
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.5)),
                              onPressed: () {
                                _isParticipated();

                                if (inclueInParticipantList != true &&
                                    participatedStatus != true) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CampaignIntroSliderWidget(
                                                  docRef: widget.docRef,
                                                  currentUser:
                                                      widget.currentUser)));
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text(
                                        'Sorry! You are already participated an event!'),
                                  );

                                  // it to show a SnackBar.
                                  Scaffold.of(context).showSnackBar(snackBar);
                                }
                              },
                              child: inclueInParticipantList != true
                                  ? Text(
                                      "Participating",
                                      style: TextStyle(fontSize: 16),
                                    )
                                  : Text("Participated",
                                      style: TextStyle(fontSize: 16))))),
                    )),
          )
        ],
      ),
    );
  }
}

// import 'package:blood_collector/UI/widgets/radioButtonWidget.dart';
// import 'package:blood_collector/UI/widgets/slider_campaign_widget.dart';
// import 'package:blood_collector/models/event_model.dart';
// import 'package:blood_collector/models/user_model.dart';
// import 'package:blood_collector/services/auth.dart';
// import 'package:blood_collector/services/event_service.dart';
// import 'package:blood_collector/services/user_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class ViewCampaignDetails extends StatefulWidget {
//   final String docRef;
//   final String uid;
//   final String currentUser;

//   ViewCampaignDetails({Key key, this.docRef, this.uid, this.currentUser})
//       : super(key: key);
//   @override
//   _ViewDetailsState createState() => _ViewDetailsState();
// }

// //timeline card
// class _ViewDetailsState extends State<ViewCampaignDetails> {
//   final participantRef = Firestore.instance;
//   bool participated = false;
//   String participateId;
//   bool participatedStatus;
//   bool inclueInParticipantList;

//   _isParticipated() {
//     setState(() {
//       participated = !participated;
//     });
//   }

//   @override
//   void initState() {
//     participantRef
//         .collection("participants")
//         .getDocuments()
//         .then((QuerySnapshot snapshot) => snapshot.documents.forEach((element) {
//               participateId = element.documentID;

//               if (element.data.containsValue(widget.docRef) &&
//                   element.data.containsValue(widget.currentUser)) {
//                 setState(() {
//                   inclueInParticipantList = true;
//                 });
//               }
//               //if user mark as a participant they can't participate for another one
//               //until this one is finished
//               if (element.data.containsValue("participating") &&
//                   element.data.containsValue(widget.currentUser)) {
//                 setState(() {
//                   participatedStatus = true;
//                 });
//               }
//             }));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final EventService _eventServices = Provider.of<EventService>(context);
//     final AuthServices _authServices = Provider.of<AuthServices>(context);
//     final UserService _userService = Provider.of<UserService>(context);

//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Card(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   //get user profile data
//                   FutureBuilder(
//                       future: _userService.requestUserDetails(widget.uid),
//                       builder: (context, snapshot) {
//                         if (!snapshot.hasData) {
//                           return Center(child: CircularProgressIndicator());
//                         } else {
//                           UserModel data =
//                               UserModel.fromMap(snapshot.data.data);
//                           return Column(
//                             children: <Widget>[
//                               Center(
//                                 child: CircleAvatar(
//                                   radius: 50,
//                                   backgroundColor: Colors.grey,
//                                   backgroundImage: NetworkImage(
//                                     data.proPicUrl,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 8.0,
//                               ),
//                               Text(data.firstName + " " + data.lastName),
//                               SizedBox(
//                                 height: 8.0,
//                               ),
//                             ],
//                           );
//                         }
//                       })
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 15.0,
//             ),
//             Container(
//               child: FutureBuilder(
//                   future: _eventServices.requestEventsDetails(widget.docRef),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return Center(child: CircularProgressIndicator());
//                     } else {
//                       EventModel data = EventModel.fromMap(snapshot.data.data);
//                       var getRequestCloseDate =
//                           DateTime.parse(data.requestClose);
//                       String requestCloseDate =
//                           DateFormat('yMd').format(getRequestCloseDate);
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Card(
//                             child: ListTile(
//                               leading: Icon(Icons.opacity),
//                               title: Text("Organizered By"),
//                               subtitle: Text(
//                                 data.nameOftheOrganizer,
//                                 style: TextStyle(color: Colors.red),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10.0,
//                           ),
//                           Card(
//                             child: ListTile(
//                               leading: Icon(Icons.access_time),
//                               title: Text("Time"),
//                               subtitle:
//                                   Text(data.startTime + " " + data.endTime),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10.0,
//                           ),
//                           Card(
//                             child: ListTile(
//                                 leading: Icon(Icons.event_available),
//                                 title: Text("When they need blood"),
//                                 subtitle: Text(requestCloseDate.toString())),
//                           ),
//                           SizedBox(
//                             height: 10.0,
//                           ),
//                           Card(
//                             child: ListTile(
//                               leading: Icon(Icons.local_hospital),
//                               title: Text("Place Name"),
//                               subtitle: Text(data.placeName),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10.0,
//                           ),
//                           Card(
//                             child: ListTile(
//                               leading: Icon(Icons.location_on),
//                               title: Text("Place Address"),
//                               subtitle: Text(data.placeAddress),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10.0,
//                           ),
//                           //if organizer checked to visible contact number to the public
//                           data.visibleState != false
//                               ? Card(
//                                   child: ListTile(
//                                     leading: Icon(Icons.phone),
//                                     title: Text("Organizer Contact Number"),
//                                     subtitle: Text(data.orgernizerConatctNo),
//                                     // trailing: Text(data.userPhoneNumber),
//                                   ),
//                                 )
//                               : Container(),
//                         ],
//                       );
//                     }
//                   }),
//             ),

//             //wrapping the raisedbutton with the builder to display the snackbar so,
//             //snackbar uses the context from builder
//             //I used it bcz the current container doesn't conatain a builder(in the body)
//             Builder(
//                 builder: (context) => Container(
//                     width: MediaQuery.of(context).size.width * 0.78,
//                     child: (RaisedButton(
//                         textColor: Colors.black,
//                         color: Colors.red,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25.5)),
//                         onPressed: () {
//                           _isParticipated();

//                           if (inclueInParticipantList != true &&
//                               participatedStatus != true) {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         CampaignIntroSliderWidget(
//                                             docRef: widget.docRef,
//                                             currentUser: widget.currentUser)));
//                           } else {
//                             final snackBar = SnackBar(
//                               content: Text(
//                                   'Sorry! You are already participated an event!'),
//                             );

//                             // it to show a SnackBar.
//                             Scaffold.of(context).showSnackBar(snackBar);
//                           }
//                         },
//                         child: inclueInParticipantList != true
//                             ? Text(
//                                 "Participating",
//                                 style: TextStyle(fontSize: 16),
//                               )
//                             : Text("Participated",
//                                 style: TextStyle(fontSize: 16))))))
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             //   children: [
//             //     RaisedButton(
//             //       textColor: Colors.black,
//             //       color: Colors.red.withOpacity(0.9),
//             //       shape: RoundedRectangleBorder(
//             //           borderRadius: BorderRadius.circular(10.0),
//             //           side: BorderSide(color: Colors.red)),
//             //       child: Row(children: [
//             //         Text("Participating",
//             //             style: TextStyle(
//             //                 fontFamily: "Roboto",
//             //                 fontSize: 18.0,
//             //                 color: Colors.black)),
//             //       ]),
//             //       onPressed: () {
//             //         _settingModalBottomSheet(context);
//             //       },
//             //     ),
//             //   ],
//             // )
//           ],
//         ),
//       ),
//       // bottomSheet: Padding(
//       //   padding: const EdgeInsets.all(8.0),
//       //   child: PreventDoubleTap(),
//       // ),
//     );
//   }

//   void _settingModalBottomSheet(context) {
//     showModalBottomSheet(
//         isDismissible: true,
//         context: context,
//         builder: (BuildContext buildContext) {
//           return RadioButtonWidget(
//             docRef: widget.docRef,
//             uid: widget.uid,
//             currentUser: widget.currentUser,
//           );
//         });
//   }
// }
