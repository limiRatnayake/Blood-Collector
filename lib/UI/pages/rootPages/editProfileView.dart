import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:blood_collector/shared/decoration_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  int _radioValue = 1;
  String _radioItemHolder = "Yes";
  String birthDate = "";
  TextEditingController userFNameController = new TextEditingController();
  TextEditingController userLNameController = new TextEditingController();
  TextEditingController userPhoneNoController = new TextEditingController();
  TextEditingController userEmailAddController = new TextEditingController();
  TextEditingController userBirthdate = new TextEditingController();

  TextEditingController _birthDate = new TextEditingController();

  List<GenderList> radioButtonList = [
    GenderList(index: 1, title: "Female"),
    GenderList(index: 2, title: "Male")
  ];


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
            userFNameController.text = data.firstName;
            userLNameController.text = data.lastName;
            userPhoneNoController.text = data.mobileNo;
            userEmailAddController.text = data.email;
            _birthDate.text = data.birthDate;
            // birthDate = data.birthDate;
            return Column(
              children: [
                SizedBox(height: 15.0),
                _userFNameDeatils(),
                SizedBox(
                  height: 10.0,
                ),
                _userLNameDeatils(),
                SizedBox(
                  height: 10.0,
                ),
                _userEmailDeatils(),
                SizedBox(
                  height: 10.0,
                ),
                _userPhoneNumber(),
                SizedBox(
                  height: 10.0,
                ),
                _genderTextField(),
                SizedBox(
                  height: 10.0,
                ),
                _userBirthDate(),
                SizedBox(
                  height: 10.0,
                )
              ],
            );
          }
        });
  }

  Widget _userFNameDeatils() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: ListTile(
        title: Text(
          "First Name",
          style: TextStyle(color: Colors.black45),
        ),
        subtitle: TextFormField(
          controller: userFNameController,
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
    );
  }

  Widget _userLNameDeatils() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: ListTile(
        title: Text(
          "Last Name",
          style: TextStyle(color: Colors.black45),
        ),
        subtitle: TextFormField(
          controller: userLNameController,
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
    );
  }

  Widget _userEmailDeatils() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: ListTile(
        title: Text(
          "Email Address",
          style: TextStyle(color: Colors.black45),
        ),
        subtitle: TextFormField(
          controller: userEmailAddController,
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
    );
  }

  Widget _userPhoneNumber() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: ListTile(
        title: Text(
          "Phone Number",
          style: TextStyle(color: Colors.black45),
        ),
        subtitle: TextFormField(
          controller: userPhoneNoController,
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
    );
  }

  Widget _genderTextField() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: ListTile(
        title: Text(
          "Gender",
          style: TextStyle(color: Colors.black45),
        ),
        subtitle: Row(
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
                                  // replacementAvailability = val;
                                });
                              }))
                          .toList())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userBirthDate() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: ListTile(
        title: Text(
          "BirthDate",
          style: TextStyle(color: Colors.black45),
        ),
        subtitle: Row(
          children: [
            
            Text(
              '${birthDate}',
              style: TextStyle(color: Colors.black),
            ),
            IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  // FocusScope.of(context).requestFocus(new FocusNode());
                  _selectBDate(context, _birthDate);
                })
            // TextFormField(
            //   controller: _birthDate,
            //   // initialValue: birthDate,
            //   decoration: InputDecoration(
            //     hintText: "Phone number",
            //     suffixIcon: Icon(
            //       Icons.calendar_today,
            //       color: Colors.black,
            //     ),
            //     hintStyle: TextStyle(
            //       fontSize: 16.0,
            //       fontFamily: "Roboto",
            //     ),

            //     // enabledBorder: InputBorder.none
            //   ),
            //   validator: validateMobile,
            //   onChanged: (value) {
            //     setState(() {
            //       value = birthDate;
            //     });
            //   },
            //   onTap: () async {
            //     FocusScope.of(context).requestFocus(new FocusNode());
            //     _selectBDate(context, _birthDate);
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Future<Null> _selectBDate(context, ctrl) async {
    DateFormat dateFormat = DateFormat('yyyy-MMM-dd');

    DateTime _selectedBDate =
        ctrl.text != "" ? dateFormat.parse(_birthDate.text) : DateTime.now();
    // setState(() {
    //   birthDate = ctrl.text;
    // });
    // DateTime _selectedBDate = ctrl.text != "" ? dateFormat.parse(_birthDate.text) : DateTime.now();
    //  print(ctrl.text);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedBDate,
        firstDate: DateTime(1960, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedBDate)
      ctrl.text = DateFormat('yyyy-MMM-dd').format(picked);
    setState(() {
      birthDate = ctrl.text;
      print(birthDate);
    });
  }
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

class GenderList {
  String title;
  int index;
  GenderList({this.title, this.index});
}
