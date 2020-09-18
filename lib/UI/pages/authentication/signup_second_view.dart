import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:blood_collector/shared/decoration_constant.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

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
  String _errorMessage;
  bool _isLoading = false;
  bool _formValidate = false;
  String answer = "Yes";

  List<String> answerType = ['Yes', 'No'];

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
                setState(() {});
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
              // validator: validateName,
              onChanged: (val) {
                setState(() {});
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
              // validator: dateTimeValidator,
              onChanged: (value) {
                setState(() {
                  // pickUpStartDate = DateFormat('yyyy-MM-dd').format(value);
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
                setState(() {});
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
                setState(() {});
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
          child: Row(
            children: [
              Text(
                "Are you free from Risk Behaviour?",
                style: TextStyle(fontSize: 16),
              ),
              IconButton(
                  icon: Icon(Icons.info), tooltip: 'Hello', onPressed: () {})
            ],
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
              // validator: validateBloodGroup,
              items: answerType.map((answerType) {
                return DropdownMenuItem(
                  value: answerType,
                  child: Text(answerType),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {});
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
              // validator: validateBloodGroup,
              items: answerType.map((answerType) {
                return DropdownMenuItem(
                  value: answerType,
                  child: Text(answerType),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {});
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
              // validator: validateBloodGroup,
              items: answerType.map((answerType) {
                return DropdownMenuItem(
                  value: answerType,
                  child: Text(answerType),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {});
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
    return SafeArea(
      child: Scaffold(
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
                      _ifYesHowManyTimes(),
                      SizedBox(height: 10),
                      _dateOfLastDonation(),
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
                                  child: Text("CONTINUE",
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
                                    Navigator.pushReplacementNamed(
                                        context, AppConstants.SIGN_IN);
                                    // if (_formKey.currentState.validate()) {
                                    //   setState(() {
                                    //     _errorMessage = "";
                                    //     _isLoading = true;
                                    //     disabled = false;
                                    //   });
                                    //   String response =
                                    //       await _authService.createUser(
                                    //           email,
                                    //           confirmPassword,
                                    //           uid,
                                    //           firstName,
                                    //           lastName,
                                    //           birthDate,
                                    //           gender,
                                    //           mobileNo,
                                    //           bloodGroup,
                                    //           address,
                                    //           userAddLat,
                                    //           userAddLng,
                                    //           proPicUrl,
                                    //           disabled);
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
}
