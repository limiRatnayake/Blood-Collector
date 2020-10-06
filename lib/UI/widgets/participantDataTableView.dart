import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/event_participant_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ParticipantDataTableView extends StatefulWidget {
  final String uid;
  final String participantId;
  ParticipantDataTableView({Key key, this.uid, this.participantId})
      : super(key: key);
  @override
  _ParticipantDataTableViewState createState() =>
      _ParticipantDataTableViewState();
}

class _ParticipantDataTableViewState extends State<ParticipantDataTableView> {
  bool participated = false;
   String participatedStatus;
  DocumentReference participantRef;
  Map<String, dynamic> participantData;
  _isParticipated() {
    setState(() {
      participated = !participated;
    });
  }

  @override
  void initState() {
    participantRef = Firestore.instance
        .collection("participants")
        .document(widget.participantId);

    super.initState();
    participantRef.get().then((value) {
      setState(() {
        participatedStatus =value.data["participatedStatus"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);
    final EventParticipantService _participantServices =
        Provider.of<EventParticipantService>(context);
    
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FutureBuilder(
          future: _userService.requestUserDetails(widget.uid),
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
                trailing: RaisedButton(
                    onPressed: () async {
                      _isParticipated();

                         participantRef.get().then((value) => {
                            if (value.data["participatedStatus"] != "participated")
                              {
                               
                                 participantRef.updateData({"participatedStatus":"participated"}),
                                 setState(() {
                                  participantRef.get().then((value) {
                                    participantData = value.data;
                                  });}
                                 )
                              
                              }
                            else
                              {
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Already participated")))
                              }
                          });

                    },
                    child:
                           participatedStatus != "participated"
                        ? Text("participating")
                        : Text("participated")),
                );
            }
          }),
    );
  }
}