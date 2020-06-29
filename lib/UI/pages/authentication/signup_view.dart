import 'dart:async';

import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:blood_collector/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  String confirmPassword = '';
  String userAddLat = '';
  String userAddLng = '';

  String error = '';
  String uid = '';
  String _radioItemHolder = "Male";
  int _radioValue = 1;
  bool _isLoading = false;
  String _errorMessage;
  String _bloodGroup = 'Select Blood Type';
  bool _formValidate = false;
  bool _obscureText = true;

  TextEditingController _birthDate = TextEditingController();
  TextEditingController _userAddressController = TextEditingController();

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

  void _getLocation() async {
    final currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    getSetAddress(
        Coordinates(currentLocation.latitude, currentLocation.longitude));
    setState(() {
      //injecting the parameters
      userAddLat = "${currentLocation.latitude}";
      userAddLng = "${currentLocation.longitude}";
    });
  }

  getSetAddress(Coordinates coordinates) async {
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      //get the selelcted position into textfeild
      _userAddressController.text = addresses.first.addressLine;
      address = _userAddressController.text;
    });
  }

  List<GenderList> radioButtonList = [
    GenderList(index: 1, title: "Male"),
    GenderList(index: 2, title: "Female")
  ];

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void something(String value) {
    setState(() {
      _bloodGroup = value;
    });
  }

  @override
  initState() {
    _getLocation();
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
          decoration:
              inputDecoration.copyWith(hintText: "Enter First Name here"),
          keyboardType: TextInputType.text,
          validator: validateName,
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
          decoration:
              inputDecoration.copyWith(hintText: "Enter Last Name here"),
          keyboardType: TextInputType.text,
          validator: validateName,
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
      width: 370,
      // height: 58,
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: SizedBox(
                  width: 30.0,
                  child: Column(
                      children: radioButtonList
                          .map((data) => RadioListTile(
                              title: Text("${data.title}"),
                              value: data.index,
                              groupValue: _radioValue,
                              onChanged: (val) {
                                setState(() {
                                  _radioItemHolder = data.title;
                                  _radioValue = data.index;
                                  val = _radioItemHolder;
                                  print(val);

                                  gender = val;
                                });
                              }))
                          .toList())),
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
        child: TextFormField(
          controller: _birthDate,
          decoration: inputDecoration.copyWith(
              hintText: "mm/dd/yyyy",
              suffixIcon: Icon(
                Icons.calendar_today,
                color: Colors.black,
              )),
          validator: (value) => value.isEmpty ? 'Name should be filled' : null,
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
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
          validator: validateBloodGroup,
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
          decoration: inputDecoration.copyWith(
            hintText: "Enter Mobile Number here",
          ),
          keyboardType: TextInputType.phone,
          validator: validateMobile,
          onChanged: (val) {
            setState(() {
              mobileNo = val;
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
          enabled: false,
          controller: _userAddressController,
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
          validator: validateEmailAddress,
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
      // height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                // controller: _passController,
                decoration: inputDecoration.copyWith(
                  hintText: "Password",
                ),
                keyboardType: TextInputType.visiblePassword,
                validator: validatePassword,
                obscureText: _obscureText,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
            ),
            FlatButton(
              onPressed: _toggle,
              child: _obscureText
                  ? Icon(Icons.visibility_off)
                  : Icon(Icons.visibility),
            )
          ],
        ),
      ),
    );
  }

  Widget _confirmPasswordField() {
    return Container(
      width: double.infinity,
      // height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: inputDecoration.copyWith(
                  hintText: "Confirm Password",
                ),
                keyboardType: TextInputType.visiblePassword,
                validator: validateConfirmPassword,
                obscureText: _obscureText,
                onChanged: (val) {
                  setState(() {
                    confirmPassword = val;
                  });
                },
              ),
            ),
            FlatButton(
              onPressed: _toggle,
              child: _obscureText
                  ? Icon(Icons.visibility_off)
                  : Icon(Icons.visibility),
            )
          ],
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
                  autovalidate: _formValidate,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "First Name",
                              style: TextStyle(
                                  fontFamily: 'Roboto', fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      _firstNameTextField(),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Last Name",
                              style: TextStyle(
                                  fontFamily: 'Roboto', fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      _lastNameTextField(),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Select a gender",
                              style: TextStyle(
                                  fontFamily: 'Roboto', fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      _genderRadioButton(),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Select Date of Birth",
                              style: TextStyle(
                                  fontFamily: 'Roboto', fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      _birthDateSelector(),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Select Blood Type",
                              style: TextStyle(
                                  fontFamily: 'Roboto', fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      _bloodGroupTextField(),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Mobile Number",
                              style: TextStyle(
                                  fontFamily: 'Roboto', fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      _mobileNoField(),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Postal Address",
                              style: TextStyle(
                                  fontFamily: 'Roboto', fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      _postalAddressField(),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Email Address",
                              style: TextStyle(
                                  fontFamily: 'Roboto', fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      _emailTextField(),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Password",
                              style: TextStyle(
                                  fontFamily: 'Roboto', fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      _passwordField(),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Confirm Password",
                              style: TextStyle(
                                  fontFamily: 'Roboto', fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      _confirmPasswordField(),
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
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        _errorMessage = "";
                                        _isLoading = true;
                                      });
                                      String response =
                                          await _authService.createUser(
                                        email,
                                        confirmPassword,
                                        uid,
                                        firstName,
                                        lastName,
                                        birthDate,
                                        gender,
                                        mobileNo,
                                        bloodGroup,
                                        address,
                                        userAddLat,
                                        userAddLng,
                                      );
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
                                                "Your event is Successfully created!",
                                            style: AlertStyle(
                                                backgroundColor: Colors.black,
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
                                                      AppConstants.HOME,
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

  String validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return "Name is required ";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String validateBloodGroup(String value) {
    if (value == "Select Blood Type") {
      return 'Blood Type should be selected';
    }
    return null;
  }

  String validateMobile(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(pattern);
    if (value.length != 10) {
      return 'Mobile Number must be of 10 digit';
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String validateEmailAddress(String value) {
    String pattern =
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Email Address is required.';
    } else if (!regExp.hasMatch(value)) {
      return "Invailed email address!";
    }
    return null;
  }

  String validatePassword(String value) {
    var strongRegex = new RegExp(
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})");

    if (value.isEmpty) {
      return "Password is required";
    } else if (!strongRegex.hasMatch(value)) {
      return "Password is not strong enough!";
    }
    return null;
  }

  String validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return "Password is required";
    }else if (value != password) {
      return 'Password Not Match';
    }
    return null;
  }
}

class GenderList {
  String title;
  int index;
  GenderList({this.title, this.index});
}
