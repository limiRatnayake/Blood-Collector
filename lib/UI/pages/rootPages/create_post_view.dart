import 'dart:io';

import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';

class CreatePostView extends StatefulWidget {
  final String bloodGroup;
  final String replacementAvailability;
  final String unitsOfBlood;
  final String requestClose;
  final String hospitalName;
  final String hospitalAddress;
  final String hospitalLat;
  final String hospitalLng;
  final String userFName;
  final String userLName;
  final String userPhoneNumber;
  final bool notifyState;
  final String nameOfTheOrganizer;
  final String pickUpDate;
  final String startTime;
  final String endTime;
  final String placeName;
  final String placeAddress;
  final String placeLat;
  final String placeLng;
  final String orgernizerConatctNo;
  final String category;

  //build constructor with argument values
  //optional argument key and optional values and then key is pass to the super class
  CreatePostView(
      {Key key,
      this.bloodGroup,
      this.replacementAvailability,
      this.unitsOfBlood,
      this.requestClose,
      this.hospitalName,
      this.hospitalAddress,
      this.hospitalLat,
      this.hospitalLng,
      this.userFName,
      this.userLName,
      this.userPhoneNumber,
      this.notifyState,
      this.nameOfTheOrganizer,
      this.pickUpDate,
      this.startTime,
      this.endTime,
      this.placeName,
      this.placeAddress,
      this.placeLat,
      this.placeLng,
      this.orgernizerConatctNo,
      this.category})
      : super(key: key);

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<CreatePostView> {
  final _formKey = GlobalKey<FormState>();

  File _image;

  final picker = ImagePicker();

  String description = '';
  String category;
  String imgName = "";
  String imageExtention = "";
  String imgUrl = "";

  bool _formValidate = false;
  bool _isLoading = false;
  String _errorMessage;

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(3, 6)),
          //BoxShadow
        ]);
  }

  Widget _eventDescription() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextFormField(
          minLines: 10,
          maxLines: 15,
          autocorrect: false,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Write your status here',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.grey),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser _user = Provider.of<AuthServices>(context).user;
    EventService _eventService = Provider.of<EventService>(context);

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          "Create Post",
        ),
        elevation: 0.3,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            autovalidate: _formValidate,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 25.0, left: 18.0, bottom: 8.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Add a description",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
                _eventDescription(),
                SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 25.0, left: 18.0, bottom: 8.0, right: 18.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Upload a image",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 25.0, left: 18.0, bottom: 8.0, right: 18.0),
                    child: _image == null
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
                            child: Center(
                              child: Icon(
                                Icons.backup,
                                size: 90,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : Container(
                            // height: 150,
                            width: double.infinity,
                            child: Image.file(_image, fit: BoxFit.fitHeight)),
                  ),
                  onTap: () {
                    _settingModalBottomSheet(context);
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                _errorMessage != null
                    ? Container(
                        padding: EdgeInsets.only(bottom: 10),
                        width: double.infinity,
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.redAccent),
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
                        margin: EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: _boxDecoration(),
                        child: ButtonTheme(
                          child: RaisedButton(
                            elevation: 0.0,
                            child: Text("Post Event",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 18.0,
                                )),
                            textColor: Colors.black,
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            onPressed: () async {
                              final _form = _formKey.currentState;

                              if (_image != null) {
                                imgName = Uuid().v1();
                                imageExtention = Path.extension(_image.path);
                                //upload image and get the url of the image
                                imgUrl = await _eventService.uploadImage(
                                    imgName, imageExtention, _image);
                              }

                              if (_form.validate() ) {
                                setState(() {
                                  _errorMessage = "";
                                  _isLoading = true;
                                  category = widget.category ?? "campaign";
                                  print(category);
                                });

                                String response = await _eventService.addEvent(
                                    _user,
                                    widget.bloodGroup,
                                    widget.replacementAvailability,
                                    widget.unitsOfBlood,
                                    widget.requestClose,
                                    widget.hospitalName,
                                    widget.hospitalAddress,
                                    widget.hospitalLat,
                                    widget.hospitalLng,
                                    widget.userFName,
                                    widget.userLName,
                                    widget.userPhoneNumber,
                                    widget.notifyState,
                                    widget.nameOfTheOrganizer,
                                    widget.pickUpDate,
                                    widget.startTime,
                                    widget.endTime,
                                    widget.placeName,
                                    widget.placeAddress,
                                    widget.placeLat,
                                    widget.placeLng,
                                    widget.orgernizerConatctNo,
                                    description,
                                    imgName, //imgName
                                    imageExtention,
                                    imgUrl,
                                          category,);
                                if (response != "Success") {
                                  setState(() {
                                    _isLoading = false;
                                    _errorMessage = response;
                                  });
                                } else {
                                  Alert(
                                      context: context,
                                      type: AlertType.success,
                                      title:
                                          "Your event is Successfully created!",
                                      style: AlertStyle(
                                        isCloseButton: false,
                                          backgroundColor: Colors.white,
                                          alertBorder: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: BorderSide(
                                                  color: Colors.white)),
                                          titleStyle: TextStyle(
                                              color: Colors.blueAccent)),
                                      buttons: [
                                        DialogButton(
                                            width: 120,
                                            child: Text(
                                              "ok",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                AppConstants.HOME_PAGE,
                                              );
                                            })
                                      ]).show();
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              } else {
                                print('Form is invaild');
                                setState(() {
                                  _formValidate = true;
                                });
                              }
                              _formKey.currentState.save();
                            },
                          ),
                        ),
                      ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            )),
      ),
    ));
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

  String validateFormDescription(String value) {
    if (value.length == 0) {
      return "This feild is required ";
    }
    return null;
  }
}
