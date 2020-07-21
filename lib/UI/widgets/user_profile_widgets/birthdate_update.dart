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
  String birthDate = "";

  TextEditingController _birthDate = new TextEditingController();

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
                  
                  ],
                ),
              )
            ],
          ),
        ));
  }


 

  Future<Null> _selectBDate(context, ctrl) async {
    DateFormat dateFormat = DateFormat('yyyy-MMM-dd');

    DateTime _selectedBDate =
        ctrl.text != "" ? dateFormat.parse(_birthDate.text) : DateTime.now();
    //  print(ctrl.text);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedBDate,
        firstDate: DateTime(1960, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedBDate)
      ctrl.text = DateFormat('yyyy-MMM-dd').format(picked);
    setState(() {
      // print("Hello" + ctrl.text);
      birthDate = ctrl.text;
      _birthDate.text = birthDate;
      print(_birthDate.text);
    });
  }
}



