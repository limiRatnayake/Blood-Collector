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
  String _radioItemHolder = "Male";
  int _radioValue = 1;
  bool _isLoading = false;
  String _bloodGroup = 'Select Blood Type';

  TextEditingController _birthDate = TextEditingController();
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

  List<GenderList> radioButtonList =[
    GenderList(index: 1, title: "Male"),
    GenderList(index: 2, title: "Female")
  ];

  void something(String value) {
    setState(() {
      _bloodGroup = value;
    });
  }

@override
initState(){
  setState(() {
      gender = _radioItemHolder;
    });
    super.initState();
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
      // height: 58,
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
                child: Column(children: radioButtonList.map( (data) =>
                RadioListTile(
                  title: Text("${data.title}"),
                  value: data.index,
                  groupValue: _radioValue,
                  onChanged: (val) {
                    setState(() {
                      _radioItemHolder = data.title;
                      _radioValue = data.index;
                      print(_radioItemHolder);
                    gender = _radioItemHolder;
                    });
                   
                  }
                )).toList())
              ),
            ),
            // Expanded(
            //   child: SizedBox(
            //     child: RadioListTile<int>(
            //       title: Text("Male"),
            //       value: 1,
            //       groupValue: _radioValue,
            //       onChanged: (int i) => setState(() {
            //         _radioValue = i;
            //         print(i);
            //         String value = "Gender";
            //         gender = value;
            //         print(value);
            //       }),
            //     ),
            //   ),
            // ),
            // Expanded(
            //   child: SizedBox(
            //     child: RadioListTile<int>(
            //       title: Text("Female"),
            //       value: 2,
            //       groupValue: _radioValue,
            //       onChanged: (int i) => setState(() {
            //         _radioValue = i;
            //         print(i);
            //         String value = "Female";
            //         gender = value;
            //         print(value);
            //       }),
            //     ),
            //   ),
            // ),
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
        child: TextFormField(
          controller: _birthDate,
          decoration: inputDecoration.copyWith(
              hintText: "Date Of Birth",
              suffixIcon: Icon(
                Icons.calendar_today,
                color: Colors.black,
              )),
          // keyboardType: TextInputType.datetime,
          validator: (value) => value.isEmpty ? 'Name should be filled' : null,

          onTap: () async {
            _selectBDate(context, _birthDate);
          },
        ),
      ),
    );
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
                                              birthDate,
                                              gender,
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

  Future<Null> _selectBDate(context, ctrl) async {
    DateFormat dateFormat = DateFormat('yyyy-MMM-dd');
    DateTime _selectedBDate =
        ctrl.text != "" ? dateFormat.parse(ctrl.text) : DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedBDate,
        firstDate: DateTime(1960, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedBDate)
      ctrl.text = DateFormat('yyyy-MMM-dd').format(picked);
    setState(() {
      birthDate = ctrl.text;
    });
  }

  // void _handleRadioValueChange(int value) {
  //   setState(() {
  //     _radioValue = value;

  //     switch (_radioValue) {
  //       case -1:
  //         Text("data");
  //         break;
  //       case 1:
  //         String value = "Male";
  //         gender = value;
  //         break;
  //       case 2:
  //         String value = "Female";
  //         gender = value;
  //         break;
  //     }
  //   });
  // }

 
}


class GenderList {
  String title;
  int index;
  GenderList({this.title,this.index});
  
}