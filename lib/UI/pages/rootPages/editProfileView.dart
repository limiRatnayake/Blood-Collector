import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:blood_collector/shared/decoration_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final format = DateFormat("yyyy-MMM-dd");
  int value;
  String birthDate = "";
  String previousGender;
  String userBloodGroup;
  String _bloodGroup;
  TextEditingController userFNameController = new TextEditingController();
  TextEditingController userLNameController = new TextEditingController();
  TextEditingController userPhoneNoController = new TextEditingController();
  TextEditingController userEmailAddController = new TextEditingController();

  TextEditingController _birthDate = new TextEditingController();

  List<String> _bloodGroupType = [
    "Select Blood Type",
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
  void dispose() {
    // other dispose methods
    _birthDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actionsIconTheme: null,
          leading: Container(
            child: Icon(Icons.check),
          ),
          title: Text("Edit Profile"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 180.0,
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/person.jpg"),
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
                            style:
                                TextStyle(color: Colors.blue, fontSize: 16.0),
                          ),
                          onTap: () {},
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Call the widget class
                    _userProfileDataBuilder(context),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _userProfileDataBuilder(BuildContext context) {
    final AuthServices _authService = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);

    return FutureBuilder<DocumentSnapshot>(
        future: _userService.requestUserDetails(_authService.user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading..");
          } else {
            UserModel data = UserModel.fromMap(snapshot.data.data);
            return Column(
              children: [
                SizedBox(height: 15.0),
                // _userFNameDeatils(),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListTile(
                    title: Text(
                      "First Name",
                      style: TextStyle(color: Colors.black45),
                    ),
                    subtitle: TextFormField(
                      // controller: userFNameController,
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
                        value = userFNameController.text;
                        // userFName = value;
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
                      "Last Name",
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
                      validator: validateFormData,
                      onChanged: (value) {
                        value = userLNameController.text;
                        // userLName = value;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                // _bloodGroupTextField(),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListTile(
                    title: Text(
                      "Blood Group",
                      style: TextStyle(color: Colors.black45),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4, left: 2),
                      child: DropdownButtonFormField(
                        value: _bloodGroup ?? data.bloodGroup,
                        decoration: InputDecoration(
                            hintText: 'Blood Type',
                            hintStyle: TextStyle(
                                fontSize: 16.0,
                                fontFamily: "Roboto",
                                color: Colors.black54),
                            enabledBorder: InputBorder.none),
                        validator: validateBloodGroup,
                        onChanged: (value) {
                          // setState(() {
                          //   bloodGroup = value;
                          // });
                          // something(value);
                        },
                        items: _bloodGroupType.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
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
                      "Email Address",
                      style: TextStyle(color: Colors.black45),
                    ),
                    subtitle: TextFormField(
                      // controller: userEmailAddController,
                      initialValue: data.email,
                      decoration: InputDecoration(
                        hintText: "Email Address",
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Roboto",
                        ),
                        // enabledBorder: InputBorder.none
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmailAddress,
                      onChanged: (value) {
                        value = userEmailAddController.text;
                        // userEmailAdd = value;
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
                      "Phone Number",
                      style: TextStyle(color: Colors.black45),
                    ),
                    subtitle: TextFormField(
                      initialValue: data.mobileNo,
                      decoration: InputDecoration(
                        hintText: "Phone number",
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Roboto",
                        ),
                        // enabledBorder: InputBorder.none
                      ),
                      keyboardType: TextInputType.phone,
                      validator: validateMobile,
                      onChanged: (value) {
                        value = userPhoneNoController.text;
                        // userPhoneNumber = value;
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
                    title:Text(
                      "Gender",
                      style: TextStyle(color: Colors.black45),
                    ) ,
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4, left: 2),
                      child: DropdownButtonFormField(
                        value: _bloodGroup ?? data.gender,
                        decoration: InputDecoration(
                            hintText: 'Gender',
                            hintStyle: TextStyle(
                                fontSize: 16.0,
                                fontFamily: "Roboto",
                                color: Colors.black54),
                            enabledBorder: InputBorder.none),
                        validator: validateBloodGroup,
                        onChanged: (value) {
                          // setState(() {
                          //   bloodGroup = value;
                          // });
                          // something(value);
                        },
                        items: _genderType.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
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
                      "BirthDate",
                      style: TextStyle(color: Colors.black45),
                    ),
                    subtitle: DateTimeField(
                      initialValue: format.parse(data.birthDate),
                      format: format,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            );
          }
        });
  }

  Widget _genderTextField() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
          child: Padding(
        padding: EdgeInsets.only(right: 65),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                  onTap: () => setState(() {
                        if (previousGender == "Female") {
                          value = 0;
                        }
                      }),
                  leading: Radio(
                    value: 0,
                    groupValue: value,
                    onChanged: (v) => setState(() => value = v),
                  )),
            ),
            Text(
              'Male',
              style: new TextStyle(
                fontSize: 16.0,
              ),
            ),
            Expanded(
              child: ListTile(
                  onTap: () => setState(() {
                        if (previousGender == "Female") {
                          value = 1;
                        }
                      }),
                  leading: Radio(
                    value: 1,
                    groupValue: value,
                    onChanged: (v) => setState(() => value = v),
                  )),
            ),
            Text(
              'Female',
              style: new TextStyle(
                fontSize: 16.0,
              ),
            )
          ],
        ),
      )),
    );
  }

  // Widget _genderTextField() {
  //   return Card(
  //     margin: EdgeInsets.symmetric(horizontal: 15.0),
  //     child: ListTile(
  //       title: Text(
  //         "Gender",
  //         style: TextStyle(color: Colors.black45),
  //       ),
  //       subtitle: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           Expanded(
  //             child: SizedBox(
  //                 width: 30.0,
  //                 child: Column(
  //                     children: radioButtonList
  //                         .map((data) => RadioListTile(
  //                             title: Text("${data.title}"),
  //                             value: data.index,
  //                             groupValue: _radioValue,
  //                             onChanged: (val) {
  //                               setState(() {
  //                                 _radioItemHolder = data.title;
  //                                 print(_radioValue);
  //                                 _radioValue = data.index;
  //                                 val = _radioItemHolder;
  //                                 print(val);
  //                               });
  //                             }))
  //                         .toList())),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
