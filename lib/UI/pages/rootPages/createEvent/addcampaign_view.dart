//librarys
import 'dart:async';
//pages
import 'package:blood_collector/UI/pages/rootPages/createEvent/create_post_view.dart';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class AddCampaignsView extends StatefulWidget {
  @override
  _AddCampaignsViewState createState() => _AddCampaignsViewState();
}

class _AddCampaignsViewState extends State<AddCampaignsView> {
  final _formKey = GlobalKey<FormState>();
  final format = DateFormat("HH:mm");
  final dateFormat = DateFormat("yyyy-MM-dd");

  TextEditingController _placeAddressController = TextEditingController();
  TextEditingController _requestCloseDate = TextEditingController();

  List<Marker> myMarker = [];
  String nameOfTheOrOrganizer;

  DateTime currentDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String pickUpStartDate;
  String pickUpEndDate;
  String startTime;
  String endTime;
  String oragnizePlaceName;
  String organizePlaceAddress;
  String placeLat;
  String placeLng;
  String organizerPhoneNumber;
  Timestamp requestCloseOn;
  String districts;
  String area;
  int eventTime;
  String _districts = 'Select districts';
  String _area = 'Select a area';
  bool _formValidate = false;
  bool _visibleState = false;

  List<String> _districtTypes = [
    "Select districts",
    "Colombo",
    'Kandy',
  ];

