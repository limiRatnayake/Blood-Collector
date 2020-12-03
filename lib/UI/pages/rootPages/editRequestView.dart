//library
import 'dart:io';

//pages
import 'package:blood_collector/UI/pages/rootPages/request_history.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/hospital_model.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/hospital_service.dart';
import 'package:blood_collector/shared/decoration_constant.dart';

//packages
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as Path;

class EditRequestView extends StatefulWidget {
  final String docRef;

  EditRequestView({Key key, this.docRef}) : super(key: key);

  @override
  _EditRequestViewState createState() => _EditRequestViewState();
}

class _EditRequestViewState extends State<EditRequestView> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  DateFormat format = DateFormat('yyyy-MM-dd');

  File _image;

  String bloodGroup;
  String replacementAvailability;
  String unitsOfBlood;
  String description;
  String userFName;
  String userLName;
  String userPhoneNumber;
  String requestClose;
  String hospitalName;
  String hospitalAddress;
  String hospitalLat;
  String hospitalLng;
  String imgName = "";
  String imageExtention = "";
  String imgUrl = "";

  bool _formValidate = false;
  var selectedHospital;
  bool _isLoading = false;
  String _errorMessage;

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
  List<String> _replacementAvailabilityOption = [
    'Yes',
    'No',
  ];
  TextEditingController addressController = new TextEditingController();
  TextEditingController addressLatController = new TextEditingController();
  TextEditingController addressLngController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    String docRef = widget.docRef;
    final EventService _eventServices = Provider.of<EventService>(context);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            // actionsIconTheme: null,
            iconTheme: IconThemeData(color: Colors.black),

            title: Text("Edit Request View"),
          ),
          body: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  autovalidate: _formValidate,
                  child: FutureBuilder(
                      future: _eventServices.requestEventsDetails(docRef),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          EventModel data =
                              EventModel.fromMap(snapshot.data.data);
                          return Column(
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
                                          print(description);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Card(
                                margin: EdgeInsets.symmetric(horizontal: 15.0),
                                child: ListTile(
                                  title: Text(
                                    "First Name",
                                    style: TextStyle(color: Colors.black45),
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
                                margin: EdgeInsets.symmetric(horizontal: 15.0),
                                child: ListTile(
                                  title: Text(
                                    "Last Name",
                                    style: TextStyle(color: Colors.black45),
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
                              SizedBox(height: 10),
                              Card(
                                margin: EdgeInsets.symmetric(horizontal: 15.0),
                                child: ListTile(
                                  title: Text(
                                    "Your Mobile Number",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  subtitle: TextFormField(
                                    initialValue: data.userPhoneNumber,
                                    decoration: InputDecoration(
                                        hintText: "Phone number",
                                        hintStyle: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: "Roboto",
                                        ),
                                        enabledBorder: InputBorder.none),
                                    keyboardType: TextInputType.phone,
                                    validator: validateMobile,
                                    onChanged: (value) {
                                      setState(() {
                                        userPhoneNumber = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Card(
                                margin: EdgeInsets.symmetric(horizontal: 15.0),
                                child: ListTile(
                                  title: Text(
                                    "Blood group that you are looking for?",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  subtitle: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 4, left: 2),
                                    child: DropdownButtonFormField(
                                      value: data.bloodGroup,
                                      decoration: InputDecoration(
                                          hintText: 'Blood Type',
                                          hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: "Roboto",
                                              color: Colors.black54),
                                          enabledBorder: InputBorder.none),
                                      // validator: validateDropdowns,
                                      items: _bloodGroupType.map((bloodgroup) {
                                        return DropdownMenuItem(
                                          value: bloodgroup,
                                          child: Text(bloodgroup),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          bloodGroup = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(horizontal: 15.0),
                                child: ListTile(
                                  title: Text(
                                    "How many units of blood you need?",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  subtitle: TextFormField(
                                    initialValue: data.unitsOfBlood,
                                    decoration: InputDecoration(
                                        hintText: "Units Of Blood",
                                        hintStyle: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: "Roboto",
                                        ),
                                        enabledBorder: InputBorder.none),
                                    validator: validateBloodUnit,
                                    onChanged: (value) {
                                      setState(() {
                                        unitsOfBlood = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(horizontal: 15.0),
                                child: ListTile(
                                  title: Text(
                                    "Is replacement available at hospital?",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  subtitle: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 4, left: 2),
                                    child: DropdownButtonFormField(
                                      value: data.replacementAvailability,
                                      decoration: InputDecoration(
                                          hintText: 'availability',
                                          hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: "Roboto",
                                              color: Colors.black54),
                                          enabledBorder: InputBorder.none),
                                      validator: validateDropdowns,
                                      items: _replacementAvailabilityOption
                                          .map((availability) {
                                        return DropdownMenuItem(
                                          value: availability,
                                          child: Text(availability),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          replacementAvailability = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _hospitalDetails(context, data.hospitalName),
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(horizontal: 15.0),
                                child: ListTile(
                                  title: Text(
                                    "Your request will close on this date.",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  subtitle: DateTimeField(
                                    // initialValue:format.parse(data.requestClose),
                                    initialValue: data.requestClose.toDate(),
                                    format: format,
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate:
                                              currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                    validator: dateTimeValidator,
                                    onChanged: (value) {
                                      setState(() {
                                        requestClose = value.toString();
                                        print(requestClose);
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _errorMessage != null
                                  ? Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      width: double.infinity,
                                      child: Text(
                                        _errorMessage,
                                        style:
                                            TextStyle(color: Colors.redAccent),
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
                                          color: Colors.red.withOpacity(0.9),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.5)),
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() {
                                                _errorMessage = "";
                                                _isLoading = true;
                                              });
                                              if (_image != null) {
                                                imgName = Uuid().v1();
                                                imageExtention =
                                                    Path.extension(_image.path);
                                                //upload image and get the url of the image
                                                imgUrl = await _eventServices
                                                    .uploadImage(imgName,
                                                        imageExtention, _image);
                                              } else {
                                                imgUrl = data.imageUrl;
                                                imgName = data.imageName;
                                                imageExtention =
                                                    data.imageExtention;
                                              }

                                              String response =
                                                  await _eventServices
                                                      .updateRequestEvents(
                                                docRef,
                                                bloodGroup ?? data.bloodGroup,
                                                replacementAvailability ??
                                                    data.replacementAvailability,
                                                unitsOfBlood ??
                                                    data.unitsOfBlood,
                                                requestClose ??
                                                    data.requestClose,
                                                hospitalName ??
                                                    data.hospitalName,
                                                hospitalAddress ??
                                                    data.hospitalAddress,
                                                hospitalLat ?? data.hospitalLat,
                                                hospitalLng ?? data.hospitalLng,
                                                userFName ?? data.userFName,
                                                userLName ?? data.userLName,
                                                userPhoneNumber ??
                                                    data.userPhoneNumber,
                                                description ?? data.description,
                                                imgName ?? data.imageName,
                                                imageExtention ??
                                                    data.imageExtention,
                                                imgUrl ?? data.imageUrl,
                                              );
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
                                                        "Your event is Successfully updated!",
                                                    style: AlertStyle(
                                                        backgroundColor:
                                                            Colors.black,
                                                        alertBorder:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
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
                                                                fontSize: 20),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            RequestHistory()));
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
                              SizedBox(height: 10)
                            ],
                          );
                        }
                      })))),
    );
  }

  Widget _hospitalDetails(BuildContext context, String gethospitalName) {
    final HospitalDetailsServices _hospitalDetailsServices =
        Provider.of<HospitalDetailsServices>(context);
    return FutureBuilder(
        future: _hospitalDetailsServices.getHospitals(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading..");
          } else {
            List<HospitalListModel> hospitalItems = snapshot.data;
            List<DropdownMenuItem> dropDownItems = [];
            for (int i = 0; i < hospitalItems.length; i++) {
              dropDownItems.add(DropdownMenuItem(
                child: Text(hospitalItems[i].bloodBankName),
                value: "${hospitalItems[i].bloodBankName}",
              ));
            }
            return Column(children: <Widget>[
              Card(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                child: ListTile(
                  title: Text(
                    "Near by Hospital Name",
                    style: TextStyle(color: Colors.black45),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4, left: 2),
                    child: DropdownButtonFormField(
                      value: gethospitalName,
                      decoration: InputDecoration(
                          hintText: 'Select a Hospital ',
                          hintStyle: TextStyle(
                              fontSize: 16.0,
                              fontFamily: "Roboto",
                              color: Colors.black54),
                          enabledBorder: InputBorder.none),
                      validator: (value) =>
                          value == null ? 'field required' : null,
                      items: dropDownItems,
                      onChanged: (hospitalValue) {
                        print(hospitalValue);
                        final snackBar = SnackBar(
                          content: Text('Selected Hospital is $hospitalValue',
                              style: TextStyle(color: Colors.blueGrey)),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);

                        for (var i = 0; i < hospitalItems.length; i++) {
                          if (hospitalValue == hospitalItems[i].bloodBankName) {
                            addressController.text =
                                hospitalItems[i].bloodBankAddress;
                            hospitalLat = hospitalItems[i].hospitalLatitude;
                            hospitalLng = hospitalItems[i].hospitalLongitude;

                            //assign to parameters of CreatePostView class
                            hospitalAddress = addressController.text;
                            // hospitalLat = addressLatController.text;
                            // hospitalLng = addressLngController.text;
                          }
                        }
                        setState(() {
                          // selectedHospital = hospitalValue;
                          hospitalName = hospitalValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                child: ListTile(
                  title: Text(
                    "Near by Hospital Address",
                    style: TextStyle(color: Colors.black45),
                  ),
                  subtitle: TextFormField(
                    controller: addressController,
                    enabled: false,
                    decoration: InputDecoration(
                        filled: false,
                        hintText: "Choose the hospital first",
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Roboto",
                        ),
                        enabledBorder: InputBorder.none),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
            ]);
          }
        });
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

  String validateFormDescription(String value) {
    if (value.length == 0) {
      return "This feild is required ";
    }
    return null;
  }

  String validateDropdowns(String value) {
    if (value == "Select a Type") {
      return 'This should be selected';
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

  String validateBloodUnit(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'This feild is requried!!';
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
