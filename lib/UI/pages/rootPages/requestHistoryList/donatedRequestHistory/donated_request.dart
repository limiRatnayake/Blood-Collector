// pages
import 'package:blood_collector/UI/pages/rootPages/requestHistoryList/donatedRequestHistory/donatedRequestPostWidget.dart';
import 'package:blood_collector/models/participant_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_participant_service.dart';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonatedRequestView extends StatefulWidget {
  @override
  _DonatedRequestViewState createState() => _DonatedRequestViewState();
}

class _DonatedRequestViewState extends State<DonatedRequestView> {
  String participateId;
  String eventId;

  DocumentReference interestedRef;
  final participantRef = FirebaseFirestore.instance;

  @override
  void initState() {
    participantRef
        .collection("participants")
        .get()
        .then((QuerySnapshot snapshot) => snapshot.docs.forEach((element) {
              participateId = element.id;
            }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthServices _authServices = Provider.of<AuthServices>(context);
    final EventParticipantService _participantServices =
        Provider.of<EventParticipantService>(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        padding: EdgeInsets.all(8),
        child: FutureBuilder(
            future: _participantServices.getParticipant(_authServices.user.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                List<ParticipantModel> dataList = snapshot.data.documents
                    .map<ParticipantModel>(
                        (doc) => ParticipantModel.fromMap(doc.data()))
                    .toList();
                return dataList.length > 0
                    ? Container(
                        child: ListView.builder(
                            itemCount: dataList.length,
                            itemBuilder: (context, index) {
                              ParticipantModel data = dataList[index];

                              return DonatedRequestedGetEvents(
                                  participantId: data.participantId,
                                  uid: data.uid,
                                  docRef: data.docRef,
                                  currentUser: _authServices.user.uid,
                                  participatedStatus: data.participatedStatus);
                            }))
                    : Padding(
                        padding: EdgeInsets.all(15),
                        child: Center(
                          child: Text(
                            "You did not participate for any events",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
              }
            }),
      ),
    );
  }
}
