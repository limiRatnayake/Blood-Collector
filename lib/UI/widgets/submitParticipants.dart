import 'package:blood_collector/UI/pages/rootPages/exploreMore/exploreCampaignMore.dart';
import 'package:blood_collector/UI/pages/rootPages/notificationView.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/participant_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_participant_service.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubmitAppTopBar extends StatefulWidget {
  final String title;
  final String docRef;
  final int totalParticipants;
  final int actualParticipants;
  final int avoidParticipants;

  SubmitAppTopBar({
    @required this.title,
    @required this.docRef,
    @required this.totalParticipants,
    @required this.actualParticipants,
    @required this.avoidParticipants,
  });

  @override
  _SubmitAppTopBarState createState() => _SubmitAppTopBarState();
}

class _SubmitAppTopBarState extends State<SubmitAppTopBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, kToolbarHeight),
      child: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.redAccent),
        ),
        actions: <Widget>[appBarIcon(context)],
      ),
    );
  }

  Widget appBarIcon(BuildContext context) {
    final AuthServices _authService = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);
    final EventService _eventService = Provider.of<EventService>(context);
    final EventParticipantService _participantService =
        Provider.of<EventParticipantService>(context);
    // final participants = ParticipantModel.fromMap(widget.resultListDocs.data);

    return FutureBuilder(
        future: _participantService.getParticipantsForEvent(widget.docRef),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<ParticipantModel> dataList = snapshot.data.documents
                .map<ParticipantModel>(
                    (doc) => ParticipantModel.fromMap(doc.data))
                .toList();
//  List<HospitalListModel> hospitalItems = snapshot.data;
            String participantUsers;
            for (int i = 0; i < dataList.length; i++) {
              participantUsers = dataList[i].uid;
            }
            return (widget.totalParticipants ==
                    widget.actualParticipants + widget.avoidParticipants)
                ? FlatButton(
                    child: Text("Submit"),
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                                  title: Text(
                                      "Make sure that you have update all the users!"),
                                  content: Text(
                                      "You may not able to change it again!"),
                                  actions: [
                                    FlatButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Submit"),
                                      onPressed: () async {
                                        String response =
                                            await _eventService.addSubmitState(
                                                widget.docRef,
                                                participantUsers);
                                        if (response != "Success") {
                                          final snackBar = SnackBar(
                                            content: Text(
                                                'There was an error submitting this',
                                                style: TextStyle(
                                                    color: Colors.blueGrey)),
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ExploreCampaignMore(
                                                        docRef: widget.docRef,
                                                        uid: _authService
                                                            .user.uid,
                                                      )));
                                        }
                                      },
                                    )
                                  ]));
                    },
                  )
                : FlatButton(
                    child: Text('submit'),
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                                  title: Text(
                                      "Make sure that you have update all the users!"),
                                  actions: [
                                    FlatButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ]));
                    },
                  );
          }
        });
  }
}