  List<String> _colomboArea = [
    "Select a area",
    "Piliyandala",
    'Nugegoda',
    'Dehiwala',
    'Maharagama',
    'Colombo 6',
  ];
  List<String> _kandyArea = [
    "Select a area",
    "Piliyandala",
    'Nugegoda',
    'Dehiwala',
    'Maharagama',
    'Colombo 6',
  ];

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(3, 6)) //BoxShadow
        ]);
  }

  void selectDistrictsType(String value) {
    setState(() {
      _districts = value;
    });
  }

  void selectAreaType(String value) {
    setState(() {
      _area = value;
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

//get lat and lng from the address
  getAddressLatLng(getAddress) async {
    final addresses = await Geocoder.local.findAddressesFromQuery(getAddress);
    var value = addresses.first;
    setState(() {
      placeLat = value.coordinates.latitude.toString();
      placeLng = value.coordinates.longitude.toString();
    });
  }

  Widget _districtsTextField() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: <Widget>[
              Text(
                "Choose the district and its area",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Container(
                width: double.infinity,
                height: 68,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: _boxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 7, left: 24, right: 16),
                  child: DropdownButtonFormField(
                    value: _districts,
                    decoration: InputDecoration(
                        hintText: 'Select a districts',
                        hintStyle:
                            TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                        enabledBorder: InputBorder.none),
                    validator: validateDistricts,
                    onChanged: (value) {
                      selectDistrictsType(value);
                      setState(() {
                        districts = value;
                        print(districts);
                      });
                    },
                    items: _districtTypes.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                width: double.infinity,
                height: 68,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: _boxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 7, left: 24, right: 16),
                  child: DropdownButtonFormField(
                      value: _area,
                      decoration: InputDecoration(
                          hintText: 'Area',
                          hintStyle:
                              TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                          enabledBorder: InputBorder.none),
                      validator: validateAreaSelection,
                      onChanged: (value) {
                        selectAreaType(value);
                        setState(() {
                          area = value;
                        });
                      },
                      items: _lists()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<dynamic> _lists() {
    return _switchList();
  }

  _switchList() {
    switch (districts) {
      case "Colombo":
        return _colomboArea.map((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList();
      case "Kandy":
        return _kandyArea.map((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList();
        break;
      default:
    }
  }

  Widget _companyNameField() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: <Widget>[
              Text(
                "Name of the organizer/organization",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          width: double.infinity,
          height: 58,
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Leo Club- Battrammulla",
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Roboto",
                  ),
                  enabledBorder: InputBorder.none),
              validator: validateTextFeild,
              onChanged: (val) {
                setState(() {
                  nameOfTheOrOrganizer = val;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _pickUpDateField() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: <Widget>[
              Text(
                "Pick up a date",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          width: double.infinity,
          height: 48,
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 25, right: 16),
            child: DateTimeField(
              format: dateFormat,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  ),
                  hintText: "Start Date"),
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    // from todays date subtract the pass dates so that it will show only future days
                    firstDate: DateTime.now().subtract(Duration(days: 0)),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
              validator: dateTimeValidator,
              onChanged: (value) {
                setState(() {
                  pickUpStartDate = DateFormat('yyyy-MM-dd').format(value);
                  print(pickUpStartDate);
                  // pickUpStartDate = value.toString();
                });
              },
            ),
          ),
        ),
        // Container(
        //   width: double.infinity,
        //   height: 48,
        //   margin: EdgeInsets.symmetric(horizontal: 15.0),
        //   decoration: _boxDecoration(),
        //   child: Padding(
        //     padding: const EdgeInsets.only(top: 4, left: 25, right: 16),
        //     child: TextFormField(
        //       controller: _campaignStartDate,
        //       decoration: inputDecoration.copyWith(
        //           hintText: "Start Date",
        //           suffixIcon: Icon(
        //             Icons.calendar_today,
        //             color: Colors.black,
        //           )),
        //       validator: (value) =>
        //           value.isEmpty ? 'Request Closing Date is required' : null,
        //       onTap: () async {
        //         FocusScope.of(context).requestFocus(new FocusNode());
        //         _selectDate(context, _campaignStartDate);
        //       },
        //     ),
        //   ),
        // ),
        SizedBox(height: 10),
        Center(child: Text("TO")),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 48,
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 25, right: 16),
            child: DateTimeField(
              format: dateFormat,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.black),
                  hintText: "End Date"),
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(Duration(days: 0)),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
              validator: dateTimeValidator,
              onChanged: (value) {
                setState(() {
                  pickUpEndDate = DateFormat('yyyy-MM-dd').format(value);

                  DateTime nextDay = value.add(Duration(days: 1));
                  String requestCloseOnDate =
                      DateFormat('yyyy-MM-dd').format(nextDay);
                  _requestCloseDate.text = requestCloseOnDate;
                  requestCloseOn = requestCloseOn = Timestamp.fromDate(nextDay);
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _timePicker() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: <Widget>[
              Text(
                "Time",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                width: double.infinity,
                height: 58,
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                decoration: _boxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
                  child: DateTimeField(
                    format: format,
                    decoration: InputDecoration(
                        labelText: 'Start time',
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.alarm,
                          color: Colors.black,
                        )),
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.convert(time);
                    },
                    onChanged: (val) {
                      setState(() {
                        String formattedTime = DateFormat.jm().format(val);

                        startTime = formattedTime;
                      });
                    },
                    validator: (DateTime dateTime) {
                      if (dateTime == null) {
                        return "Date Start Time Required";
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                width: double.infinity,
                height: 58,
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                decoration: _boxDecoration(),
                child: Padding(
                    padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
                    child: DateTimeField(
                      format: format,
                      decoration: InputDecoration(
                          labelText: 'End time',
                          border: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.alarm,
                            color: Colors.black,
                          )),
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.convert(time);
                      },
                      onChanged: (val) {
                        print(val);
                        setState(() {
                          String formattedTime = DateFormat.jm().format(val);
                          endTime = formattedTime;
                        });
                      },
                      validator: (DateTime dateTime) {
                        if (dateTime == null) {
                          return "Date End Time Required";
                        }
                        return null;
                      },
                    )),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _requestCloseDateTxtField() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: <Widget>[
              Text(
                "Request Close On",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          width: double.infinity,
          height: 48,
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: _boxDecoration(),
          child: Padding(
              padding: const EdgeInsets.only(top: 4, left: 25, right: 16),
              child: TextFormField(
                enabled: false,
                controller: _requestCloseDate,
                decoration: InputDecoration(
                    errorStyle: TextStyle(color: Theme.of(context).errorColor),
                    hintText: "Request Close date",
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Roboto",
                    ),
                    enabledBorder: InputBorder.none),
              )
              // child: DateTimeField(
              //   format: dateFormat,
              //   decoration: InputDecoration(
              //       border: InputBorder.none,
              //       suffixIcon: Icon(Icons.calendar_today, color: Colors.black),
              //       hintText: "Event Closing Date"),
              //   onShowPicker: (context, currentValue) {
              //     return showDatePicker(
              //         context: context,
              //         firstDate: DateTime.now().subtract(Duration(days: 0)),
              //         initialDate: currentValue ?? DateTime.now(),
              //         lastDate: DateTime(2100));
              //   },
              //   validator: dateTimeValidator,
              //   onChanged: (value) {
              //     setState(() {
              //       requestCloseOn = Timestamp.fromDate(value);
              //       print(requestCloseOn);
              //       // requestCloseOn = DateFormat('yyyy-MM-dd').format(value);
              //     });
              //   },
              // ),
              ),
        ),
      ],
    );
  }

  Widget _placeNameTextField() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: <Widget>[
              Text(
                "Place Name",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          width: double.infinity,
          height: 58,
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "eg: Sirisena Sahanayake Grounds",
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Roboto",
                  ),
                  enabledBorder: InputBorder.none),
              validator: validateTextFeild,
              onChanged: (val) {
                oragnizePlaceName = val;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeAddressTextField() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: <Widget>[
              Text(
                "Place Address",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          width: double.infinity,
          height: 58,
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: TextFormField(
              // enabled: false,
              controller: _placeAddressController,
              decoration: InputDecoration(
                  errorStyle: TextStyle(color: Theme.of(context).errorColor),
                  hintText: "eg:15/8, Sirisena Rad, Dehiwala",
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Roboto",
                  ),
                  enabledBorder: InputBorder.none),
              validator: (value) =>
                  value.isEmpty ? ' Select from the map' : null,
              onChanged: (value) {
                organizePlaceAddress = value;

                getAddressLatLng(organizePlaceAddress);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _conatctTextFeild() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: <Widget>[
              Text(
                "Conatct details",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          width: double.infinity,
          height: 58,
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Mobile No:",
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Roboto",
                  ),
                  enabledBorder: InputBorder.none),
              keyboardType: TextInputType.phone,
              validator: validateMobile,
              onChanged: (value) {
                organizerPhoneNumber = value;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _visibleContactNumberToPubic() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  "Do you like to visible the Conatact Number to Public",
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
            width: double.infinity,
            height: 58,
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: CheckboxListTile(
              title: Text("Yes, visible it"),
              value: _visibleState,
              onChanged: (value) {
                setState(() {
                  _visibleState = value;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            )),
      ],
    );
  }

  void _submitTheForm() {
    final _form = _formKey.currentState;
    //get latitude and longtitude vlues from address

    if (_form.validate()) {
      print('Form is vaild');

      var route = new MaterialPageRoute(
        builder: (BuildContext context) => CreatePostView(
            nameOfTheOrganizer: nameOfTheOrOrganizer,
            pickUpStartDate: pickUpStartDate,
            pickUpEndDate: pickUpEndDate,
            requestClose: requestCloseOn,
            startTime: startTime,
            endTime: endTime,
            placeName: oragnizePlaceName,
            placeAddress: organizePlaceAddress,
            placeLat: placeLat,
            placeLng: placeLng,
            orgernizerConatctNo: organizerPhoneNumber,
            visibleState: _visibleState,
            districts: districts,
            area: area),
      );
      Navigator.of(context).push(route);
    } else {
      print('Form is invaild');
      setState(() {
        _formValidate = true;
      });
    }
    _formKey.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: SingleChildScrollView(
          child: Form(
            autovalidate: _formValidate,
            key: _formKey,
            child: Column(
              children: <Widget>[
                _companyNameField(),
                SizedBox(
                  height: 10.0,
                ),
                _pickUpDateField(),
                SizedBox(
                  height: 10.0,
                ),
                _timePicker(),
                SizedBox(
                  height: 10.0,
                ),
                _conatctTextFeild(),
                SizedBox(
                  height: 10.0,
                ),
                _visibleContactNumberToPubic(),
                SizedBox(
                  height: 10.0,
                ),
                _districtsTextField(),
                SizedBox(
                  height: 10.0,
                ),
                _placeNameTextField(),
                SizedBox(
                  height: 10.0,
                ),
                _placeAddressTextField(),
                SizedBox(
                  height: 10.0,
                ),
                // _googleMapModal(),
                SizedBox(
                  height: 10.0,
                ),
                _requestCloseDateTxtField(),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  width: double.infinity,
                  height: 58,
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: _boxDecoration(),
                  child: ButtonTheme(
                    // minWidth: 900,
                    child: RaisedButton(
                      elevation: 0.0,
                      child: Text("CONTINUE",
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 18.0,
                          )),
                      textColor: Colors.black,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(25.5),
                      ),
                      onPressed: () => _submitTheForm(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String validateTextFeild(String value) {
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

  String validateMobile(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(pattern);
    if (value.length != 10) {
      return 'Mobile Number must be of 10 digit';
    } else if (!regExp.hasMatch(value)) {
      return "It should be only 0-9 values!";
    }
    return null;
  }

  String validateDistricts(String value) {
    if (value == "Select districts") {
      return 'Please select a districts';
    }
    return null;
  }

  String validateAreaSelection(String value) {
    if (value == "Select a area") {
      return 'Please select an area';
    }
    return null;
  }
}

//A collection of objects in which each object can occur only once.

// That is, for each object of the element type, the object is either considered to be in the set, or to not be in the set.

// 'Galle',
// 'Ampara',
// 'Anuradhapura',
// 'Badulla',
// 'Batticaloa',
// 'Gampaha',
// 'Hambantota',
// 'Jaffna',
// 'Kalutara',
// 'Kegalle',
// 'Kilinochchi',
// 'Kurunegala',
// 'Mannar',
// 'Matara',
// 'Monaragala',
// 'Mullativu',
// 'Nuwara Eliya',
// 'Polonnaruwa',
// 'Puttalam',
// 'Ratnapura',
// 'Trincomalee',
// 'Vavuniya',
