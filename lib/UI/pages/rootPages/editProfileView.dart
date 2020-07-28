import 'package:blood_collector/UI/pages/rootPages/editEmailAdd_view.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:blood_collector/shared/decoration_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  DateFormat format = DateFormat('yyy-MMM-dd');

  bool _formValidate = false;
  bool _isLoading = false;
  String _errorMessage;

  String userFName;
  String userLName;
  String email;
  String bloodGroup;
  String birthDate;
  String gender;
  String userPhoneNumber;
  
  List<String> _bloodGroupType = [
    "Select a blood Group"
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
    final AuthServices _authService = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);
    return Scaffold(
        appBar: AppBar(
          actionsIconTheme: null,
          leading: Container(
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {},
            ),
          ),
          title: Text("Edit Profile"),
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
                              Container(
                                // height: 180.0,
                                child: Card(
                                  child: Column(
                                    children: <Widget>[
                                      Center(
                                        child: CircleAvatar(
                                          backgroundImage:
                                              AssetImage("assets/person.jpg"),
                                          minRadius: 40,
                                          maxRadius: 60,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Center(
                                        child: InkWell(
                                          child: Text(
                                            "Change Profile Photo",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 16.0),
                                          ),
                                          onTap: () {},
                                        ),
                                      ),
                                      SizedBox(height: 15.0),
                                      Card(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: ListTile(
                                          title: Text(
                                            "First Name",
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                          subtitle: TextFormField(
                                            initialValue: data.firstName,
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
                                            style: TextStyle(
                                                color: Colors.black45),
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
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4, left: 2),
                                            child: DropdownButtonFormField(
                                              value:
                                                  bloodGroup ?? data.bloodGroup,
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
                                      Card(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: ListTile(
                                          title: Text(
                                            "Phone Number",
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                          subtitle: TextFormField(
                                            initialValue: data.mobileNo,
                                            decoration: InputDecoration(
                                              hintText: "Phone number",
                                              hintStyle: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: "Roboto",
                                              ),
                                            ),
                                            keyboardType: TextInputType.phone,
                                            validator: validateMobile,
                                            onChanged: (value) {
                                              setState(() {
                                                userPhoneNumber = value;
                                                print(userPhoneNumber);
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
                                            "Gender",
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4, left: 2),
                                            child: DropdownButtonFormField(
                                              value: gender ?? data.gender,
                                              decoration: InputDecoration(
                                                  hintText: 'Gender',
                                                  hintStyle: TextStyle(
                                                      fontSize: 16.0,
                                                      fontFamily: "Roboto",
                                                      color: Colors.black54),
                                                  enabledBorder:
                                                      InputBorder.none),
                                              validator: validateBloodGroup,
                                              items: _genderType
                                                  .map((String gender) {
                                                return DropdownMenuItem(
                                                  value: gender,
                                                  child: Text(gender),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  gender = value;
                                                });
                                              },
                                            ),
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
                                            "BirthDate",
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                          subtitle: DateTimeField(
                                            initialValue:
                                                format.parse(data.birthDate),
                                            format: format,
                                            onShowPicker:
                                                (context, currentValue) {
                                              return showDatePicker(
                                                  context: context,
                                                  firstDate: DateTime(1900),
                                                  initialDate: currentValue ??
                                                      DateTime.now(),
                                                  lastDate: DateTime(2100));
                                            },
                                            validator: dateTimeValidator,
                                            onChanged: (value) {
                                              setState(() {
                                                birthDate = value.toString();
                                                print(birthDate);
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
                                              "Email Address",
                                              style: TextStyle(
                                                  color: Colors.black45),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 1, top: 10),
                                              child: Text(
                                                data.email,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_right,
                                              color: Colors.black,
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                         EditEmailAddressView()));
                                            },
                                          )),
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
                                              child:
                                                  CircularProgressIndicator(),
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
                                                  child: Text("SIGNUP",
                                                      style: TextStyle(
                                                          fontFamily: "Roboto",
                                                          fontSize: 18.0,
                                                          color: Colors.black)),
                                                  textColor: Colors.black,
                                                  color: Colors.red
                                                      .withOpacity(0.9),
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
                                                      String response =
                                                          await _userService
                                                              .updateUserProfile(
                                                        _authService.user.uid,
                                                        userFName ??
                                                            data.firstName,
                                                        userLName ??
                                                            data.lastName,
                                                        gender ?? data.gender,
                                                        birthDate ??
                                                            data.birthDate,
                                                        bloodGroup ??
                                                            data.bloodGroup,
                                                        userPhoneNumber ??
                                                            data.mobileNo,
                                                      );
                                                      if (response !=
                                                          "Success") {
                                                        setState(() {
                                                          _isLoading = false;
                                                          _errorMessage =
                                                              response;
                                                        });
                                                      } else {
                                                        Alert(
                                                            context: context,
                                                            type: AlertType
                                                                .success,
                                                            title:
                                                                "Your event is Successfully updated!",
                                                            style: AlertStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                alertBorder: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5),
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .white)),
                                                                titleStyle: TextStyle(
                                                                    color: Colors
                                                                        .blueAccent)),
                                                            buttons: [
                                                              DialogButton(
                                                                  width: 120,
                                                                  child: Text(
                                                                    "ok",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .pushReplacementNamed(
                                                                      context,
                                                                      AppConstants
                                                                          .MYPROFILE_VIEW,
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
                                      SizedBox(height: 20.0),
                                    ],
                                  ),
                                ),
                              ),
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
