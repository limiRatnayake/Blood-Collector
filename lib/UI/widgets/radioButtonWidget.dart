import 'package:blood_collector/UI/widgets/slider_campaign_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RadioButtonWidget extends StatefulWidget {
  final String docRef;
  final String uid;
  final String currentUser;

  RadioButtonWidget({
    Key key,
    this.docRef,
    this.uid,
    this.currentUser,
  }) : super(key: key);
  @override
  _RadioButtonWidgetState createState() => _RadioButtonWidgetState();
}

class _RadioButtonWidgetState extends State<RadioButtonWidget> {
  int _radioValue;
  DocumentReference interestedRef;
  final participantRef = Firestore.instance;
  CollectionReference eventRef;

  bool isInterested = false;
  String participateId;
  var eventId;
  Map<String, dynamic> interestedData;
  Map<String, dynamic> participants;

  _setSelectedRadio(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  @override
  void initState() {
    interestedRef = Firestore.instance
        .collection("events")
        .document(widget.docRef)
        .collection("interested")
        .document(widget.currentUser);

    participantRef
        .collection("participants")
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.forEach((element) {
              participateId = element.documentID;
              eventId = element.data["docRef"];
              if (eventId == widget.docRef) {
                setState(() {
                  _radioValue = 2;
                });
              }
            }));

    interestedRef.get().then((value) {
      interestedData = value.data;

      if (interestedData != null && interestedData.containsKey(widget.docRef)) {
        setState(() {
          _radioValue = 1;
        });
      }
    });

    eventRef = Firestore.instance.collection("events");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Wrap(
        children: <Widget>[
          new ListTile(
            leading: Radio(
              value: 1,
              groupValue: _radioValue,
              onChanged: (value) {
                _setSelectedRadio(value);
                interestedRef.get().then((value) => {
                      if (value.data == null)
                        {
                          Firestore.instance
                              .runTransaction((Transaction tx) async {
                            DocumentSnapshot docSnapshot =
                                await tx.get(eventRef.document(widget.docRef));
                            if (docSnapshot.exists) {
                              await tx.update(
                                  eventRef.document(widget.docRef),
                                  <String, dynamic>{
                                    'interested':
                                        docSnapshot.data["interested"] + 1
                                  });
                            }
                          }),
                          interestedRef.setData({widget.docRef: true}),
                          setState(() {
                            interestedRef.get().then((value) {
                              interestedData = value.data;
                            });
                          }),
                          participantRef
                              .collection("participants")
                              .document(participateId)
                              .delete()
                        }
                    });
              },
            ),
            title: new Text('Interested'),
          ),
          new ListTile(
            leading: Radio(
              value: 2,
              groupValue: _radioValue,
              onChanged: (value) {
                _setSelectedRadio(value);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CampaignIntroSliderWidget(
                            docRef: widget.docRef,
                            currentUser: widget.currentUser)));
              },
            ),
            title: new Text('Participate'),
          ),
          new ListTile(
            leading: Radio(
              value: 3,
              groupValue: _radioValue,
              onChanged: (value) {
                _setSelectedRadio(value);
                interestedRef.get().then((value) => {
                      if (value.data != null)
                        {
                          if (value.data.keys.contains(widget.docRef))
                            {
                              Firestore.instance
                                  .runTransaction((Transaction tx) async {
                                DocumentSnapshot docSnapshot = await tx
                                    .get(eventRef.document(widget.docRef));
                                if (docSnapshot.exists) {
                                  await tx.update(
                                      eventRef.document(widget.docRef),
                                      <String, dynamic>{
                                        'interested':
                                            docSnapshot.data["interested"] - 1
                                      });
                                }
                              }),
                            },
                          interestedRef.delete(),
                          participantRef
                              .collection("participants")
                              .document(participateId)
                              .delete(),
                          setState(() {
                            interestedRef.get().then((value) {
                              interestedData = value.data;
                            });
                          })
                        }
                    });
              },
            ),
            title: new Text('Not Interested'),
          ),
        ],
      ),
    );
  }
}
