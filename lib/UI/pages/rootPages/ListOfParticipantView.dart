import 'package:blood_collector/UI/widgets/participantListViewWidget.dart';
import 'package:blood_collector/models/participant_model.dart';
import 'package:blood_collector/services/event_participant_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfParticipantView extends StatefulWidget {
  final String docRef;

  ListOfParticipantView({
    Key key,
    this.docRef,
  }) : super(key: key);
  @override
  _ListOfParticipantViewState createState() => _ListOfParticipantViewState();
}

class _ListOfParticipantViewState extends State<ListOfParticipantView> {
  @override
  Widget build(BuildContext context) {
    final EventParticipantService _participantServices =
        Provider.of<EventParticipantService>(context);

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
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Name"),
                            Text("Participated/" + "\n" + "Not Participated"),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: dataList.length,
                              itemBuilder: (context, index) {
                                ParticipantModel data = dataList[index];

                                return ParticipantListView(
                                    uid: data.uid,
                                    docRef: data.docRef,
                                    participantId: data.participantId,
                                    participatedStatus:
                                        data.participatedStatus);
                              }),
                        )
                      ],
                    )
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
