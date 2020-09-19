import 'package:blood_collector/UI/pages/rootPages/settingView.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:blood_collector/shared/decoration_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DonorSelectionCriteriaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DonorSelectionCriteriaPageState();
  }
}

class _DonorSelectionCriteriaPageState
    extends State<DonorSelectionCriteriaPage> {
  DateTime currentDate = DateTime.now();

  final _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat("yyyy-MM-dd");
  List<String> answerType = ['Yes', 'No'];

  String _errorMessage;
  bool _isLoading = false;
  bool _formValidate = false;

  String userPreviouslyDonatedOrNot;
  String ifYesHowManyTimes;
  String dateOfLastDonation;
  String medicallyAdvised;
  String vaildIdentitiyCardCheck;
  String freeFromRiskBehaviour;
  String freeFromSeriousCondition;
  String travelAbroad;
  String presentMedialTreatment;
  String undergoneSurgery;
  bool availability;
  bool lastDonationDateCheck;

  Widget _userPreviouslyDonatedOrNot(String value) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.78,
          child: Text(
            "Have you donated blood previously?",
            style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
          ),
        ),
        Container(
          width: double.infinity,
          height: 66,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: boxDecoration,
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: DropdownButtonFormField(
              value: value,
              decoration: InputDecoration(enabledBorder: InputBorder.none),
              // validator: validateBloodGroup,
              items: answerType.map((answerType) {
                return DropdownMenuItem(
                  value: answerType,
                  child: Text(answerType),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  userPreviouslyDonatedOrNot = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _ifYesHowManyTimes(String value) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.78,
          child: Text(
            "If Yes, How many times?",
            style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
          ),
        ),
        Container(
          width: double.infinity,
          height: 58,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: boxDecoration,
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: TextFormField(
              initialValue: value,
              decoration:
                  inputDecoration.copyWith(hintText: "Enter How many times"),
              keyboardType: TextInputType.text,
              // validator: validateName,
              onChanged: (value) {
                setState(() {
                  ifYesHowManyTimes = value;
                });
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _dateOfLastDonation(String date) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.78,
          child: Text(
            "Date of Last Donation?",
            style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
          ),
        ),
        Container(
          width: double.infinity,
          height: 58,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: boxDecoration,
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 25, right: 16),
            child: DateTimeField(
              format: dateFormat,
              initialValue: dateFormat.parse(date),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  ),
                  hintText: "Last Donation Date"),
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    // from todays date subtract the pass dates so that it will show only future days
                    firstDate: DateTime(1930),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
              // validator: dateTimeValidator,
              onChanged: (value) {
                setState(() {
                  dateOfLastDonation = DateFormat('yyyy-MM-dd').format(value);
                  // print(pickUpStartDate);
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _medicallyAdvised(String value) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.78,
          child: Text(
            "Have you ever been medically advised not to donate blood?",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Container(
          width: double.infinity,
          height: 66,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: boxDecoration,
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: DropdownButtonFormField(
              value: value,
              decoration: InputDecoration(enabledBorder: InputBorder.none),
              // validator: validateBloodGroup,
              items: answerType.map((answerType) {
                return DropdownMenuItem(
                  value: answerType,
                  child: Text(answerType),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  medicallyAdvised = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _vaildIdentitiyCardCheck(String value) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.78,
          child: Text(
            "Do you have a valid identity card?",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Container(
          width: double.infinity,
          height: 66,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: boxDecoration,
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: DropdownButtonFormField(
              value: value,
              decoration: InputDecoration(enabledBorder: InputBorder.none),
              // validator: validateBloodGroup,
              items: answerType.map((answerType) {
                return DropdownMenuItem(
                  value: answerType,
                  child: Text(answerType),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  vaildIdentitiyCardCheck = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _freeFromRiskBehaviour(String value) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.78,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you free from Risk Behaviour?",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "(Homosexuals,Sex workers and their clients,Drug addicts,Engaging in sex with any of the above,Having more than one sexual partner)",
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          height: 66,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: boxDecoration,
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: DropdownButtonFormField(
              value: value,
              decoration: InputDecoration(
                  hintText: 'Blood Type',
                  hintStyle: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Roboto",
                      color: Colors.black54),
                  enabledBorder: InputBorder.none),
              // validator: validateBloodGroup,
              items: answerType.map((answerType) {
                return DropdownMenuItem(
                  value: answerType,
                  child: Text(answerType),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  freeFromRiskBehaviour = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _freeFromSeriousCondition(String value) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.78,
          child: Text(
            "Are you pregnant or breast feeding at present? Have you had a child birth or abortion during 12 months?",
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Container(
          width: double.infinity,
          height: 66,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: boxDecoration,
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: DropdownButtonFormField(
              value: value,
              decoration: InputDecoration(
                  hintText: 'Blood Type',
                  hintStyle: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Roboto",
                      color: Colors.black54),
                  enabledBorder: InputBorder.none),
              // validator: validateBloodGroup,
              items: answerType.map((answerType) {
                return DropdownMenuItem(
                  value: answerType,
                  child: Text(answerType),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  freeFromSeriousCondition = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _travelAbroad(String value) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.78,
          child: Text(
            "Have you/ your partner travelled abroad?",
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Container(
          width: double.infinity,
          height: 66,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: boxDecoration,
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: DropdownButtonFormField(
              value: value,
              decoration: InputDecoration(
                  hintText: 'Blood Type',
                  hintStyle: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Roboto",
                      color: Colors.black54),
                  enabledBorder: InputBorder.none),
              // validator: validateBloodGroup,
              items: answerType.map((answerType) {
                return DropdownMenuItem(
                  value: answerType,
                  child: Text(answerType),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  travelAbroad = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _presentMedialTreatment(String value) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.78,
          child: Text(
            "Are you taking any medication/treatment, presently?",
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Container(
          width: double.infinity,
          height: 66,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: boxDecoration,
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: DropdownButtonFormField(
              value: value,
              decoration: InputDecoration(enabledBorder: InputBorder.none),
              // validator: validateBloodGroup,
              items: answerType.map((answerType) {
                return DropdownMenuItem(
                  value: answerType,
                  child: Text(answerType),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  presentMedialTreatment = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _undergoneSurgery(String value) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.78,
          child: Text(
            "Have you undergone any surgery?",
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Container(
          width: double.infinity,
          height: 66,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: boxDecoration,
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: DropdownButtonFormField(
              value: value,
              decoration: InputDecoration(enabledBorder: InputBorder.none),
              // validator: validateBloodGroup,
              items: answerType.map((answerType) {
                return DropdownMenuItem(
                  value: answerType,
                  child: Text(answerType),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  undergoneSurgery = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthServices _authService = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);
    void availabilityCalculate() {
      if (dateOfLastDonation != null) {
        var lastDonatedMonth = DateTime.parse(dateOfLastDonation);
        var currentMonth = DateTime.now();

        setState(() {
          var differenceInDays =
              currentMonth.difference(lastDonatedMonth).inDays;
          var differenceOfMonth = (differenceInDays) ~/ 30;

          if (differenceOfMonth > 4) {
            lastDonationDateCheck = true;
          } else {
            lastDonationDateCheck = false;
          }
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          actionsIconTheme: null,
          title: Text("Your Selection Criteria"),
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder<DocumentSnapshot>(
            future: _userService.requestUserDetails(_authService.user.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                UserModel data = UserModel.fromMap(snapshot.data.data);
                return ListView(children: <Widget>[
                  Container(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Form(
                          key: _formKey,
                          autovalidate: _formValidate,
                          child: Column(
                            children: <Widget>[
                              _userPreviouslyDonatedOrNot(
                                  data.userPreviouslyDonatedOrNot),
                              SizedBox(height: 10),
                              _ifYesHowManyTimes(data.ifYesHowManyTimes),
                              SizedBox(height: 10),
                              _dateOfLastDonation(data.dateOfLastDonation),
                              SizedBox(height: 10),
                              _medicallyAdvised(data.medicallyAdvised),
                              SizedBox(height: 10),
                              _vaildIdentitiyCardCheck(
                                  data.vaildIdentitiyCardCheck),
                              SizedBox(height: 10),
                              _freeFromRiskBehaviour(
                                  data.freeFromRiskBehaviour),
                              SizedBox(height: 10),
                              _freeFromSeriousCondition(
                                  data.freeFromSeriousCondition),
                              SizedBox(height: 10),
                              _travelAbroad(data.travelAbroad),
                              SizedBox(height: 10),
                              _presentMedialTreatment(
                                  data.presentMedialTreatment),
                              SizedBox(height: 10),
                              _undergoneSurgery(data.undergoneSurgery),
                              SizedBox(height: 20.0),
                              _errorMessage != null
                                  ? Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      width: double.infinity,
                                      child: Text(
                                        _errorMessage,
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : Container(),
                              _isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      height: 58,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      decoration: boxDecoration,
                                      child: ButtonTheme(
                                        child: RaisedButton(
                                          elevation: 0.0,
                                          child: Text("UPDATE CHANGES",
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 18.0,
                                                  color: Colors.black)),
                                          textColor: Colors.black,
                                          color: Colors.red.withOpacity(0.9),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.5)),
                                          onPressed: () async {
                                            availabilityCalculate();
                                            if ((userPreviouslyDonatedOrNot =="No" ||
                                                    lastDonationDateCheck ==true) 
                                                    && (data.age > 18 
                                                    && data.age < 55) 
                                                    ) {
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
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() {
                                                _errorMessage = "";
                                                _isLoading = true;
                                              });
                                   
                                              String response = await _userService.updateDonorSelectionCriteria(
                                                  _authService.user.uid,
                                                  userPreviouslyDonatedOrNot ??
                                                      data
                                                          .userPreviouslyDonatedOrNot,
                                                  ifYesHowManyTimes ??
                                                      data.ifYesHowManyTimes,
                                                  dateOfLastDonation ??
                                                      data.dateOfLastDonation,
                                                  medicallyAdvised ??
                                                      data.medicallyAdvised,
                                                  vaildIdentitiyCardCheck ??
                                                      data
                                                          .vaildIdentitiyCardCheck,
                                                  freeFromRiskBehaviour ??
                                                      data
                                                          .freeFromRiskBehaviour,
                                                  freeFromSeriousCondition ??
                                                      data
                                                          .freeFromSeriousCondition,
                                                  travelAbroad ??
                                                      data.travelAbroad,
                                                  presentMedialTreatment ??
                                                      data
                                                          .presentMedialTreatment,
                                                  undergoneSurgery ??
                                                      data.undergoneSurgery,
                                                  availability ,
                                                  lastDonationDateCheck ??
                                                      data.lastDonationDateCheck);
                                              if (response != "Success") {
                                                setState(() {
                                                  _isLoading = false;
                                                  _errorMessage = response;
                                                });
                                              } else {
                                                Alert(
                                                    context: context,
                                                    type: AlertType.success,
                                                    title:
                                                        "Your data is Successfully updated!",
                                                    style: AlertStyle(
                                                        backgroundColor:
                                                            Colors.black,
                                                        alertBorder:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .white)),
                                                        titleStyle: TextStyle(
                                                            color: Colors
                                                                .blueAccent)),
                                                    buttons: [
                                                      DialogButton(
                                                          width: 120,
                                                          child: Text(
                                                            "ok",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            SettingView()));
                                                          })
                                                    ]).show();
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                _formValidate = true;
                                              });
                                            }
                                            //  print(gapBetweenDonation);
                                            // print(widget.email);
                                            // print(widget.confirmPassword);
                                            // print(widget.uid);
                                            // print(widget.firstName);
                                            // print(widget.lastName);
                                            // print(widget.birthDate);
                                            // print(widget.gender);
                                            // print(widget.mobileNo);
                                            // print(widget.bloodGroup);
                                            // print(widget.address);
                                            // print(widget.userAddLat);
                                            // print(widget.userAddLng);
                                            // print(widget.proPicUrl);
                                            // print(widget.disabled);
                                            // print(userPreviouslyDonatedOrNot);
                                            // print(ifYesHowManyTimes);
                                            // print(dateOfLastDonation);
                                            // print(medicallyAdvised);
                                            // print(vaildIdentitiyCardCheck);
                                            // print(freeFromRiskBehaviour);
                                            // print(freeFromSeriousCondition);
                                            // print(travelAbroad);
                                            // print(widget.age);

                                            // if (_formKey.currentState.validate()) {
                                            //   setState(() {
                                            //     _errorMessage = "";
                                            //     _isLoading = true;
                                            //     // disabled = false;
                                            //   });
                                            //   String response =
                                            //       await _authService.createUser(
                                            //           widget.email,
                                            //           widget.confirmPassword,
                                            //           widget.uid,
                                            //           widget.firstName,
                                            //           widget.lastName,
                                            //           widget.birthDate,
                                            //           widget.gender,
                                            //           widget.mobileNo,
                                            //           widget.bloodGroup,
                                            //           widget.address,
                                            //           widget.userAddLat,
                                            //           widget.userAddLng,
                                            //           widget.proPicUrl,
                                            //           widget.disabled,
                                            //           userPreviouslyDonatedOrNot,
                                            //           ifYesHowManyTimes,
                                            //           dateOfLastDonation,
                                            //           medicallyAdvised,
                                            //           vaildIdentitiyCardCheck,
                                            //           freeFromRiskBehaviour,
                                            //           freeFromSeriousCondition,
                                            //           travelAbroad,
                                            //           presentMedialTreatment,
                                            //           undergoneSurgery,
                                            //           availability,
                                            //           lastDonationDateCheck);
                                            //   if (response != "Success") {
                                            //     setState(() {
                                            //       _isLoading = false;
                                            //       _errorMessage = response;
                                            //     });
                                            //   } else {
                                            //     Alert(
                                            //         context: context,
                                            //         type: AlertType.success,
                                            //         title:
                                            //             "Your are Successfully signup!",
                                            //         desc:
                                            //             "Please Verify Your Email Before Sign in",
                                            //         style: AlertStyle(
                                            //             isCloseButton: false,
                                            //             // backgroundColor: Colors.black,
                                            //             descStyle: TextStyle(
                                            //                 fontWeight: FontWeight
                                            //                     .bold),
                                            //             alertBorder:
                                            //                 RoundedRectangleBorder(
                                            //                     borderRadius:
                                            //                         BorderRadius
                                            //                             .circular(5),
                                            //                     side: BorderSide(
                                            //                         color:
                                            //                             Colors.white)),
                                            //             titleStyle: TextStyle(
                                            //                 color: Colors.blueAccent)),
                                            //         buttons: [
                                            //           DialogButton(
                                            //               width: 120,
                                            //               child: Text(
                                            //                 "ok",
                                            //                 style: TextStyle(
                                            //                     color: Colors.white,
                                            //                     fontSize: 20),
                                            //               ),
                                            //               onPressed: () {
                                            //                 Navigator
                                            //                     .pushReplacementNamed(
                                            //                   context,
                                            //                   AppConstants.SIGN_IN,
                                            //                 );
                                            //               })
                                            //         ]).show();
                                            //     setState(() {
                                            //       _isLoading = false;
                                            //     });
                                            //   }
                                            // } else {
                                            //   setState(() {
                                            //     _formValidate = true;
                                            //   });
                                            // }
                                          },
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]);
              }
            }));
  }
}
