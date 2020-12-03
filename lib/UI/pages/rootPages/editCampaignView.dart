//library
import 'dart:async';
import 'dart:io';

//pages
import 'package:blood_collector/UI/pages/rootPages/request_history.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/shared/decoration_constant.dart';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as Path;

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
  final timeFormat = DateFormat("HH:mm");

  File _image;
  LatLng _markerLocation;

  String description;
  String nameOfTheOrOrganizer;
  String organizerPhoneNumber;
  String pickUpStartDate;
  String pickUpEndDate;
  Timestamp requestCloseOn;
  String startTime;
  String endTime;
  String organizePlaceAddress;
  String organizePlaceName;
  String placeLat;
  String placeLng;
  String imgName = "";
  String imageExtention = "";
  String imgUrl = "";

  bool _formValidate = false;
  bool _isLoading = false;
  String _errorMessage;

  TextEditingController _placeAddressController = TextEditingController();

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
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        autovalidate: _formValidate,
                        child: FutureBuilder(
                            future: _eventServices.requestEventsDetails(docRef),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                EventModel data =
                                    EventModel.fromMap(snapshot.data.data);
                                return Column(children: <Widget>[
                                  Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: ListTile(
                                      title: Text(
                                        "Upload a image",
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                      subtitle: GestureDetector(
                                        child: _image == null
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: data.imageUrl == ""
                                                    ? DottedBorder(
                                                        color: Colors.black,
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 30,
                                                          right: 150,
                                                          bottom: 30,
                                                          left: 150,
                                                        ),
                                                        strokeWidth: 2,
                                                        radius:
                                                            Radius.circular(12),
                                                        dashPattern: [6, 6],
                                                        child: Icon(
                                                          Icons.backup,
                                                          size: 90,
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    : Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            50,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                image:
                                                                    DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
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
                                  ),
                                  SizedBox(height: 10),
                                  Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: ListTile(
                                      title: Text(
                                        "Description",
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4, left: 2),
                                        child: TextFormField(
                                          initialValue: data.description,
                                          minLines: 10,
                                          maxLines: 15,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Write your need her",
                                            filled: true,
                                            fillColor: Colors.white,
                                            // enabledBorder: OutlineInputBorder(
                                            //   borderRadius: BorderRadius.all(
                                            //       Radius.circular(10.0)),
                                            //   borderSide:
                                            //       BorderSide(color: Colors.grey),
                                            // ),
                                            // focusedBorder: OutlineInputBorder(
                                            //   borderRadius: BorderRadius.all(
                                            //       Radius.circular(10.0)),
                                            //   borderSide:
                                            //       BorderSide(color: Colors.grey),
                                            // ),
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
                                  Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: ListTile(
                                      title: Text(
                                        "Name of the organizer/organization",
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                      subtitle: TextFormField(
                                        initialValue: data.nameOftheOrganizer,
                                        decoration: InputDecoration(
                                            hintText: "Leo Club- Battrammulla",
                                            hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: "Roboto",
                                            ),
                                            border: InputBorder.none),
                                        validator: validateFormData,
                                        onChanged: (value) {
                                          setState(() {
                                            nameOfTheOrOrganizer = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: ListTile(
                                      title: Text(
                                        "Your Mobile Number",
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                      subtitle: TextFormField(
                                        initialValue: data.orgernizerConatctNo,
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
                                            organizerPhoneNumber = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: ListTile(
                                      title: Text(
                                        "Place Name",
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                      subtitle: TextFormField(
                                        initialValue: data.placeName,
                                        decoration: InputDecoration(
                                            hintText:
                                                "eg: Sirisena Sahanayake Grounds",
                                            hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: "Roboto",
                                            ),
                                            border: InputBorder.none),
                                        // validator: validateFormData,
                                        onTap: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             EditUserAddressView()));
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            organizePlaceName = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: ListTile(
                                      title: Text(
                                        "Place Address",
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                      subtitle: TextFormField(
                                        controller: _placeAddressController,
                                        // initialValue:organizePlaceAddress ?? data.placeAddress,
                                        decoration: InputDecoration(
                                            enabled: false,
                                            suffixIcon: Icon(Icons.arrow_right),
                                            hintText:
                                                "eg:15/8, Sirisena Rad, Dehiwala",
                                            hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: "Roboto",
                                            ),
                                            border: InputBorder.none),
                                        // validator: validateFormData,

                                        onChanged: (value) {
                                          setState(() {
                                            organizePlaceAddress = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        FlatButton(
                                            color: Colors.blueAccent[200],
                                            child: Text("Choose From Map"),
                                            onPressed: () {
                                              _mapdialogContent(context);
                                            }),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: ListTile(
                                        title: Text(
                                          "Pick Up dates",
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                        subtitle: Column(
                                          children: [
                                            DateTimeField(
                                              initialValue: format
                                                  .parse(data.pickUpStartDate),
                                              format: format,
                                              decoration: InputDecoration(
                                                  // border: InputBorder.none,
                                                  suffixIcon: Icon(
                                                    Icons.calendar_today,
                                                    color: Colors.black,
                                                  ),
                                                  hintText: "Start Date"),
                                              onShowPicker:
                                                  (context, currentValue) {
                                                return showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime.now()
                                                        .subtract(
                                                            Duration(days: 0)),
                                                    initialDate: currentValue ??
                                                        DateTime.now(),
                                                    lastDate: DateTime(2100));
                                              },
                                              validator: dateTimeValidator,
                                              onChanged: (value) {
                                                setState(() {
                                                  pickUpStartDate =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(value);
                                                  print(pickUpStartDate);
                                                  // pickUpStartDate = value.toString();
                                                });
                                              },
                                            ),
                                            SizedBox(height: 10),
                                            Center(child: Text("TO")),
                                            SizedBox(height: 10),
                                            DateTimeField(
                                              initialValue: format
                                                  .parse(data.pickUpEndDate),
                                              format: format,
                                              decoration: InputDecoration(
                                                  // border: InputBorder.none,
                                                  suffixIcon: Icon(
                                                      Icons.calendar_today,
                                                      color: Colors.black),
                                                  hintText: "End Date"),
                                              onShowPicker:
                                                  (context, currentValue) {
                                                return showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime.now()
                                                        .subtract(
                                                            Duration(days: 0)),
                                                    initialDate: currentValue ??
                                                        DateTime.now(),
                                                    lastDate: DateTime(2100));
                                              },
                                              validator: dateTimeValidator,
                                              onChanged: (value) {
                                                setState(() {
                                                  pickUpEndDate =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(value);
                                                });
                                              },
                                            ),
                                          ],
                                        )),
                                  ),
                                  SizedBox(height: 10),
                                  Card(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: ListTile(
                                          title: Text(
                                            "Time",
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                          subtitle: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: DateTimeField(
                                                      initialValue:
                                                          timeFormat.parse(
                                                              data.startTime),
                                                      format: timeFormat,
                                                      decoration:
                                                          InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              labelText:
                                                                  'Start time',
                                                              suffixIcon: Icon(
                                                                Icons.alarm,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                      onShowPicker: (context,
                                                          currentValue) async {
                                                        final time =
                                                            await showTimePicker(
                                                          context: context,
                                                          initialTime: TimeOfDay
                                                              .fromDateTime(
                                                                  currentValue ??
                                                                      DateTime
                                                                          .now()),
                                                        );
                                                        return DateTimeField
                                                            .convert(time);
                                                      },
                                                      onChanged: (val) {
                                                        setState(() {
                                                          String formattedTime =
                                                              DateFormat.Hms()
                                                                  .format(val);
                                                          startTime =
                                                              formattedTime;
                                                        });
                                                      },
                                                      validator:
                                                          (DateTime dateTime) {
                                                        if (dateTime == null) {
                                                          return "Date Start Time Required";
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: DateTimeField(
                                                      initialValue: timeFormat
                                                          .parse(data.endTime),
                                                      format: timeFormat,
                                                      decoration:
                                                          InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              labelText:
                                                                  'End time',
                                                              suffixIcon: Icon(
                                                                Icons.alarm,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                      onShowPicker: (context,
                                                          currentValue) async {
                                                        final time =
                                                            await showTimePicker(
                                                          context: context,
                                                          initialTime: TimeOfDay
                                                              .fromDateTime(
                                                                  currentValue ??
                                                                      DateTime
                                                                          .now()),
                                                        );
                                                        return DateTimeField
                                                            .convert(time);
                                                      },
                                                      onChanged: (val) {
                                                        setState(() {
                                                          String formattedTime =
                                                              DateFormat.Hms()
                                                                  .format(val);
                                                          endTime =
                                                              formattedTime;
                                                        });
                                                      },
                                                      validator:
                                                          (DateTime dateTime) {
                                                        if (dateTime == null) {
                                                          return "Date End Time Required";
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  )
                                                  // SizedBox(height: 10),
                                                ],
                                              ),
                                            ],
                                          ))),
                                  SizedBox(height: 10),
                                  Card(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: ListTile(
                                      title: Text(
                                        "Request Close On",
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                      subtitle: DateTimeField(
                                        // initialValue:format.parse(data.requestClose),
                                        initialValue:
                                            data.requestClose.toDate(),
                                        format: format,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            suffixIcon: Icon(
                                                Icons.calendar_today,
                                                color: Colors.black),
                                            hintText: "Event Closing Date"),
                                        onShowPicker: (context, currentValue) {
                                          return showDatePicker(
                                              context: context,
                                              firstDate: DateTime.now()
                                                  .subtract(Duration(days: 1)),
                                              initialDate: currentValue ??
                                                  DateTime.now(),
                                              lastDate: DateTime(2100));
                                        },
                                        validator: dateTimeValidator,
                                        onChanged: (value) {
                                          setState(() {
                                            requestCloseOn =
                                                Timestamp.fromDate(value);
                                            // requestCloseOn =
                                            //     DateFormat('yyyy-MM-dd')
                                            //         .format(value);
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
                                                  if (_image != null) {
                                                    imgName = Uuid().v1();
                                                    imageExtention =
                                                        Path.extension(
                                                            _image.path);
                                                    //upload image and get the url of the image
                                                    imgUrl =
                                                        await _eventServices
                                                            .uploadImage(
                                                                imgName,
                                                                imageExtention,
                                                                _image);
                                                  } else {
                                                    imgUrl = data.imageUrl;
                                                    imgName = data.imageName;
                                                    imageExtention =
                                                        data.imageExtention;
                                                  }

                                                  String response =
                                                      await _eventServices
                                                          .updateCampaignEvents(
                                                    docRef,
                                                    description ??
                                                        data.description,
                                                    imgName ?? data.imageName,
                                                    imageExtention ??
                                                        data.imageExtention,
                                                    imgUrl ?? data.imageUrl,
                                                    nameOfTheOrOrganizer ??
                                                        data.nameOftheOrganizer,
                                                    organizerPhoneNumber ??
                                                        data.orgernizerConatctNo,
                                                    organizePlaceName ??
                                                        data.placeName,
                                                    organizePlaceAddress ??
                                                        data.placeAddress,
                                                    placeLat ?? data.placeLat,
                                                    placeLng ?? data.placeLng,
                                                    pickUpStartDate ??
                                                        data.pickUpStartDate,
                                                    pickUpEndDate ??
                                                        data.pickUpEndDate,
                                                    startTime ?? data.startTime,
                                                    endTime ?? data.endTime,
                                                    requestCloseOn ??
                                                        data.requestClose,
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
                                                            alertBorder: RoundedRectangleBorder(
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
                                                                    fontSize:
                                                                        20),
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
                                ]);
                              }
                            }))))));
  }

//updating the current instance - buildcontext
  void _mapdialogContent(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();
    getSetAddress(Coordinates coordinates) async {
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      setState(() {
        // _resultAddress = addresses.first.addressLine;
        //get the selelcted position into textfeild
        _placeAddressController.text = addresses.first.addressLine;
        organizePlaceAddress = _placeAddressController.text;
      });
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          //build a statefulbuilder to run the setState
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                child: Stack(children: <Widget>[
                  GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: _markerLocation != null
                        ? [
                            Marker(
                                markerId: MarkerId("Tap Location"),
                                position: _markerLocation),
                          ].toSet()
                        : null,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(6.927079, 79.861244), zoom: 18),
                    onTap: (location) {
                      setState(() {
                        _markerLocation = location;
                      });
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton.icon(
                        label: Text("Selected Position"),
                        icon: Icon(Icons.location_on),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() {
                            if (_markerLocation != null) {
                              getSetAddress(Coordinates(
                                  _markerLocation.latitude,
                                  _markerLocation.longitude));
                              Navigator.of(context).pop();
                              placeLat = _markerLocation.latitude.toString();
                              placeLng = _markerLocation.longitude.toString();
                            } else {
                              showToastError();
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 5.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.5),
                            child: Icon(Icons.close,
                                size: 25.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]));
          });
        });
  }

  //import fluttertoast pub dev package - 5sec toast
  void showToastError() {
    Fluttertoast.showToast(
        msg: "Please, pin a place!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.grey[200],
        textColor: Colors.red);
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

  String dateTimeValidator(DateTime dateTime) {
    if (dateTime == null) {
      return "Date Time Required";
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
