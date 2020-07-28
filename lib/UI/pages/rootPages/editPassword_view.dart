import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:blood_collector/shared/decoration_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EdiPasswordView extends StatefulWidget {
  @override
  _EdiPasswordViewState createState() => _EdiPasswordViewState();
}

class _EdiPasswordViewState extends State<EdiPasswordView> {
  final _formKey = GlobalKey<FormState>();

  bool _formValidate = false;
  bool _isLoading = false;

  String email;
  bool checkCurrentPasswordValid = true;

  TextEditingController _currentPasswordController =
      new TextEditingController();
  TextEditingController _newPasswordController = new TextEditingController();
  TextEditingController _repeatPasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);
    return Scaffold(
        appBar: AppBar(
          actionsIconTheme: null,
          title: Text("Login Security"),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: [
          Form(
            key: _formKey,
            autovalidate: _formValidate,
            child: Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListTile(
                    title: Text(
                      "Current Password",
                      style: TextStyle(color: Colors.black45),
                    ),
                    subtitle: TextFormField(
                      controller: _currentPasswordController,
                      decoration: InputDecoration(
                          hintText: "Enter current password",
                          hintStyle: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "Roboto",
                          ),
                          errorText: checkCurrentPasswordValid
                              ? null
                              : "Please dobule check your password",
                          enabledBorder: InputBorder.none),
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListTile(
                    title: Text(
                      "New password",
                      style: TextStyle(color: Colors.black45),
                    ),
                    subtitle: TextFormField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                          hintText: "New password",
                          hintStyle: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "Roboto",
                          ),
                          enabledBorder: InputBorder.none),
                      validator: validatePassword,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListTile(
                    title: Text(
                      "Repeat New Password",
                      style: TextStyle(color: Colors.black45),
                    ),
                    subtitle: TextFormField(
                      controller: _repeatPasswordController,
                      decoration: InputDecoration(
                          hintText: "New Password, again",
                          hintStyle: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "Roboto",
                          ),
                          enabledBorder: InputBorder.none),
                      obscureText: true,
                      validator: (value) {
                        return _newPasswordController.text == value
                            ? null
                            : "Please check your entered password";
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                    width: double.infinity,
                    height: 58,
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                    decoration: boxDecoration,
                    child: ButtonTheme(
                        child: RaisedButton(
                            elevation: 0.0,
                            child: Text("Save Chnages",
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontSize: 18.0,
                                    color: Colors.black)),
                            textColor: Colors.black,
                            color: Colors.red.withOpacity(0.9),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.5)),
                            onPressed: () async {
                              checkCurrentPasswordValid =
                                  await _userService.vaildatePassword(
                                      _currentPasswordController.text);
                              setState(() {});
                              //check if the current password and the form is valid then update the password 
                              if (_formKey.currentState.validate() &&
                                  checkCurrentPasswordValid) {
                                _userService.updatePassword(
                                    _repeatPasswordController.text);

                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  _formValidate = true;
                                });
                              }
                            }))),
                SizedBox(height: 20.0),
              ],
            ),
          )
        ]))));
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
