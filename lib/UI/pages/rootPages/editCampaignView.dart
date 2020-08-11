import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCampaignView extends StatefulWidget {
  final String docRef;

  EditCampaignView({Key key, this.docRef}) : super(key: key);

  @override
  _EditCampaignViewState createState() => _EditCampaignViewState();
}

class _EditCampaignViewState extends State<EditCampaignView> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final EventService _eventServices = Provider.of<EventService>(context);

    String docRef = widget.docRef;
    String bloodGroup;

    bool _formValidate = false;

    List<String> _bloodGroupType = [
      'A+',
      'O+',
      'B+',
      'AB+',
      'A-',
      'O-',
      'B-',
      'AB-'
    ];

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          // actionsIconTheme: null,
          iconTheme: IconThemeData(color: Colors.black),

          title: Text("Edit Campaign View"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: FutureBuilder<DocumentSnapshot>(
              future: _eventServices.requestEventsDetails(docRef),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  EventModel data = EventModel.fromMap(snapshot.data.data);
                  print(data.bloodGroup);

                  return SingleChildScrollView(
                      child: Form(
                          key: _formKey,
                          autovalidate: _formValidate,
                          child: Column(
                            children: <Widget>[],
                          )));
                }
              }),
        ),
      ),
    );
  }

  String validateBloodGroup(String value) {
    if (value == "Select Blood Type") {
      return 'Blood Type should be selected';
    }
    return null;
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to Discard Changes?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("NO, BY MISTAKE")),
                FlatButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("YES, I WANT TO"))
              ],
            ));
  }
}
