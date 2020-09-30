import 'package:blood_collector/UI/widgets/participantDataTableView.dart';
import 'package:blood_collector/models/participant_model.dart';
import 'package:blood_collector/services/event_participant_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParticipantListView extends StatefulWidget {
  final String docRef;

  ParticipantListView({
    Key key,
    this.docRef,
  }) : super(key: key);
  @override
  _ParticipantListViewState createState() => _ParticipantListViewState();
}

class _ParticipantListViewState extends State<ParticipantListView> {
  @override
  Widget build(BuildContext context) {
    final EventParticipantService _participantServices =
        Provider.of<EventParticipantService>(context);
    print(widget.docRef);
    return Scaffold(
      appBar: AppBar(
        // actionsIconTheme: null,
        iconTheme: IconThemeData(color: Colors.black),

        title: Text("Participant List"),
      ),
      body: FutureBuilder(
          future: _participantServices.getParticipantForAnEvent(widget.docRef),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              List<ParticipantModel> dataList = snapshot.data.documents
                  .map<ParticipantModel>(
                      (doc) => ParticipantModel.fromMap(doc.data))
                  .toList();
              return dataList.length > 0
                  ? Container(
                      child: ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            ParticipantModel data = dataList[index];

                            return ParticipantDataTableView(uid: data.uid);
                          }))
                  : Padding(
                      padding: EdgeInsets.all(15),
                      child: Center(
                        child: Text(
                          "Please check again later.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
            }
          }),
    );
  }
}
