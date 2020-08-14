import 'dart:async';

import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:blood_collector/shared/decoration_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditUserAddressView extends StatefulWidget {
  @override
  _EditUserAddressViewwState createState() => _EditUserAddressViewwState();
}

class _EditUserAddressViewwState extends State<EditUserAddressView> {
  final _formKey = GlobalKey<FormState>();
  DateFormat format = DateFormat('yyy-MMM-dd');

  bool _formValidate = false;
  bool _isLoading = false;
  String _errorMessage;

  String address;
  String userAddLat;
  String userAddLng;

  LatLng _markerLocation;

  TextEditingController _userAddressController = TextEditingController();

  //import fluttertoast pub dev package - 5sec toast
  void showToastError() {
    Fluttertoast.showToast(
        msg: "Please, pin a place!!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.grey[200],
        textColor: Colors.red);
  }

  Widget _googleMapModal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 35.0),
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
        _userAddressController.text = addresses.first.addressLine;
        address = _userAddressController.text;
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
                              userAddLat = _markerLocation.latitude.toString();
                              userAddLng = _markerLocation.longitude.toString();
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

  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);
    final UserService _authService = Provider.of<UserService>(context);

    return Scaffold(
        appBar: AppBar(
          actionsIconTheme: null,
          title: Text("Edit Email Address"),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: [
          Form(
            key: _formKey,
            autovalidate: _formValidate,
            child: Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListTile(
                    title: Text(
                      "Select your Address",
                      style: TextStyle(color: Colors.black45),
                    ),
                    subtitle: TextFormField(
                      controller: _userAddressController,
                      decoration: InputDecoration(
                          // hintText: " Address",
                          hintStyle: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "Roboto",
                          ),
                          enabledBorder: InputBorder.none),
                      // validator: validateEmailAddress,
                    ),
                  ),
                ),
                _googleMapModal(),
                SizedBox(height: 15.0),
                Container(
                    width: double.infinity,
                    height: 58,
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
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
                                borderRadius: BorderRadius.circular(25.5)),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _userService.updateUserAddress(
                                    _userAddressController.text,
                                    userAddLat,
                                    userAddLng);
                                Navigator.pop(context);
                              }
                            }))),
                SizedBox(height: 20.0),
              ],
            ),
          )
        ]))));
  }
}
