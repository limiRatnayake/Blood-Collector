import 'dart:io';

import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditCampaignView extends StatefulWidget {
  final String docRef;

  EditCampaignView({Key key, this.docRef}) : super(key: key);

  @override
  _EditCampaignViewState createState() => _EditCampaignViewState();
}

class _EditCampaignViewState extends State<EditCampaignView> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  DateFormat format = DateFormat('yyyy-MM-dd');

  File _image;

  String bloodGroup;
  String description;

  bool _formValidate = false;

  List<String> _bloodGroupType = [
    'A+',
    'O+',
    'B+',
    'AB+',
    'A-',
    'O-',
    'B-',
    'AB-'
  ];

  @override
  Widget build(BuildContext context) {
    final EventService _eventServices = Provider.of<EventService>(context);
    String docRef = widget.docRef;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          // actionsIconTheme: null,
          iconTheme: IconThemeData(color: Colors.black),

          title: Text("Edit Campaign View"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: FutureBuilder<DocumentSnapshot>(
              future: _eventServices.requestEventsDetails(docRef),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  EventModel data = EventModel.fromMap(snapshot.data.data);

                  return SingleChildScrollView(
                      child: Form(
                          key: _formKey,
                          autovalidate: _formValidate,
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0,
                                      left: 18.0,
                                      bottom: 8.0,
                                      right: 18.0),
                                  child: _image == null
                                      ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: data.imageUrl == ""
                                              ? DottedBorder(
                                                  color: Colors.black,
                                                  padding: EdgeInsets.only(
                                                    top: 30,
                                                    right: 150,
                                                    bottom: 30,
                                                    left: 150,
                                                  ),
                                                  strokeWidth: 2,
                                                  radius: Radius.circular(12),
                                                  dashPattern: [6, 6],
                                                  child: Icon(
                                                    Icons.backup,
                                                    size: 90,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              : Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      50,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            data.imageUrl),
                                                      )),
                                                ),
                                        )
                                      : Container(
                                          // height: 150,
                                          width: double.infinity,
                                          child: Image.file(_image,
                                              fit: BoxFit.fitHeight)),
                                ),
                                onTap: () {
                                  _settingModalBottomSheet(context);
                                },
                              ),
                              SizedBox(height: 10),
                              Card(
                                margin: EdgeInsets.symmetric(horizontal: 15.0),
                                child: ListTile(
                                  title: Text(
                                    "Description",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  subtitle: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 4, left: 2),
                                    child: TextFormField(
                                      initialValue: data.description,
                                      minLines: 10,
                                      maxLines: 15,
                                      decoration: InputDecoration(
                                        hintText: "Write your need her",
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                      ),
                                      validator: validateFormDescription,
                                      onChanged: (value) {
                                        setState(() {
                                          description = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          )));
                }
              }),
        ),
      ),
    );
  }

  String validateBloodGroup(String value) {
    if (value == "Select Blood Type") {
      return 'Blood Type should be selected';
    }
    return null;
  }

  String validateFormDescription(String value) {
    if (value.length == 0) {
      return "This feild is required ";
    }
    return null;
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
}
