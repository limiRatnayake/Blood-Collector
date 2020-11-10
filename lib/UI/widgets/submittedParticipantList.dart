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

Widget actualParticipantList(
  BuildContext context,
  DocumentSnapshot document,
  CollectionReference eventRef,
) {
  final participants = ParticipantModel.fromMap(document.data);
  final UserService _userService = Provider.of<UserService>(context);

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
              trailing: Text(
                participants.participatedStatus,
                style: TextStyle(color: Colors.green),
              ));
        }
      });
}
