import 'package:blood_collector/models/participant_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/event_participant_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:travel_budget/models/Trip.dart';
// import 'package:travel_budget/views/detail_trip_view.dart';

Widget buildParticipantsList(BuildContext context, DocumentSnapshot document,
    CollectionReference eventRef) {
  final participants = ParticipantModel.fromMap(document.data);
  final UserService _userService = Provider.of<UserService>(context);
  final EventParticipantService _participantServices =
      Provider.of<EventParticipantService>(context);

  return FutureBuilder(
      future: _userService.requestUserDetails(participants.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          UserModel data = UserModel.fromMap(snapshot.data.data);

          return ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                data.proPicUrl,
              ),
            ),
            title: Text(data.firstName + " " + data.lastName),
            subtitle: Text(data.bloodGroup),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              // space between two icons
              children: <Widget>[
                participants.participatedStatus != "Donated"
                    ? IconButton(
                        icon: Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          await _participantServices.updateDataOfParticipating(
                              participants.uid,
                              DateTime.now().toString(),
                              participants.participantId,
                              "Donated");
                          Firestore.instance
                              .runTransaction((Transaction tx) async {
                            DocumentSnapshot docSnapshot = await tx
                                .get(eventRef.document(participants.docRef));
                            if (docSnapshot.exists) {
                              await tx.update(
                                  eventRef.document(participants.docRef),
                                  <String, dynamic>{
                                    'actualParticipants':
                                        docSnapshot.data["actualParticipants"] +
                                            1
                                  });
                            }
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.dangerous,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await _participantServices.updateDataOfParticipating(
                              participants.uid,
                              DateTime.now().toString(),
                              participants.participantId,
                              "Not participated");
                          Firestore.instance
                              .runTransaction((Transaction tx) async {
                            DocumentSnapshot docSnapshot = await tx
                                .get(eventRef.document(participants.docRef));
                            if (docSnapshot.exists) {
                              await tx.update(
                                  eventRef.document(participants.docRef),
                                  <String, dynamic>{
                                    'actualParticipants':
                                        docSnapshot.data["actualParticipants"] -
                                            1
                                  });
                            }
                          });
                        },
                      ), // icon-1
                // icon-2
              ],
            ),
          );
        }
      });
}

// import 'package:blood_collector/models/user_model.dart';
// import 'package:blood_collector/services/event_participant_service.dart';
// import 'package:blood_collector/services/user_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ParticipantListView extends StatefulWidget {
//   final String uid;
//   final String docRef;
//   final String participantId;
//   final String participatedStatus;
//   ParticipantListView(
//       {Key key,
//       this.uid,
//       this.docRef,
//       this.participantId,
//       this.participatedStatus})
//       : super(key: key);
//   @override
//   _ParticipantListViewState createState() => _ParticipantListViewState();
// }

// class _ParticipantListViewState extends State<ParticipantListView> {
//   bool participated = false;
//   String participatedStatus;
//   DocumentReference participantRef;
//   CollectionReference eventRef;
//   Map<String, dynamic> participantData;
//   _isParticipated() {
//     setState(() {
//       participated = !participated;
//     });
//   }

//   @override
//   void initState() {
//     participantRef = Firestore.instance
//         .collection("participants")
//         .document(widget.participantId);
//     eventRef = Firestore.instance.collection("events");

//     super.initState();
//     participantRef.get().then((value) {
//       participantData = value.data;
//     });
//     // participantRef.get().then((value) {
//     //   setState(() {
//     //     participatedStatus = value.data["participatedStatus"];
//     //   });
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final UserService _userService = Provider.of<UserService>(context);
//     final EventParticipantService _participantServices =
//         Provider.of<EventParticipantService>(context);

//     return FutureBuilder(
//         future: _userService.requestUserDetails(widget.uid),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           } else {
//             UserModel data = UserModel.fromMap(snapshot.data.data);

//             return ListTile(
//               leading: CircleAvatar(
//                 radius: 20,
//                 backgroundColor: Colors.grey,
//                 backgroundImage: NetworkImage(
//                   data.proPicUrl,
//                 ),
//               ),
//               title: Text(data.firstName + " " + data.lastName),
//               subtitle: Text(data.bloodGroup),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   widget.participatedStatus != "Donated"
//                       ? RaisedButton(
//                           color: Colors.green.shade400,
//                           onPressed: () async {
//                             await _participantServices
//                                 .updateDataOfParticipating(
//                                     widget.uid,
//                                     DateTime.now().toString(),
//                                     widget.participantId,
//                                     "Donated");
//                             Firestore.instance
//                                 .runTransaction((Transaction tx) async {
//                               DocumentSnapshot docSnapshot = await tx
//                                   .get(eventRef.document(widget.docRef));
//                               if (docSnapshot.exists) {
//                                 await tx.update(
//                                     eventRef.document(widget.docRef),
//                                     <String, dynamic>{
//                                       'ActualParticipants': docSnapshot
//                                               .data["ActualParticipants"] +
//                                           1
//                                     });
//                               }
//                             });
//                           },
//                           child: Text(
//                             "Yes",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         )
//                       : Container(),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   RaisedButton(
//                     color: Colors.red.shade400,
//                     onPressed: () async {
//                       Firestore.instance.runTransaction((Transaction tx) async {
//                         DocumentSnapshot docSnapshot =
//                             await tx.get(eventRef.document(widget.docRef));
//                         if (docSnapshot.exists) {
//                           await tx.update(
//                               eventRef.document(widget.docRef),
//                               <String, dynamic>{
//                                 'MissedParticipants':
//                                     docSnapshot.data["MissedParticipants"] + 1
//                               });
//                         }
//                       });
//                       await _participantServices.updateDataOfParticipating(
//                           widget.uid,
//                           DateTime.now().toString(),
//                           widget.participantId,
//                           "Not participated");
//                     },
//                     child: Text(
//                       "No",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   )
//                 ],
//               ),
//               // trailing: RaisedButton(
//               //     color: Colors.blue.shade50,
//               //     onPressed: () async {
//               //       _isParticipated();

//               //       participantRef.get().then((value) => {
//               //             if (value.data["participatedStatus"] !=
//               //                 "participated")
//               //               {
//               //                 participantRef.updateData(
//               //                     {"participatedStatus": "participated"}),
//               //                 setState(() {
//               //                   participantRef.get().then((value) {
//               //                     participantData = value.data;
//               //                   });
//               //                 })
//               //               }
//               //             else
//               //               {
//               //                 Scaffold.of(context).showSnackBar(SnackBar(
//               //                     content: Text("Already participated")))
//               //               }
//               //           });
//               //     },
//               //     child: participantData != null &&
//               //             participantData.containsValue("participated")
//               //         ? Text(
//               //             "participated",
//               //             style: TextStyle(color: Colors.blue),
//               //           )
//               //         : Text("participating")),
//             );
//           }
//         });
//   }
// }
