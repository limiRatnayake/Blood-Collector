


import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:blood_collector/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  

  String name = '';
  String bloodGroup = '';
  String mobileNo = '';
  String city = '';
  String address = '';
  String email = '';
  String password = '';

  String error = '';
  String uid = '';
  bool _isLoading = false;

  List<String> bloodGroupType = [ 'Select Blood Type','A+', 'O+', 'B+','AB+','A-','O-','B-','AB-'];
  String _bloodGroup = 'Select Blood Type';

  void something(String value) {
    setState(() {
      _bloodGroup = value;
    });
  }

  Widget _nameTextField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: inputDecoration.copyWith(hintText: "Name"),
          keyboardType: TextInputType.text,
          validator: (value) => value.isEmpty ? 'Name should be filled' : null,
          onChanged: (val) {
            setState(() {
              name = val;
            });
          },
        ),
      ),
    );
  }

  Widget _bloodGroupTextField() {
    
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: DropdownButtonFormField(
          value: _bloodGroup,
          decoration: InputDecoration(
              hintText: 'Blood Type',
              hintStyle: TextStyle(fontSize: 16.0, fontFamily: "Roboto"),
              enabledBorder: InputBorder.none),
          validator: (value) =>
              value == "Select Blood Type" ? 'Blood Type should be selected' : null,
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/backgroundImage.jpg"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(45.0, 15.0),
                        bottomRight: Radius.elliptical(45.0, 15.0)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text('Smart Donor',
                              style: TextStyle(
                                  fontFamily: "Raleway", fontSize: 35.0)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
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
                      _nameTextField(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _bloodGroupTextField(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _mobileNoField(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _cityField(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _postalAddressField(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _emailTextField(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _passwordField(),
                      SizedBox(
                        height: 30.0,
                      ),
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
                                  color: Colors.white,
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
                                              name,
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
                      SizedBox(
                        height: 25.0,
                      ),
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
