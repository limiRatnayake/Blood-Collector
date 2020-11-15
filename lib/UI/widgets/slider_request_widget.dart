import 'package:blood_collector/UI/pages/rootPages/donorSelectionCriteriaVIew.dart';
import 'package:blood_collector/UI/pages/rootPages/request_history.dart';
import 'package:blood_collector/UI/pages/rootPages/viewRequestDetails.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_participant_service.dart';
import 'package:blood_collector/services/request_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RequestIntroSliderWidget extends StatefulWidget {
  final String docRef;
  final String currentUser;

  RequestIntroSliderWidget({Key key, this.docRef, this.currentUser})
      : super(key: key);
  @override
  _CampaignIntroSliderWidgetState createState() =>
      _CampaignIntroSliderWidgetState();
}

class _CampaignIntroSliderWidgetState extends State<RequestIntroSliderWidget> {
  int age;
  String birthDate;
  DocumentReference interestedRef;
  DocumentReference requestedRef;
  CollectionReference eventRef;
  bool isInterested = false;
  bool availability;
  bool isRequestSend = false;
  bool requestStatus;
  bool _sendRequest = false;

//use DateFormat from intl package.
  String requestSentOn = DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now());

  Map<String, dynamic> interestedData;
  Map<String, dynamic> requestedData;

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
      // PageViewModel(
      //   image: Image.asset(
      //     "assets/slide_three.png",
      //   ),
      //   titleWidget: Column(
      //     children: [
      //       Text(
      //         "Are you ready to Donate ?",
      //         style: TextStyle(
      //             fontFamily: 'Roboto',
      //             fontWeight: FontWeight.bold,
      //             fontSize: 20.0),
      //       ),
      //       SizedBox(
      //         height: 15,
      //       ),
      //       RichText(
      //         text: TextSpan(
      //           text: "Request the patient details",
      //           style: TextStyle(color: Colors.black, fontSize: 16),
      //         ),
      //       ),
      //     ],
      //   ),
      //   bodyWidget: Padding(
      //     padding: const EdgeInsets.all(25),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         RaisedButton(
      //           color: Colors.orange[200],
      //           onPressed: () {
      //             _isRequestSend();

      //             requestedRef.get().then((value) => {
      //                   if (value.data != null)
      //                     {
      //                       print("like ref is nt null"),
      //                       requestedRef.delete(),
      //                       setState(() {
      //                         requestedRef.get().then((value) {
      //                           requestedData = value.data;
      //                         });
      //                       })
      //                     }
      //                   else
      //                     {
      //                       requestedRef.setData({
      //                         "docRef": widget.docRef,
      //                         "requestStatus": "sent",
      //                         "requestSentOn": requestSentOn,
      //                         "requesterId": widget.currentUser
      //                       }),
      //                       setState(() {
      //                         requestedRef.get().then((value) {
      //                           requestedData = value.data;
      //                         });
      //                       })
      //                     }
      //                 });
      //           },
      //           child: requestedData != null &&
      //                   requestedData.containsKey("requestStatus")
      //               ? Text(
      //                   "Request Sent",
      //                   style: TextStyle(
      //                       fontSize: 16, fontWeight: FontWeight.bold),
      //                 )
      //               : Text("Send request",
      //                   style: TextStyle(
      //                       fontSize: 16, fontWeight: FontWeight.bold)),
      //         ),
      //         ListTile(
      //           leading: Icon(Icons.info_outline),
      //           title: Text(
      //               "If the requester accept the request details will show on the 'Request List' page",
      //               style: TextStyle(fontSize: 12)),
      //         )
      //       ],
      //     ),
      //   ),
      //   decoration: PageDecoration(
      //     pageColor: Colors.orange[50],
      //     bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
      //   ),
      // ),
      PageViewModel(
        image: Image.asset(
          "assets/slide_four.png",
        ),
        titleWidget: Column(
          children: [
            Text(
              "Once you donate",
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            SizedBox(
              height: 15,
            ),
            RichText(
              text: TextSpan(
                text: "They will check whether you are a matching donor",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ),
        bodyWidget: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text:
                      "If you are a matching donor and you actually donated mark as you were donated ",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        decoration: PageDecoration(
          pageColor: Colors.red[100],
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

  void _isRequestSend() {
    setState(() {
      isRequestSend = !isRequestSend;
    });
  }

  @override
  void initState() {
    print(widget.currentUser);

    requestedRef = Firestore.instance
        .collection("events")
        .document(widget.docRef)
        .collection("requested")
        .document(widget.currentUser);
    super.initState();

    requestedRef.get().then((value) {
      requestedData = value.data;
    });
    eventRef = Firestore.instance.collection("events");
  }

  @override
  Widget build(BuildContext context) {
    final AuthServices _authService = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);
    final RequestAcceptenceService _reqAcceptService =
        Provider.of<RequestAcceptenceService>(context);
    final EventParticipantService _participantService =
        Provider.of<EventParticipantService>(context);
    FirebaseUser _user = Provider.of<AuthServices>(context).user;

    return Scaffold(
        body: FutureBuilder(
            future: _userService.requestUserDetails(_authService.user.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                UserModel data = UserModel.fromMap(snapshot.data.data);
                birthDate = data.birthDate;

                return IntroductionScreen(
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

                    if (availability == false) {
                      //can't donate

                      Alert(
                              context: context,
                              title: "Can't donate",
                              content: Text(
                                  "your donor criteria may be not acceptable"))
                          .show();
                    } else if (availability != false &&
                        (age > 18 && age < 55)) {
                      //can donate
                      Alert(
                          context: context,
                          type: AlertType.info,
                          title: "Would you like to donate blood!",
                          style: AlertStyle(
                              backgroundColor: Colors.white,
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
                                      color: Colors.white, fontSize: 16),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                            DialogButton(
                                width: 130,
                                child: Text(
                                  "Send a Request",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                onPressed: () async {
                                  String userName =
                                      data.firstName + " " + data.lastName;
                                  String response = await _participantService
                                      .addRequestEventParticipants(
                                          _user,
                                          widget.docRef,
                                          userName,
                                          "sent",
                                          requestSentOn,
                                          widget.currentUser,
                                          false);

                                  if (response != "Success") {
                                    AlertDialog(
                                      title:
                                          Text("Error updating your request!"),
                                      content: Text("Try again later."),
                                      actions: [
                                        FlatButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewRequestDetails()));
                                          },
                                        ),
                                      ],
                                    );
                                    requestedRef.delete();
                                  } else {
                                    // requestedRef.get().then((value) => {
                                    //       requestedRef.setData({
                                    //         "docRef": widget.docRef,
                                    //         "requestStatus": "sent",
                                    //         "requestSentOn": requestSentOn,
                                    //         "requesterId": widget.currentUser,
                                    //         "rejected": false
                                    //       }),
                                    //       setState(() {
                                    //         requestedRef.get().then((value) {
                                    //           requestedData = value.data;
                                    //         });
                                    //       })
                                    //     });
                                    // _reqAcceptService.addRequestDetails(
                                    //     widget.docRef,
                                    //     "sent",
                                    //     requestSentOn,
                                    //     widget.currentUser,
                                    //     false);
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
                  done: Text(
                    "Go test",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  globalBackgroundColor: Colors.white,
                  // showSkipButton: true,
                  // skip: const Text("Skip"),
                );
              }
            }));
  }
}
