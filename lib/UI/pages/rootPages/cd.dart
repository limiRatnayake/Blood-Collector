import 'dart:async';
import 'dart:io';

import 'package:blood_collector/UI/pages/rootPages/editEmailAdd_view.dart';
import 'package:blood_collector/UI/pages/rootPages/editUserAddressView.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:blood_collector/shared/decoration_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';

class EditRequestView extends StatefulWidget {
  final String docRef;

  EditRequestView({Key key, this.docRef}) : super(key: key);
  @override
  _EditRequestViewState createState() => _EditRequestViewState();
}

class _EditRequestViewState extends State<EditRequestView> {
  final _formKey = GlobalKey<FormState>();
  File _image;
  final picker = ImagePicker();
  DateFormat format = DateFormat('yyy-MMM-dd');

  bool _formValidate = false;
  bool _isLoading = false;
  String _errorMessage;

  String userFName;
  String userLName;
  String email;
  String address;
  String bloodGroup;
  String birthDate;
  String gender;
  String userPhoneNumber;
  String proPicUrl =
      'https://firebasestorage.googleapis.com/v0/b/final-year-project-a89ff.appspot.com/o/profile_picture%2Fblank_proPic.jpg?alt=media&token=e33110a2-a94a-4405-9fbc-e3bc4ba3c292';

  String imgName = "";
  String imageExtention = "";
  String imgUrl = "";

  List<String> _bloodGroupType = [
    "Select a blood Group",
    'A+',
    'O+',
    'B+',
    'AB+',
    'A-',
    'O-',
    'B-',
    'AB-'
  ];

  List<String> _genderType = [
    'Male',
    'Female',
  ];

  @override
  Widget build(BuildContext context) {
    String docRef = widget.docRef;
    final AuthServices _authService = Provider.of<AuthServices>(context);
    final EventService _eventServices = Provider.of<EventService>(context);
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            appBar: AppBar(
              // actionsIconTheme: null,
              iconTheme: IconThemeData(color: Colors.black),

              title: Text("Edit Profile"),
            ),
            body: FutureBuilder<DocumentSnapshot>(
                future: _eventServices.requestEventsDetails(docRef),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading..");
                  } else {
                    EventModel data = EventModel.fromMap(snapshot.data.data);

                    return SingleChildScrollView(
                      child: Container(
                          child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            autovalidate: _formValidate,
                            child: Container(
                              child: Card(
                                child: Column(
                                  children: <Widget>[
                                    Card(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: ListTile(
                                        title: Text(
                                          "First Name",
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                        subtitle: TextFormField(
                                          initialValue: data.userFName,
                                          decoration: InputDecoration(
                                            hintText: "First Name",
                                            hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: "Roboto",
                                            ),
                                            // enabledBorder: InputBorder.none
                                          ),
                                          validator: validateFormData,
                                          onChanged: (value) {
                                            setState(() {
                                              userFName = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Card(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: ListTile(
                                        title: Text(
                                          "Last Name",
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                        subtitle: TextFormField(
                                          // controller: userLNameController,
                                          initialValue: data.userLName,
                                          decoration: InputDecoration(
                                            hintText: "Last Name",
                                            hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: "Roboto",
                                            ),
                                            // enabledBorder: InputBorder.none
                                          ),
                                          validator: validateFormData,
                                          onChanged: (value) {
                                            setState(() {
                                              userLName = value;
                                            });
                                            print(userLName);
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Card(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: ListTile(
                                        title: Text(
                                          "Blood Group",
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4, left: 2),
                                          child: DropdownButtonFormField(
                                            value: data.bloodGroup,
                                            decoration: InputDecoration(
                                                hintText: 'Blood Type',
                                                hintStyle: TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: "Roboto",
                                                    color: Colors.black54),
                                                enabledBorder:
                                                    InputBorder.none),
                                            validator: validateBloodGroup,
                                            items: _bloodGroupType
                                                .map((bloodgroup) {
                                              return DropdownMenuItem(
                                                value: bloodgroup,
                                                child: Text(bloodgroup),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                bloodGroup = value;
                                              });
                                              print(bloodGroup);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    SizedBox(
                                      height: 10.0,
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
                                                child: Text("Save Changes",
                                                    style: TextStyle(
                                                        fontFamily: "Roboto",
                                                        fontSize: 18.0,
                                                        color: Colors.black)),
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
                                                      _errorMessage = "";
                                                      _isLoading = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _formValidate = true;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                    SizedBox(height: 20.0),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                    );
                  }
                })));
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () => {Navigator.pop(context), _getImage(true)}),
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Gallery'),
                  onTap: () => {Navigator.pop(context), _getImage(false)},
                ),
              ],
            ),
          );
        });
  }

  Future _getImage(bool isCamera) async {
    try {
      if (isCamera) {
        final pickedFile = await picker.getImage(source: ImageSource.camera);

        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        final pickedFile = await picker.getImage(source: ImageSource.gallery);
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to Discard Changes?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("NO, BY MISTAKE")),
                FlatButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("YES, I WANT TO"))
              ],
            ));
  }

  String validateFormData(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return "This feild is required ";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String validateMobile(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(pattern);
    if (value.length != 10) {
      return 'Mobile Number must be of 10 digit';
    } else if (!regExp.hasMatch(value)) {
      return "Name must be numeric vaue";
    }
    return null;
  }

  String dateTimeValidator(DateTime dateTime) {
    if (dateTime == null) {
      return "Date Time Required";
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

  String validateBloodGroup(String value) {
    if (value == "Select Blood Type") {
      return 'Blood Type should be selected';
    }
    return null;
  }
}
