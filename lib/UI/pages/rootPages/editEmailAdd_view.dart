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
  
  TextEditingController userFNameController = new TextEditingController();
  TextEditingController userLNameController = new TextEditingController();
  TextEditingController userEmailAddController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthServices _authService = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);
    return Scaffold(
        appBar: AppBar(
          actionsIconTheme: null,
          title: Text("Edit Email Address"),
        ),
        body: FutureBuilder<DocumentSnapshot>(
            future: _userService.requestUserDetails(_authService.user.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("Loading..");
              } else {
                UserModel data = UserModel.fromMap(snapshot.data.data);
                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
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
                                    initialValue: data.firstName,
                                    decoration: InputDecoration(
                                      hintText: "Enter Email Address",
                                      hintStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: "Roboto",
                                      ),
                                      // enabledBorder: InputBorder.none
                                    ),
                                    validator: validateEmailAddress,
                                    onChanged: (value) {
                                      setState(() {
                                       
                                      });
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
                                    "Confirm New Email Address",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  subtitle: TextFormField(
                                    // controller: userLNameController,
                                    initialValue: data.lastName,
                                    decoration: InputDecoration(
                                      hintText: "Last Name",
                                      hintStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: "Roboto",
                                      ),
                                      // enabledBorder: InputBorder.none
                                    ),
                                    validator: validateEmailAddress,
                                    onChanged: (value) {
                                      setState(() {
                                     
                                      });
                                   
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
                                    // controller: userLNameController,
                                    initialValue: data.lastName,
                                    decoration: InputDecoration(
                                      hintText: "Enter Your Password",
                                      hintStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: "Roboto",
                                      ),
                                      // enabledBorder: InputBorder.none
                                    ),
                                    validator: validateEmailAddress,
                                    onChanged: (value) {
                                      setState(() {
                                       
                                      });
                                      
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
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
                        ),
                      ],
                    ),
                  ),
                );
              }
            }));
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

  String validateBloodGroup(String value) {
    if (value == "Select Blood Type") {
      return 'Blood Type should be selected';
    }
    return null;
  }
}
