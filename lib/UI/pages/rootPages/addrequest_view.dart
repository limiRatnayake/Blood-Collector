import 'package:blood_collector/UI/pages/rootPages/create_post_view.dart';
import 'package:blood_collector/models/hospital_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/hospital_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:blood_collector/shared/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RequestBloodView extends StatefulWidget {
  @override
  _RequestBloodViewState createState() => _RequestBloodViewState();
}

class _RequestBloodViewState extends State<RequestBloodView> {
  var selectedType;
  final _formKey = GlobalKey<FormState>();
  List<String> _bloodGroupType = [
    "Select Blood Type",
    'A+',
    'O+',
    'B+',
    'AB+',
    'A-',
    'O-',
    'B-',
    'AB-'
  ];
  TextEditingController addressController = new TextEditingController();
  TextEditingController addressLatController = new TextEditingController();
  TextEditingController addressLngController = new TextEditingController();
  TextEditingController userFNameController = new TextEditingController();
  TextEditingController userLNameController = new TextEditingController();
  TextEditingController userPhoneNoController = new TextEditingController();
  TextEditingController _campaignDate = TextEditingController();

  String bloodGroup = '';
  String replacementAvailability = "";
  String unitsOfBlood = '';
  String requestClose = '';
  String hospitalName = '';
  String hospitalAddress = '';
  String hospitalLat = '';
  String hospitalLng = '';
  String userFName = '';
  String userLName = '';
  String userPhoneNumber = '';
   String birthDate = "";
  bool notifyState;

  var selectedHospital;
  bool _notifyState = false;
  int _radioValue = 1;
  String _bloodGroup = 'Select Blood Type';
  bool _formValidate = false;
  String _radioItemHolder = "Yes";

  void selectBloodType(String value) {
    setState(() {
      _bloodGroup = value;
    });
  }

