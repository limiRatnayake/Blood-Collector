import 'package:blood_collector/UI/pages/authentication/signin_view.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:blood_collector/shared/decoration_constant.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordPageState();
  }
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _formValidate = false;
  String _errorMessage;

  String email = '';
  String password = '';
  String error = '';
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _emailTextField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration, //import from shared
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
          onChanged: (value) {
            setState(() {
              email = value;
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
          body: ListView(
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 280.0,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Center(
                                child: Image.asset("assets/logo_name.png"),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Center(
                              child: Text(
                                "Request a Password Reset",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 45),
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    "Enter the email you used to register",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 18),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 25.0,
                              ),
                              Form(
                                key: _formKey,
                                autovalidate: _formValidate,
                                child: Column(
                                  children: <Widget>[
                                    _emailTextField(),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    _errorMessage != null
                                        ? Container(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            width: double.infinity,
                                            child: Text(
                                              _errorMessage,
                                              style: TextStyle(
                                                  color: Colors.redAccent),
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
                                                child: Text("REQUEST",
                                                    style: TextStyle(
                                                      fontFamily: "Roboto",
                                                      fontSize: 18.0,
                                                    )),
                                                textColor: Colors.black,
                                                color:
                                                    Colors.red.withOpacity(0.9),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.5)),
                                                onPressed: () async {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    String response =
                                                        await _authService
                                                            .resetPassword(
                                                                email);
                                                    if (response != "Success") {
                                                      setState(() {
                                                        _isLoading = false;
                                                        _errorMessage =
                                                            response;
                                                      });
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          // returns a object of type Dialog
                                                          return AlertDialog(
                                                            title: new Text(
                                                                "Request Sent"),
                                                            content: new Text(
                                                                "Check your mails and follow the link, Then Come Again"),
                                                            actions: <Widget>[
                                                              new FlatButton(
                                                                child: new Text(
                                                                    "Close"),
                                                                onPressed: () {
                                                                  Navigator
                                                                      .pushReplacementNamed(
                                                                    context,
                                                                    AppConstants
                                                                        .SIGN_IN,
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
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
                                    SizedBox(height: 33.0),
                                    Container(
                                        child: Center(
                                            child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Remember the password?  ",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontFamily: "Roboto"),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    ); //Scaffold
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
}
