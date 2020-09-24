import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:blood_collector/shared/decoration_constant.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SignUpSecondPage extends StatefulWidget {
  final String email;
  final String confirmPassword;
  final String uid;
  final String firstName;
  final String lastName;
  final String birthDate;
  final String gender;
  final String mobileNo;
  final String bloodGroup;
  final String address;
  final String userAddLat;
  final String userAddLng;
  final String proPicUrl;
  final int age;
  final bool disabled;

  SignUpSecondPage(
      {Key key,
      this.email,
      this.confirmPassword,
      this.uid,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.gender,
      this.mobileNo,
      this.bloodGroup,
      this.address,
      this.userAddLat,
      this.userAddLng,
      this.proPicUrl,
      this.age,
      this.disabled})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SignUpSecondPageState();
  }
}

class _SignUpSecondPageState extends State<SignUpSecondPage> {
  DateTime currentDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat("yyyy-MM-dd");
  List<String> answerType = ["Select a value", 'Yes', 'No'];

  String _errorMessage;
  bool _isLoading = false;
  bool _formValidate = false;
  String answer = "Select a value";

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
  bool lastDonationDateCheck = false;

  Widget _userPreviouslyDonatedOrNot() {
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
              value: answer,
              decoration: InputDecoration(enabledBorder: InputBorder.none),
              validator: validateDropdowns,
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

  Widget _ifYesHowManyTimes() {
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
              decoration:
                  inputDecoration.copyWith(hintText: "Enter How many times"),
              keyboardType: TextInputType.text,
              validator: validateHowManyTimes,
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

  Widget _dateOfLastDonation() {
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
              validator: dateTimeValidator,
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

  Widget _medicallyAdvised() {
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
              value: answer,
              decoration: InputDecoration(enabledBorder: InputBorder.none),
              validator: validateDropdowns,
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

  Widget _vaildIdentitiyCardCheck() {
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
              value: answer,
              decoration: InputDecoration(enabledBorder: InputBorder.none),
              validator: validateDropdowns,
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

  Widget _freeFromRiskBehaviour() {
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
              value: answer,
              decoration: InputDecoration(
                  hintText: 'Blood Type',
                  hintStyle: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Roboto",
                      color: Colors.black54),
                  enabledBorder: InputBorder.none),
              validator: validateDropdowns,
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

  Widget _freeFromSeriousCondition() {
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
              value: answer,
              decoration: InputDecoration(
                  hintText: 'Blood Type',
                  hintStyle: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Roboto",
                      color: Colors.black54),
                  enabledBorder: InputBorder.none),
              validator: validateDropdowns,
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

  Widget _travelAbroad() {
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
              value: answer,
              decoration: InputDecoration(
                  hintText: 'Blood Type',
                  hintStyle: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Roboto",
                      color: Colors.black54),
                  enabledBorder: InputBorder.none),
              validator: validateDropdowns,
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

  Widget _presentMedialTreatment() {
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
              value: answer,
              decoration: InputDecoration(enabledBorder: InputBorder.none),
              validator: validateDropdowns,
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

  Widget _undergoneSurgery() {
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
              value: answer,
              decoration: InputDecoration(enabledBorder: InputBorder.none),
              validator: validateDropdowns,
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
            print(differenceOfMonth);
          }
        });
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
        ),
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: ListView(children: <Widget>[
          //logo
          Center(
            child: Column(
              children: <Widget>[
                Container(
                  height: 180.0,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Center(
                          child: Image.asset("assets/logo_name.png"),
                        )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
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
                      _userPreviouslyDonatedOrNot(),
                      SizedBox(height: 10),
                      userPreviouslyDonatedOrNot == "Yes"
                          ? _ifYesHowManyTimes()
                          : SizedBox(),
                      SizedBox(height: 10),
                      userPreviouslyDonatedOrNot == "Yes"
                          ? _dateOfLastDonation()
                          : SizedBox(),
                      SizedBox(height: 10),
                      _medicallyAdvised(),
                      SizedBox(height: 10),
                      _vaildIdentitiyCardCheck(),
                      SizedBox(height: 10),
                      _freeFromRiskBehaviour(),
                      SizedBox(height: 10),
                      _freeFromSeriousCondition(),
                      SizedBox(height: 10),
                      _travelAbroad(),
                      SizedBox(height: 10),
                      _presentMedialTreatment(),
                      SizedBox(height: 10),
                      _undergoneSurgery(),
                      SizedBox(height: 20.0),
                      _errorMessage != null
                          ? Container(
                              padding: EdgeInsets.only(bottom: 10),
                              width: double.infinity,
                              child: Text(
                                _errorMessage,
                                style: TextStyle(color: Colors.redAccent),
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
                              margin: EdgeInsets.symmetric(horizontal: 30.0),
                              decoration: boxDecoration,
                              child: ButtonTheme(
                                child: RaisedButton(
                                  elevation: 0.0,
                                  child: Text("SIGNUP",
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
                                    if (userPreviouslyDonatedOrNot == "No" ||
                                        lastDonationDateCheck == true &&
                                            (widget.age > 18 &&
                                                widget.age < 55) &&
                                            medicallyAdvised == "No" &&
                                            vaildIdentitiyCardCheck == "Yes" &&
                                            freeFromRiskBehaviour == "Yes" &&
                                            freeFromSeriousCondition == "No" &&
                                            travelAbroad == "No" &&
                                            presentMedialTreatment == "No" &&
                                            undergoneSurgery == "No") {
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

                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        _errorMessage = "";
                                        _isLoading = true;
                                        // disabled = false;
                                      });
                                      String response =
                                          await _authService.createUser(
                                              widget.email,
                                              widget.confirmPassword,
                                              widget.uid,
                                              widget.firstName,
                                              widget.lastName,
                                              widget.birthDate,
                                              widget.gender,
                                              widget.mobileNo,
                                              widget.bloodGroup,
                                              widget.address,
                                              widget.userAddLat,
                                              widget.userAddLng,
                                              widget.proPicUrl,
                                              widget.disabled,
                                              userPreviouslyDonatedOrNot,
                                              ifYesHowManyTimes,
                                              dateOfLastDonation,
                                              medicallyAdvised,
                                              vaildIdentitiyCardCheck,
                                              freeFromRiskBehaviour,
                                              freeFromSeriousCondition,
                                              travelAbroad,
                                              presentMedialTreatment,
                                              undergoneSurgery,
                                              availability,
                                              lastDonationDateCheck,
                                              widget.age);
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
                                                "Your are Successfully signup!",
                                            desc:
                                                "Please Verify Your Email Before Sign in",
                                            style: AlertStyle(
                                                isCloseButton: false,
                                                // backgroundColor: Colors.black,
                                                descStyle: TextStyle(
                                                    fontWeight: FontWeight
                                                        .bold),
                                                alertBorder:
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        side: BorderSide(
                                                            color:
                                                                Colors.white)),
                                                titleStyle: TextStyle(
                                                    color: Colors.blueAccent)),
                                            buttons: [
                                              DialogButton(
                                                  width: 120,
                                                  child: Text(
                                                    "ok",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  onPressed: () {
                                                    Navigator
                                                        .pushReplacementNamed(
                                                      context,
                                                      AppConstants.SIGN_IN,
                                                    );
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
                                  },
                                ),
                              ),
                            ),
                      Container(
                          child: Center(
                              child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "If you already have an account !  ",
                            style:
                                TextStyle(fontSize: 15.0, fontFamily: "Roboto"),
                          ),
                          FlatButton.icon(
                            icon: Icon(Icons.person),
                            label: Text('Sign In'),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppConstants.SIGN_IN,
                              );
                            },
                          )
                        ],
                      )))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  String validateDropdowns(String value) {
    if (value == "Select a value") {
      return 'Please select a value';
    }
    return null;
  }

  String validateHowManyTimes(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(pattern);
    if (userPreviouslyDonatedOrNot == "Yes") {
      if (value.isEmpty) {
        return "Ths feild is Required";
      } else if (!regExp.hasMatch(value)) {
        return "This must be numeric vaue";
      }
    }
    return null;
  }

  String dateTimeValidator(DateTime dateTime) {
    if (userPreviouslyDonatedOrNot == "Yes") {
      if (dateTime == null) {
        return "Ths feild is Required";
      }
    }
    return null;
  }
}
