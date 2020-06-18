// import 'package:blood_collector/UI/widgets/post_view.dart';
import 'dart:async';
import 'package:blood_collector/UI/pages/rootPages/create_post_view.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:blood_collector/shared/constant.dart';
import 'package:flutter/material.dart';
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
  List<Marker> myMarker = [];

  DateTime currentDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String birthDate = "";
  int eventTime;

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

  Widget _companyNameField() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: <Widget>[
              Text(
                "Name of the comapany",
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

              // validator: (value) => value.isEmpty ? ' cannot be blank' : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateField() {
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
          height: 58,
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 25, right: 16),
            child: TextFormField(
              controller: _campaignDate,
              decoration: inputDecoration.copyWith(
                  hintText: "Date Of Birth",
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  )),
              // keyboardType: TextInputType.datetime,
              validator: (value) =>
                  value.isEmpty ? 'Name should be filled' : null,

              onTap: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectBDate(context, _campaignDate);
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
                    validator: (DateTime dateTime) {
                      if (dateTime == null) {
                        return "Date Time Required";
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
                      validator: (DateTime dateTime) {
                        if (dateTime == null) {
                          return "Date Time Required";
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
              validator: (value) => value.isEmpty ? ' cannot be blank' : null,
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
              decoration: InputDecoration(
                  hintText: "eg: Sirisena Sahanayake Grounds",
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Roboto",
                  ),
                  enabledBorder: InputBorder.none),
              validator: (value) => value.isEmpty ? ' cannot be blank' : null,
            ),
          ),
        ),
      ],
    );
  }
  // Widget _googleMapModal() {
  //   return Padding(
  //     padding: const EdgeInsets.only(right:15),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Hero(
  //             tag: "myMap",
  //             child: Container(child: FlatButton(
  //               color: Colors.red,
  //               onPressed: () {
  //               Navigator.of(context).push(PageRouteBuilder(
  //                 pageBuilder: (context, animation, secondaryAnimation) =>
  //                     HeroCampaignDetails(),
  //                 transitionsBuilder:
  //                     (context, animation, secondaryAnimation, child) {
  //                   return child;
  //                 },
  //               ));
  //             },
  //             child: Text("Select From Map"),))),
  //       ],
  //     ),
  //   );
  // }

  Widget _nearestBloodBankTextField() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: <Widget>[
              Text(
                "Nearest Blood Bank",
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
                  hintText: "Narahanpitiya Blood bank",
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Roboto",
                  ),
                  enabledBorder: InputBorder.none),
              validator: (value) => value.isEmpty ? ' cannot be blank' : null,
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
              validator: (value) => value.isEmpty || (value.length != 10)
                  ? 'Mobile No should be filled'
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  // child: Stack(
  //   children: [
  //     Container(
  //         width: 500,
  //         height: 150,
  //         child: GoogleMap(
  //           padding: EdgeInsets.all(0),
  //           myLocationEnabled: true,
  //           initialCameraPosition: CameraPosition(
  //               target: LatLng(6.927079, 79.861244), zoom: 19),
  //         )),
  //   ],
  // )

  Widget _googleMapModal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: FlatButton(
              color: Colors.blueAccent[200],
              child: Text("Choose From Map"),
              onPressed: () => _mapdialogContent(context)),
        ),
      ],
    );
  }

  void _mapdialogContent(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //build a statefulbuilder to run the setState
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                child: Stack(children: <Widget>[
                  GoogleMap(
                    markers: Set.from(myMarker),
                    initialCameraPosition: CameraPosition(
                        target: LatLng(6.927079, 79.861244), zoom: 18),
                    onTap: (tappedPoint) {
                      setState(() {
                        myMarker = [];
                        myMarker.add(Marker(
                            markerId: MarkerId(tappedPoint.toString()),
                            position: tappedPoint));
                      });
                    },
                  ),
                ]));
          });
        });
  }

  void _submitTheForm() {
    final _form = _formKey.currentState;
    if (_form.validate()) {
      print('Form is vaild');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreatePostView()),
      );
    } else {
      print('Form is invaild');
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
            key: _formKey,
            child: Column(
              children: <Widget>[
                _companyNameField(),
                SizedBox(
                  height: 10.0,
                ),
                _dateField(),
                SizedBox(
                  height: 10.0,
                ),
                _timePicker(),
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
                  height: 10.0,
                ),
                _nearestBloodBankTextField(),
                SizedBox(
                  height: 10.0,
                ),
                _conatctTextFeild(),
                SizedBox(
                  height: 120.0,
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

  Future<Null> _selectBDate(context, ctrl) async {
    DateFormat dateFormat = DateFormat('yyyy-MMM-dd');
    DateTime _selectedBDate =
        ctrl.text != "" ? dateFormat.parse(ctrl.text) : DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedBDate,
        firstDate: DateTime(1960, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedBDate)
      ctrl.text = DateFormat('yyyy-MMM-dd').format(picked);
    setState(() {
      birthDate = ctrl.text;
    });
  }
}

//   void _mapdialogContent(BuildContext context) {

//     LatLng _markerLocation;
//      showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//               elevation: 0.0,
//               backgroundColor: Colors.transparent,
//               child: Stack(children: <Widget>[
//                 GoogleMap(
//                   markers: _markerLocation != null
//                       ? [
//                           Marker(
//                               markerId: MarkerId("1"),
//                               position: _markerLocation),
//                         ].toSet()
//                       : null,
//                   initialCameraPosition: CameraPosition(
//                       target: LatLng(6.927079, 79.861244), zoom: 18),
//                   onTap: (position) {
//                     setState(() {
//                       _markerLocation = position;
//                     });
//                   },
//                 ),
//               ]));
//         });
//   }
// }

// Future<Null> _selectTime( context, ctrl) async {

//   //  DateTime _selectedTime =
//   //     ctrl.text != "" ? dateFormat.parse(ctrl.text) : DateTime.now();
//   TimeOfDay picked = await showTimePicker(context: context, initialTime: currentTime);

//   if(picked != null && picked != currentTime){
//     print(picked);
//     // ctrl.text = DateFormat('h:mm a').format(context);

//     ctrl.text = picked.toString();
//     // ctrl.text = DateFormat("h:mm a").format(picked);
//     setState(() {
//       currentTime =  picked;
//       print(currentTime);
//     });
//   }
// }
