// import 'package:blood_collector/UI/widgets/post_view.dart';
import 'dart:async';
import 'package:blood_collector/UI/pages/rootPages/create_post_view.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:blood_collector/shared/decoration_constant.dart';
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

  TextEditingController _campaignDate = TextEditingController();
  TextEditingController _placeAddressController = TextEditingController();

  List<Marker> myMarker = [];
  String nameOfTheOrOrganizer;
  LatLng _markerLocation;
  // String _resultAddress;
  DateTime currentDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String pickUpDate = "";
  String startTime;
  String endTime;
  String oragnizePlaceName;
  String organizePlaceAddress;
  String placeLat;
  String placeLng;
  String organizerPhoneNumber;
  int eventTime;
  bool _formValidate = false;

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

//import fluttertoast pub dev package - 5sec toast
  void showToastError() {
    Fluttertoast.showToast(
        msg: "Please, pin a place!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.grey[200],
        textColor: Colors.red);
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
            child: TextFormField(
              controller: _campaignDate,
              decoration: inputDecoration.copyWith(
                  hintText: "Live TIll",
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  )),
              validator: (value) =>
                  value.isEmpty ? 'Request Closing Date is required' : null,
              onTap: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectDate(context, _campaignDate);
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
                        String formattedTime = DateFormat.Hms().format(val);
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
                        setState(() {
                          String formattedTime = DateFormat.Hms().format(val);
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
              enabled: false,
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
            ),
          ),
        ),
      ],
    );
  }

  Widget _googleMapModal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: FlatButton(
              color: Colors.blueAccent[200],
              child: Text("Choose From Map"),
              onPressed: () {
                _mapdialogContent(context);
              }),
        ),
      ],
    );
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

  void _submitTheForm() {
    final _form = _formKey.currentState;
    if (_form.validate()) {
      print('Form is vaild');
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => CreatePostView(
          nameOfTheOrganizer: nameOfTheOrOrganizer,
          pickUpDate: pickUpDate,
          startTime: startTime,
          endTime: endTime,
          placeName: oragnizePlaceName,
          placeAddress: organizePlaceAddress,
          placeLat: placeLat,
          placeLng: placeLng,
          orgernizerConatctNo: organizerPhoneNumber,
        ),
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
                _placeNameTextField(),
                SizedBox(
                  height: 10.0,
                ),
                _placeAddressTextField(),
                SizedBox(
                  height: 10.0,
                ),
                _googleMapModal(),
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
                          borderRadius: BorderRadius.circular(25.5)),
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

  Future<Null> _selectDate(context, ctrl) async {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateTime _selectedDate =
        ctrl.text != "" ? dateFormat.parse(ctrl.text) : DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate)
      ctrl.text = DateFormat('yyyy-MM-dd').format(picked);
    setState(() {
      pickUpDate = ctrl.text;
    });
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
}

//A collection of objects in which each object can occur only once.

// That is, for each object of the element type, the object is either considered to be in the set, or to not be in the set.
