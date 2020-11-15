// import 'dart:async';

// import 'package:blood_collector/UI/pages/rootPages/exploreMore/exploreCampaignMore.dart';
// import 'package:blood_collector/UI/pages/rootPages/raised_request.dart';
// import 'package:blood_collector/UI/pages/rootPages/request_history.dart';
// import 'package:blood_collector/models/event_model.dart';
// import 'package:blood_collector/models/participant_model.dart';
// import 'package:blood_collector/services/auth.dart';
// import 'package:blood_collector/services/event_participant_service.dart';
// import 'package:blood_collector/services/event_service.dart';
// import 'package:blood_collector/services/user_service.dart';
// import 'package:blood_collector/shared/appConstant.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';

// class SubmitAppTopBar extends StatefulWidget {
//   final String title;
//   final String docRef;
//   final String uid;

//   SubmitAppTopBar({
//     @required this.title,
//     @required this.docRef,
//     @required this.uid,
//   });

//   @override
//   _SubmitAppTopBarState createState() => _SubmitAppTopBarState();
// }

// class _SubmitAppTopBarState extends State<SubmitAppTopBar> {
//   CollectionReference eventRef;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     eventRef = Firestore.instance.collection("events");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PreferredSize(
//       preferredSize: const Size(double.infinity, kToolbarHeight),
//       child: AppBar(
//         title: Text(
//           widget.title,
//           style: TextStyle(color: Colors.redAccent),
//         ),
//         actions: <Widget>[submitButtons()],
//       ),
//     );
//   }

//   Widget submitButtons() {
//     final EventService _eventService = Provider.of<EventService>(context);
//     final EventParticipantService _participantService =
//         Provider.of<EventParticipantService>(context);
//     return FlatButton(
//       child: Text(
//         "Submit",
//         style: TextStyle(color: Colors.red),
//       ),
//       onPressed: () async {
//         List<ParticipantModel> participants = await _participantService
//             .getParticipantForParticularEvent(widget.docRef);

//         for (var i = 0; i < participants.length; i++) {
//           // participantId = participants[i].uid;

//           // print(participantId);
//           String response = await _eventService.addSubmitState(
//               widget.docRef, participants[i].uid);
//           if (response != "Success") {
//             final snackBar = SnackBar(
//               content: Text('There was an error submitting this',
//                   style: TextStyle(color: Colors.blueGrey)),
//             );
//             Scaffold.of(context).showSnackBar(snackBar);
//           } else {
//             Navigator.pop(context);
//             // Navigator.push(
//             //     context,
//             //     MaterialPageRoute(
//             //         builder: (context) => ExploreCampaignMore(
//             //               docRef: widget.docRef,
//             //               uid: widget.uid,
//             //             )));
//           }
//         }
//         // Alert(
//         //     context: context,
//         //     type: AlertType.success,
//         //     title: "Make sure that you have update all the users!",
//         //     content: Text("You may not able to change it again!"),
//         //     style: AlertStyle(
//         //         backgroundColor: Colors.black,
//         //         alertBorder: RoundedRectangleBorder(
//         //             borderRadius: BorderRadius.circular(5),
//         //             side: BorderSide(color: Colors.white)),
//         //         titleStyle: TextStyle(color: Colors.blueAccent)),
//         //     buttons: [
//         //       DialogButton(
//         //           width: 120,
//         //           child: Text(
//         //             "Ok",
//         //             style: TextStyle(color: Colors.white, fontSize: 20),
//         //           ),
//         //           onPressed: () {
//         //             //use pop route here becuase in slider_widget it should update & come back to same page
//         //             Navigator.pop(context);
//         //           }),
//         //       DialogButton(
//         //           width: 120,
//         //           child: Text(
//         //             "Submit",
//         //             style: TextStyle(color: Colors.white, fontSize: 20),
//         //           ),
//         //           onPressed: () async {
//         //             List<ParticipantModel> participants =
//         //                 await _participantService
//         //                     .getParticipantForParticularEvent(widget.docRef);

//         //             for (var i = 0; i < participants.length; i++) {
//         //               // participantId = participants[i].uid;

//         //               // print(participantId);
//         //               String response = await _eventService.addSubmitState(
//         //                   widget.docRef, participants[i].uid);
//         //               if (response != "Success") {
//         //                 final snackBar = SnackBar(
//         //                   content: Text('There was an error submitting this',
//         //                       style: TextStyle(color: Colors.blueGrey)),
//         //                 );
//         //                 Scaffold.of(context).showSnackBar(snackBar);
//         //               } else {
//         //                 Navigator.push(
//         //                     context,
//         //                     MaterialPageRoute(
//         //                         builder: (context) => ExploreCampaignMore(
//         //                               docRef: widget.docRef,
//         //                               uid: widget.uid,
//         //                             )));
//         //               }
//         //             }
//         //           })
//         //     ]).show();
//         // showDialog(
//         //   context: context,
//         //   builder: (context) {
//         //     return AlertDialog(
//         //       title:
//         //           Text("Make sure that you have update all the users!"),
//         //       content: Text("You may not able to change it again!"),
//         //       actions: [
//         //         FlatButton(
//         //           child: Text('Ok'),
//         //           onPressed: () {
//         //             Navigator.pop(context);
//         //           },
//         //         ),
//         //         FlatButton(
//         //             child: Text("submit"),
//         //             onPressed: () async {
//         //               // eventRef.document(widget.docRef).updateData(
//         //               //     {"avoidParticipants": avoidParticipants});
//         //               List<ParticipantModel> participants =
//         //                   await _participantService
//         //                       .getParticipantForParticularEvent(
//         //                           widget.docRef);

//         //               for (var i = 0; i < participants.length; i++) {
//         //                 // participantId = participants[i].uid;

//         //                 // print(participantId);
//         //                 String response =
//         //                     await _eventService.addSubmitState(
//         //                         widget.docRef, participants[i].uid);
//         //                 if (response != "Success") {
//         //                   final snackBar = SnackBar(
//         //                     content: Text(
//         //                         'There was an error submitting this',
//         //                         style:
//         //                             TextStyle(color: Colors.blueGrey)),
//         //                   );
//         //                   Scaffold.of(context).showSnackBar(snackBar);
//         //                 } else {
//         //                   Navigator.push(
//         //                       context,
//         //                       MaterialPageRoute(
//         //                           builder: (context) =>
//         //                               ExploreCampaignMore(
//         //                                 docRef: widget.docRef,
//         //                                 uid: widget.uid,
//         //                               )));
//         //                 }
//         //               }
//         //             })
//         //       ],
//         //     );
//         //   },
//         // );
//       },
//     );
//   }
// }
