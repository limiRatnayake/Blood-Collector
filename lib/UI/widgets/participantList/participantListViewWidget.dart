//pages
import 'package:blood_collector/models/participant_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/event_participant_service.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget buildParticipantsList(
    BuildContext context,
    DocumentSnapshot document,
    CollectionReference eventRef,
    CollectionReference userRef,
    String docRef,
    int totalEngage,
    int actualEngage,
    int avoidParticipants) {
  final participants = ParticipantModel.fromMap(document.data());
  final UserService _userService = Provider.of<UserService>(context);
  final EventService _eventService = Provider.of<EventService>(context);
  final EventParticipantService _participantServices =
      Provider.of<EventParticipantService>(context);

  return Container(
      child: FutureBuilder(
          future: _userService.requestUserDetails(participants.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              UserModel data = UserModel.fromMap(snapshot.data.data());

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
                    children: [
                      FutureBuilder(
                          future: _participantServices
                              .participantDetails(participants.participantId),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              ParticipantModel docData =
                                  ParticipantModel.fromMap(
                                      snapshot.data.data());

                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  participants.participatedStatus != "Donated"
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.done,
                                            color: Colors.green,
                                          ),
                                          onPressed: () async {
                                            String response =
                                                await _participantServices
                                                    .updateDataOfParticipating(
                                                        DateTime.now()
                                                            .toString(),
                                                        participants
                                                            .participantId,
                                                        "Donated");
                                          })
                                      : Container(),
                                  participants.participatedStatus !=
                                          "Not participated"
                                      ? IconButton(
                                          icon: Icon(Icons.dangerous,
                                              color: Colors.red),
                                          onPressed: () async {
                                            String response =
                                                await _participantServices
                                                    .updateDataOfParticipating(
                                                        DateTime.now()
                                                            .toString(),
                                                        participants
                                                            .participantId,
                                                        "Not participated");
                                          })
                                      : Container()
                                ],
                              );
                            }
                          }),
                    ],
                  ));
            }
          }));
}
