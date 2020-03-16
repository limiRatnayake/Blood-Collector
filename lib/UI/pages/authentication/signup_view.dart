import 'dart:async';

import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:blood_collector/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  DateTime currentDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  String firstName = '';
  String lastName = '';
  String gender = "";
  String birthDate = "";
  String bloodGroup = '';
  String mobileNo = '';
  String city = '';
  String address = '';
  String email = '';
  String password = '';

  String error = '';
  String uid = '';
  int _radioValue = 1;
  bool _isLoading = false;
  // String dateOfBirth = "Select BirthDate";
  String _bloodGroup = 'Select Blood Type';
  List<String> bloodGroupType = [
    'Select Blood Type',
    'A+',
    'O+',
    'B+',
    'AB+',
    'A-',
    'O-',
    'B-',
    'AB-'
  ];

  void something(String value) {
    setState(() {
      _bloodGroup = value;
    });
  }

  selectDate(BuildContext context, DateTime initialDateTime,
      {DateTime lastDate}) async {
    Completer completer = Completer();

    showDatePicker(
            context: context,
            initialDate: currentDate,
            firstDate: DateTime(1965),
            lastDate: lastDate == null
                ? DateTime(initialDateTime.year + 10)
                : lastDate)
        .then((temp) {
      if (temp == null) return null;
      completer.complete(temp);
      setState(() {});
    });

    return completer.future;
  }

  Widget _firstNameTextField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: inputDecoration.copyWith(hintText: "First Name"),
          keyboardType: TextInputType.text,
          validator: (value) => value.isEmpty ? 'Name should be filled' : null,
          onChanged: (val) {
            setState(() {
              firstName = val;
            });
          },
        ),
      ),
    );
  }

  Widget _lastNameTextField() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: inputDecoration.copyWith(hintText: "Last Name"),
          keyboardType: TextInputType.text,
          validator: (value) => value.isEmpty ? 'Name should be filled' : null,
          onChanged: (val) {
            setState(() {
              lastName = val;
            });
          },
        ),
      ),
    );
  }

  Widget _genderRadioButton() {
    return Container(
      width: 370.0,
      height: 58,
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Gender:",
              style: TextStyle(
                  fontSize: 16, fontFamily: "Roboto", color: Colors.black54),
            ),
            Expanded(
              child: SizedBox(
                child: RadioListTile<int>(
                  title: Text("Male"),
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: (val) {
                    setState(() {
                      _radioValue = val;
                      switch (val) {
                        case 1:
                          String value = "Male";
                          gender = value;
                      }
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                child: RadioListTile<int>(
                  title: Text("Female"),
                  value: 2,
                  groupValue: _radioValue,
                  onChanged: (val) {
                    setState(() {
                      _radioValue = val;
                      switch (val) {
                        case 2:
                          String value = "Female";
                          gender = value;
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _birthDateSelector() {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 30.0),
        decoration: boxDecoration,
        child: Padding(
          padding: const EdgeInsets.only(top: 4, left: 25, right: 16),
          child: Row(
            children: <Widget>[
              Text("$birthDate",
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Roboto", color: Colors.black)),
              SizedBox(width: 155.0),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  DateTime birthDate = await selectDate(
                      context, DateTime.now(),
                      lastDate: DateTime.now());
                  final df = new DateFormat('dd-MMM-yyyy');
                  this.birthDate = df.format(birthDate);
                  setState(() {
                    birthDate = birthDate;
                  });
                },
              )
            ],
          ),
        ));
  }

  Widget _bloodGroupTextField() {
    return Container(
      width: double.infinity,
      height: 66,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: DropdownButtonFormField(
          value: _bloodGroup,
          decoration: InputDecoration(
              hintText: 'Blood Type',
              hintStyle: TextStyle(
                  fontSize: 16.0, fontFamily: "Roboto", color: Colors.black54),
              enabledBorder: InputBorder.none),
          validator: (value) => value == "Select Blood Type"
              ? 'Blood Type should be selected'
              : null,
          onChanged: (value) {
            setState(() {
              bloodGroup = value;
            });
            something(value);
          },
          items: bloodGroupType.map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _mobileNoField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: inputDecoration.copyWith(hintText: "Mobile No:"),
          keyboardType: TextInputType.phone,
          validator: (value) => value.isEmpty || (value.length != 10)
              ? 'Mobile No should be filled'
              : null,
          onChanged: (val) {
            setState(() {
              mobileNo = val;
            });
          },
        ),
      ),
    );
  }

  Widget _cityField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: InputDecoration(
              hintText: "City",
              hintStyle: TextStyle(
                fontSize: 16.0,
                fontFamily: "Roboto",
              ),
              enabledBorder: InputBorder.none),
          keyboardType: TextInputType.text,
          validator: (value) => value.isEmpty ? 'City should be filled' : null,
          onChanged: (val) {
            setState(() {
              city = val;
            });
          },
        ),
      ),
    );
  }

  Widget _postalAddressField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: inputDecoration.copyWith(hintText: "Postal Address"),
          keyboardType: TextInputType.multiline,
          validator: (value) =>
              value.isEmpty ? 'Address should be filled' : null,
          onChanged: (val) {
            setState(() {
              address = val;
            });
          },
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: inputDecoration.copyWith(hintText: "Email Address"),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value.isEmpty ||
                  !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                      .hasMatch(value)
              ? 'Email cannot be blank'
              : null,
          onChanged: (val) {
            setState(() {
              email = val;
            });
          },
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: inputDecoration.copyWith(hintText: "Password"),
          keyboardType: TextInputType.visiblePassword,
          validator: (value) => value.isEmpty || value.length < 6
              ? 'Password cannot be blank'
              : null,
          obscureText: true,
          onChanged: (val) {
            setState(() {
              password = val;
            });
          },
        ),
      ),
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
                  child: Column(
                    children: <Widget>[
                      _firstNameTextField(),
                      SizedBox(height: 20.0),
                      _lastNameTextField(),
                      SizedBox(height: 20.0),
                      _genderRadioButton(),
                      SizedBox(height: 20.0),
                      _birthDateSelector(),
                      SizedBox(height: 20.0),
                      _bloodGroupTextField(),
                      SizedBox(height: 20.0),
                      _mobileNoField(),
                      SizedBox(height: 20.0),
                      _cityField(),
                      SizedBox(height: 20.0),
                      _postalAddressField(),
                      SizedBox(height: 20.0),
                      _emailTextField(),
                      SizedBox(height: 20.0),
                      _passwordField(),
                      SizedBox(height: 20.0),
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
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      _authService
                                          .signupWithEmailAndPassword(
                                              email,
                                              password,
                                              uid,
                                              firstName,
                                              lastName,
                                              gender,
                                              birthDate,
                                              mobileNo,
                                              bloodGroup,
                                              city,
                                              address)
                                          .then(
                                        (FirebaseUser user) {
                                          setState(() => _isLoading = false);
                                          Navigator.pushReplacementNamed(
                                            context,
                                            AppConstants.SIGN_IN,
                                          );
                                        },
                                      ).catchError(
                                        (e) {
                                          setState(() => _isLoading = false);
                                          print(e);
                                        },
                                      );
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
}

//function that calculate age
// calculateAge(DateTime birthDate) {
//   DateTime currentDate = DateTime.now();
//   int age = currentDate.year - birthDate.year;
//   int month1 = currentDate.month;
//   int month2 = birthDate.month;
//   if (month2 > month1) {
//     age--;
//     print("month $age");
//   } else if (month1 == month2) {
//     int day1 = currentDate.day;
//     int day2 = birthDate.day;
//     if (day2 > day1) {
//       age--;
//       print(" helo $age");
//     }
//     print("correct $age");
//   }
//   return age;
// }
