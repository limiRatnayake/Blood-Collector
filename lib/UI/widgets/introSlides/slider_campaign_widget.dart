//pages
import 'package:blood_collector/UI/pages/rootPages/userProfileSetting/donorSelectionCriteriaVIew.dart';
import 'package:blood_collector/UI/pages/rootPages/requestHistoryList/request_history.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_participant_service.dart';
import 'package:blood_collector/services/user_service.dart';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CampaignIntroSliderWidget extends StatefulWidget {
  final String docRef;
  final String currentUser;

  CampaignIntroSliderWidget({Key key, this.docRef, this.currentUser})
      : super(key: key);
  @override
  _CampaignIntroSliderWidgetState createState() =>
      _CampaignIntroSliderWidgetState();
}

class _CampaignIntroSliderWidgetState extends State<CampaignIntroSliderWidget> {
  int age;
  String birthDate;
  DocumentReference interestedRef;
  CollectionReference eventRef;
  bool isInterested = false;
  bool availability;
  bool _isLoading = false;

  Map<String, dynamic> interestedData;
  //craete a list of slides
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: Image.asset(
          "assets/slide_one.png",
        ),
        titleWidget: Text(
          "Donor Selection Criteria",
          style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 20.0),
        ),

        bodyWidget: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: '• Age above 18 years and below 60 years.',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              RichText(
                text: TextSpan(
                  text:
                      '• If previously donated, at least 4 months should be elapsed since the date of previous donation',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              RichText(
                text: TextSpan(
                  text:
                      '• Hemoglobin level should be more than 12g/dL. (this blood test is done prior to each blood donation)',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              RichText(
                text: TextSpan(
                  text:
                      '• Free from any serious disease condition or pregnancy.',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              RichText(
                text: TextSpan(
                  text:
                      '• Should have a valid identity card or any other document to prove the identity.',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '• Free from "Risk Behaviours".',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(text: 'Free from "Risk Behaviours".'),
                  ],
                ),
              ),
            ],
          ),
        ),
        // body: "" ,
        decoration: PageDecoration(
          pageColor: Colors.red[50],
        ),
      ),
      PageViewModel(
          image: Image.asset(
            "assets/slide_two.png",
          ),
          titleWidget: Text(
            "Update Your Information",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          body: "It will help to give a better service",
          decoration: PageDecoration(
            pageColor: Colors.blue[50],
          ),
          footer: RaisedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DonorSelectionCriteriaPage()));
            },
            icon: Icon(
              Icons.edit,
            ),
            label: Text("Update"),
            color: Colors.blue.withOpacity(0.5),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          )),
      PageViewModel(
        image: Image.asset(
          "assets/slide_three.png",
        ),
        titleWidget: Text(
          "Are you ready to Donate ?",
          style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 25.0),
        ),
        body: "Let's Go!",
        decoration: PageDecoration(
          pageColor: Colors.orange[50],
          bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
        ),
      ),
    ];
  }

  void calculateAge() {
    var selectedYear = DateTime.parse(birthDate);
    print(selectedYear);
    var currentYear = DateTime.now().year;
    print(selectedYear);
    setState(() {
      age = (currentYear - selectedYear.year).toInt();
      print(age);
    });
  }

  @override
  void initState() {
    print(widget.currentUser);
    interestedRef = FirebaseFirestore.instance
        .collection("events")
        .doc(widget.docRef)
        .collection("interested")
        .doc(widget.currentUser);

    super.initState();
    interestedRef.get().then((value) {
      interestedData = value.data();
    });
    eventRef = FirebaseFirestore.instance.collection("events");
  }

  @override
  Widget build(BuildContext context) {
    final AuthServices _authService = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);
    final EventParticipantService _participantService =
        Provider.of<EventParticipantService>(context);
    User _user = Provider.of<AuthServices>(context).user;

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
          future: _userService.requestUserDetails(_authService.user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              UserModel data = UserModel.fromMap(snapshot.data.data());
              birthDate = data.birthDate;

              return IntroductionScreen(
                done: Text(
                  "Donate",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                globalBackgroundColor: Colors.white,
                pages: getPages(),
                onDone: () {
                  calculateAge();
                  print(age);
                  if ((data.userPreviouslyDonatedOrNot == "No" ||
                          data.lastDonationDateCheck == true) &&
                      data.medicallyAdvised == "No" &&
                      data.vaildIdentitiyCardCheck == "Yes" &&
                      data.freeFromRiskBehaviour == "Yes" &&
                      data.freeFromSeriousCondition == "No" &&
                      data.travelAbroad == "No" &&
                      data.presentMedialTreatment == "No" &&
                      data.undergoneSurgery == "No") {
                    setState(() {
                      availability = true;
                      print(availability);
                    });
                  } else {
                    setState(() {
                      availability = false;
                      print(availability);
                    });
                  }
                  print(availability);

                  if (availability == false || age < 18 || age > 55) {
                    Alert(
                      context: context,
                      title: "Can't donate",
                    ).show();
                  } else if (availability != false && (age > 18 && age < 55)) {
                    //can donate
                    Alert(
                        context: context,
                        type: AlertType.info,
                        title: "Would you like to donate blood!",
                        style: AlertStyle(
                            backgroundColor: Colors.black,
                            alertBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: Colors.white)),
                            titleStyle: TextStyle(color: Colors.blueAccent)),
                        buttons: [
                          DialogButton(
                              width: 120,
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          DialogButton(
                              width: 120,
                              child: Text(
                                "Yes, I want to",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              onPressed: () async {
                                String userName =
                                    data.firstName + " " + data.lastName;
                                String response =
                                    await _participantService.addParticipants(
                                        _user,
                                        widget.docRef,
                                        userName,
                                        data.bloodGroup);

                                await FirebaseFirestore.instance
                                    .runTransaction((tx) async {
                                  DocumentSnapshot docSnapshot =
                                      await tx.get(eventRef.doc(widget.docRef));
                                  if (docSnapshot.exists) {
                                    int newFollowerCount = docSnapshot
                                            .data()['totalParticipants'] +
                                        1;
                                    // Perform an update on the document
                                    tx.update(eventRef.doc(widget.docRef), {
                                      'totalParticipants': newFollowerCount
                                    });
                                  }
                                });
                                if (response != "Success") {
                                  final snackBar = SnackBar(
                                    content: Text('Error! Try again later.',
                                        style:
                                            TextStyle(color: Colors.blueGrey)),
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);
                                  Navigator.pop(context);
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RequestHistory()));
                                }
                              })
                        ]).show();
                  }
                },

                // showSkipButton: true,
                // skip: const Text("Skip"),
              );
            }
          }),
    ));
  }
}