  @override
  initState() {
    setState(() {
      replacementAvailability = _radioItemHolder;
    });
    super.initState();
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(3, 6)),
          //BoxShadow
        ]);
  }

  List<AvailabilityList> radioButtonList = [
    AvailabilityList(index: 1, title: "Yes"),
    AvailabilityList(index: 2, title: "No")
  ];

  Widget _bloodGroupTextField() {
    return Container(
      width: double.infinity,
      height: 68,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 7, left: 24, right: 16),
        child: DropdownButtonFormField(
          value: _bloodGroup,
          decoration: InputDecoration(
              hintText: 'Blood Type',
              hintStyle: TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
              enabledBorder: InputBorder.none),
          validator: validateBloodGroup,
          onChanged: (value) {
            selectBloodType(value);
            setState(() {
              bloodGroup = value;
            });
          },
          items: _bloodGroupType.map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _replacementTextField() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
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
                                  replacementAvailability = val;
                                });
                              }))
                          .toList())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _unitOfBloodTextField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: "1",
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
    );
  }

  Widget _availableDateTextField() {
    return Container(
      width: double.infinity,
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 25, right: 16),
        child: TextFormField(
          controller: _campaignDate,
          decoration: inputDecoration.copyWith(
              hintText: "Event date",
              suffixIcon: Icon(
                Icons.calendar_today,
                color: Colors.black,
              )),
          validator: (value) => value.isEmpty ? 'Event date is required' : null,
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectDate(context, _campaignDate);
          },
        ),
      ),
    );
  }

  Widget _userFNameDeatils() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          controller: userFNameController,
          decoration: InputDecoration(
              hintText: "First Name",
              hintStyle: TextStyle(
                fontSize: 16.0,
                fontFamily: "Roboto",
              ),
              enabledBorder: InputBorder.none),
          validator: validateFormData,
          onChanged: (value) {
            value = userFNameController.text;
            userFName = value;
          },
        ),
      ),
    );
  }

  Widget _userLNameDeatils() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          controller: userLNameController,
          decoration: InputDecoration(
              hintText: "Last Name",
              hintStyle: TextStyle(
                fontSize: 16.0,
                fontFamily: "Roboto",
              ),
              enabledBorder: InputBorder.none),
          validator: validateFormData,
          onChanged: (value) {
            value = userLNameController.text;
            userLName = value;
          },
        ),
      ),
    );
  }

  Widget _userPhoneNumber() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          controller: userPhoneNoController,
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
            value = userPhoneNoController.text;
            userPhoneNumber = value;
          },
        ),
      ),
    );
  }

  Widget _notifyUrbansCheckList() {
    return Container(
        width: double.infinity,
        height: 58,
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        child: CheckboxListTile(
          title: Text("Yes, notify them"),
          value: _notifyState,
          onChanged: (value) {
            setState(() {
              _notifyState = value;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ));
  }

  void _submitTheForm() {
    final _form = _formKey.currentState;
    if (_form.validate()) {
      if (_radioValue < 0) {
        print("Hello error");
      }
      print('Form is vaild');
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => CreatePostView(
          bloodGroup: bloodGroup,
          replacementAvailability: replacementAvailability,
          unitsOfBlood: unitsOfBlood,
          requestClose: requestClose,
          hospitalName: hospitalName,
          hospitalAddress: hospitalAddress,
          hospitalLat: hospitalLat,
          hospitalLng: hospitalLng,
          userFName: userFName,
          userLName: userLName,
          userPhoneNumber: userPhoneNumber,
          notifyState: _notifyState,
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
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidate: _formValidate,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Blood group that you are looking for?",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                _bloodGroupTextField(),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Is replacement available at hospital?",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                _replacementTextField(),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "How many units of blood you need?",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                _unitOfBloodTextField(),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Your request will close on this date.",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                 SizedBox(
                  height: 10.0,
                ),
                _availableDateTextField(),
                SizedBox(
                  height: 10.0,
                ),
                Divider(
                  height: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "Hospital Name & Address will help Blood Donors to navigate easily",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16.0,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                _hospitalDetails(context),
                Divider(
                  height: 50.0,
                ),
                _userDetailsBuilder(context),
                SizedBox(
                  height: 10.0,
                ),
                Divider(
                  height: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "Do you want to send notification to the people around your area?",
                          style:
                              TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                _notifyUrbansCheckList(),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  height: 58,
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: _boxDecoration(),
                  child: ButtonTheme(
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
                      onPressed: () {
                        _submitTheForm();
                      },
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

  Widget _hospitalDetails(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Near by Hospital Name",
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                decoration: _boxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 7, left: 24, right: 16),
                  child: DropdownButtonFormField(
                    items: dropDownItems,
                    validator: (value) =>
                        value == null ? 'field required' : null,
                    decoration: InputDecoration(
                      hintText: 'Select a Hospital ',
                      hintStyle:
                          TextStyle(fontSize: 16.0, fontFamily: "Roboto"),
                      enabledBorder: InputBorder.none,
                    ),
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
                          hospitalLat =
                              hospitalItems[i].hospitalLatitude;
                           hospitalLng =
                              hospitalItems[i].hospitalLongitude;

                          //assign to parameters of CreatePostView class
                          hospitalAddress = addressController.text;
                          // hospitalLat = addressLatController.text;
                          // hospitalLng = addressLngController.text;
                        }
                      }
                      setState(() {
                        selectedHospital = hospitalValue;
                        hospitalName = selectedHospital;
                      });
                    },
                    value: selectedHospital,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Near by Hospital Address",
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 58,
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                decoration: _boxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
                  child: TextFormField(
                    controller: addressController,
                    enabled: false,
                    decoration: InputDecoration(
                        filled: false,
                        labelText: 'Hospital Address',
                        hintText: "Hospital Address",
                        disabledBorder: InputBorder.none),
                  ),
                ),
              ),
            ]);
          }
        });
  }

  Widget _userDetailsBuilder(BuildContext context) {
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
            userFName = userFNameController.text;
            userLNameController.text = data.lastName;
            userLName = userLNameController.text;
            userPhoneNoController.text = data.mobileNo;
            userPhoneNumber = userPhoneNoController.text;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "Your contacts details",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16.0,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Your First Name",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                _userFNameDeatils(),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Your Last Name",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                _userLNameDeatils(),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Your Mobile Number ",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                _userPhoneNumber()
              ],
            );
          }
        });
  }

  String validateBloodGroup(String value) {
    if (value == "Select Blood Type") {
      return 'Blood Type should be selected';
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

   Future<Null> _selectDate(context, ctrl) async {
    DateFormat dateFormat = DateFormat('yyyy-MMM-dd');
    DateTime _selectedBDate =
        ctrl.text != "" ? dateFormat.parse(ctrl.text) : DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedBDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedBDate)
      ctrl.text = DateFormat('yyyy-MMM-dd').format(picked);
    setState(() {
      birthDate = ctrl.text;
    });
  }
}

class AvailabilityList {
  String title;
  int index;
  AvailabilityList({this.title, this.index});
}
