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

class EditEmailAddressView extends StatefulWidget {
  @override
  _EditEmailAddressViewState createState() => _EditEmailAddressViewState();
}

class _EditEmailAddressViewState extends State<EditEmailAddressView> {
  final _formKey = GlobalKey<FormState>();
  DateFormat format = DateFormat('yyy-MMM-dd');

  bool _formValidate = false;
  bool _isLoading = false;
  String _errorMessage;

  String email;
  bool _obscureText = true;
  bool checkCurrentPasswordValid = true;

  TextEditingController _newEmailAddController = new TextEditingController();
  TextEditingController _currentEmailAddController =
      new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);
    return Scaffold(
        appBar: AppBar(
          actionsIconTheme: null,
          title: Text("Edit Email Address"),
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
                      "New Email Address",
                      style: TextStyle(color: Colors.black45),
                    ),
                    subtitle: TextFormField(
                      controller: _newEmailAddController,
                      decoration: InputDecoration(
                        hintText: "Enter Email Address",
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Roboto",
                        ),
                        // enabledBorder: InputBorder.none
                      ),
                      validator: validateEmailAddress,
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
                      "Confirm New Email Address",
                      style: TextStyle(color: Colors.black45),
                    ),
                    subtitle: TextFormField(
                      controller: _currentEmailAddController,
                      decoration: InputDecoration(
                        hintText: "Repeat Email Address",
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Roboto",
                        ),
                        // enabledBorder: InputBorder.none
                      ),
                      validator: (value) {
                        return _newEmailAddController.text == value
                            ? null
                            : "Please check your entered email Address";
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
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListTile(
                    title: Text(
                      "Password",
                      style: TextStyle(color: Colors.black45),
                    ),
                    subtitle: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          hintText: "Enter Your Password",
                          hintStyle: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "Roboto",
                          ),
                          errorText: checkCurrentPasswordValid
                              ? null
                              : "Please dobule checkyour password",
                          enabledBorder: InputBorder.none),
                      obscureText: _obscureText,
                      // validator: validatePassword,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    trailing: FlatButton(
                      onPressed: _toggle,
                      child: _obscureText
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
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
                            child: Text("Save Changes",
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontSize: 18.0,
                                    color: Colors.black)),
                            textColor: Colors.black,
                            color: Colors.red.withOpacity(0.9),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.5)),
                            onPressed: () async {
                              checkCurrentPasswordValid = await _userService
                                  .vaildatePassword(_passwordController.text);
                              setState(() {});
                              if (_formKey.currentState.validate() &&
                                  checkCurrentPasswordValid) {
                                _userService.updateEmail(
                                    _currentEmailAddController.text);

                                Navigator.pushReplacementNamed(
                                  context,
                                  AppConstants.HOME_PAGE,
                                );
                              }
                            }))),
                // _errorMessage != null
                //     ? Container(
                //         padding: EdgeInsets.only(bottom: 10),
                //         width: double.infinity,
                //         child: Text(
                //           _errorMessage,
                //           style:
                //               TextStyle(color: Colors.redAccent),
                //           textAlign: TextAlign.center,
                //         ),
                //       )
                //     : Container(),
                // _isLoading
                //     ? Center(
                //         child: CircularProgressIndicator(),
                //       )
                //     : Container(
                //         width: double.infinity,
                //         height: 58,
                //         margin: EdgeInsets.symmetric(
                //             horizontal: 30.0),
                //         decoration: boxDecoration,
                //         child: ButtonTheme(
                //           child: RaisedButton(
                //             elevation: 0.0,
                //             child: Text("SIGNUP",
                //                 style: TextStyle(
                //                     fontFamily: "Roboto",
                //                     fontSize: 18.0,
                //                     color: Colors.black)),
                //             textColor: Colors.black,
                //             color: Colors.red.withOpacity(0.9),
                //             shape: RoundedRectangleBorder(
                //                 borderRadius:
                //                     BorderRadius.circular(25.5)),
                //             onPressed: () async {
                //               if (_formKey.currentState
                //                   .validate()) {
                //                 setState(() {
                //                   _errorMessage = "";
                //                   _isLoading = true;
                //                 });
                //                 String response =
                //                     await _userService
                //                         .updateUserProfile(
                //                   _authService.user.uid,
                //                   userFName ?? data.firstName,
                //                   userLName ?? data.lastName,
                //                   gender ?? data.gender,
                //                   birthDate ?? data.birthDate,
                //                   bloodGroup ?? data.bloodGroup,
                //                   userPhoneNumber ??
                //                       data.mobileNo,
                //                 );
                //                 if (response != "Success") {
                //                   setState(() {
                //                     _isLoading = false;
                //                     _errorMessage = response;
                //                   });
                //                 } else {
                //                   Alert(
                //                       context: context,
                //                       type: AlertType.success,
                //                       title:
                //                           "Your event is Successfully updated!",
                //                       style: AlertStyle(
                //                           backgroundColor:
                //                               Colors.black,
                //                           alertBorder:
                //                               RoundedRectangleBorder(
                //                                   borderRadius:
                //                                       BorderRadius
                //                                           .circular(
                //                                               5),
                //                                   side: BorderSide(
                //                                       color: Colors
                //                                           .white)),
                //                           titleStyle: TextStyle(
                //                               color: Colors
                //                                   .blueAccent)),
                //                       buttons: [
                //                         DialogButton(
                //                             width: 120,
                //                             child: Text(
                //                               "ok",
                //                               style: TextStyle(
                //                                   color: Colors
                //                                       .white,
                //                                   fontSize: 20),
                //                             ),
                //                             onPressed: () {
                //                               Navigator
                //                                   .pushReplacementNamed(
                //                                 context,
                //                                 AppConstants
                //                                     .MYPROFILE_VIEW,
                //                               );
                //                             })
                //                       ]).show();
                //                   setState(() {
                //                     _isLoading = false;
                //                   });
                //                 }
                //               } else {
                //                 setState(() {
                //                   _formValidate = true;
                //                 });
                //               }
                //             },
                //           ),
                //         ),
                //       ),
                SizedBox(height: 20.0),
              ],
            ),
          )
        ]))));
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
}
