//pages
import 'package:blood_collector/models/participant_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/event_participant_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//packages
import 'package:provider/provider.dart';

class SubmittedParticipantListView extends StatefulWidget {
  final String docRef;

  const SubmittedParticipantListView({Key key, this.docRef}) : super(key: key);

  @override
  _SubmittedParticipantListViewState createState() =>
      _SubmittedParticipantListViewState();
}

class _SubmittedParticipantListViewState
    extends State<SubmittedParticipantListView> {
  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);
    final EventParticipantService _participantService =
        Provider.of<EventParticipantService>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Submitted Participant List"),
        ),
        body: FutureBuilder(
            future: _participantService.getParticipantForAnEvent(widget.docRef),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                List<ParticipantModel> dataList = snapshot.data.documents
                    .map<ParticipantModel>(
                        (doc) => ParticipantModel.fromMap(doc.data))
                    .toList();
                return dataList.length > 0
                    ? ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          ParticipantModel data = dataList[index];

                          return FutureBuilder(
                              future: _userService.requestUserDetails(data.uid),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  UserModel userData =
                                      UserModel.fromMap(snapshot.data.data);

                                  return ListTile(
                                      leading: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.grey,
                                        backgroundImage: NetworkImage(
                                          userData.proPicUrl,
                                        ),
                                      ),
                                      title: Text(userData.firstName +
                                          " " +
                                          userData.lastName),
                                      subtitle: Text(userData.bloodGroup),
                                      trailing: Text(
                                        data.participatedStatus,
                                        style: TextStyle(color: Colors.green),
                                      ));
                                }
                              });
                        })
                    : Container();
              }
            }));
  }
}

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
