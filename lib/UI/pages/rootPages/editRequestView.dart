import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditRequestView extends StatefulWidget {
  final String docRef;

  EditRequestView({Key key, this.docRef}) : super(key: key);

  @override
  _EditRequestViewState createState() => _EditRequestViewState();
}

class _EditRequestViewState extends State<EditRequestView> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final EventService _eventServices = Provider.of<EventService>(context);

    String docRef = widget.docRef;
    String bloodGroup;
    String replacementAvailability;
    String unitsOfBlood;

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
    List<String> _replacementAvailabilityOption = [
      'Yes',
      'No',
    ];

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          // actionsIconTheme: null,
          iconTheme: IconThemeData(color: Colors.black),

          title: Text("Edit Request View"),
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

                  return SingleChildScrollView(
                      child: Form(
                          key: _formKey,
                          autovalidate: _formValidate,
                          child: Column(
                            children: <Widget>[
                              Card(
                                margin: EdgeInsets.symmetric(horizontal: 15.0),
                                child: ListTile(
                                  title: Text(
                                    "Blood group that you are looking for?",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  subtitle: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 4, left: 2),
                                    child: DropdownButtonFormField(
                                      value: data.bloodGroup,
                                      decoration: InputDecoration(
                                          hintText: 'Blood Type',
                                          hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: "Roboto",
                                              color: Colors.black54),
                                          enabledBorder: InputBorder.none),
                                      validator: validateDropdowns,
                                      items: _bloodGroupType.map((bloodgroup) {
                                        return DropdownMenuItem(
                                          value: bloodgroup,
                                          child: Text(bloodgroup),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          bloodGroup = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(horizontal: 15.0),
                                child: ListTile(
                                  title: Text(
                                    "Is replacement available at hospital?",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  subtitle: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 4, left: 2),
                                    child: DropdownButtonFormField(
                                      value: data.replacementAvailability,
                                      decoration: InputDecoration(
                                          // hintText: '',
                                          hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: "Roboto",
                                              color: Colors.black54),
                                          enabledBorder: InputBorder.none),
                                      validator: validateDropdowns,
                                      items: _replacementAvailabilityOption
                                          .map((availability) {
                                        return DropdownMenuItem(
                                          value: availability,
                                          child: Text(availability),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          replacementAvailability = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(horizontal: 15.0),
                                child: ListTile(
                                  title: Text(
                                    "How many units of blood you need?",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  subtitle: TextFormField(
                                    initialValue: data.unitsOfBlood,
                                    decoration: InputDecoration(
                                      hintText: "Units Of Blood",
                                      hintStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: "Roboto",
                                      ),
                                      // enabledBorder: InputBorder.none
                                    ),
                                    validator: validateBloodUnit,
                                    onChanged: (value) {
                                      setState(() {
                                        unitsOfBlood = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )));
                }
              }),
        ),
      ),
    );
  }

  String validateDropdowns(String value) {
    if (value == "Select a Type") {
      return 'This should be selected';
    }
    return null;
  }

  String validateBloodUnit(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'This feild is requried!!';
    } else if (!regExp.hasMatch(value)) {
      return "Name must be numeric vaue";
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
