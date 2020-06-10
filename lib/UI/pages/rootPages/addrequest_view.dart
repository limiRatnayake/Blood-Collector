import 'package:blood_collector/UI/pages/rootPages/addpost_view.dart';
import 'package:blood_collector/models/hospital_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/hospital_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  TextEditingController userFNameController = new TextEditingController();
  TextEditingController userLNameController = new TextEditingController();
  TextEditingController userPhoneNoController = new TextEditingController();

  String bloodGroup = '';
  var selectedHospital;
  String unit = '';
  String requiredUpto = '';
  String requestClose = '';
  String hospitalDetails = '';
  String userFName = '';
  String userLName = '';
  String userPhoneNumber = '';
  bool _criticalState = false;
  int radioValue = -1;
  String _bloodGroup = 'Select Blood Type';

  void selectBloodType(String value) {
    setState(() {
      _bloodGroup = value;
    });
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

  Widget _bloodGroupTextField() {
    return Container(
      width: double.infinity,
      height: 65,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 7, left: 24, right: 16),
        child: DropdownButtonFormField(
          value: _bloodGroup,
          decoration: InputDecoration(
              hintText: 'Blood Type',
              hintStyle: TextStyle(fontSize: 16.0, fontFamily: "Roboto"),
              enabledBorder: InputBorder.none),
          validator: (value) => value == "Select Blood Type"
              ? 'Blood Type should be selected'
              : null,
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
                height: 30.0,
                child: RadioListTile<int>(
                  title: Text("Yes"),
                  value: 2,
                  groupValue: radioValue,
                  onChanged: (val) {
                    setState(() {
                      radioValue = val;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 30.0,
                child: RadioListTile<int>(
                  title: Text("No"),
                  value: 1,
                  groupValue: radioValue,
                  onChanged: (val) {
                    setState(() {
                      radioValue = val;
                    });
                  },
                ),
              ),
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
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
              hintText: "1",
              hintStyle: TextStyle(
                fontSize: 16.0,
                fontFamily: "Roboto",
              ),
              enabledBorder: InputBorder.none),
          validator: (value) => value.isEmpty ? ' cannot be blank' : null,
          onSaved: (String value) {
            unit = value;
          },
        ),
      ),
    );
  }

  Widget _conditionTextField() {
    return Container(
        width: double.infinity,
        height: 58,
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        // decoration: _boxDecoration(),
        child: CheckboxListTile(
          title: Text("Is Critical"),
          value: _criticalState,
          onChanged: (bool value) {
            setState(() {
              _criticalState = value;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ));
  }

  Widget _dateTextField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: InputDecoration(
              hintText: "DD/MM/YY",
              hintStyle: TextStyle(
                fontSize: 16.0,
                fontFamily: "Roboto",
              ),
              enabledBorder: InputBorder.none),
          validator: (value) => value.isEmpty ? ' cannot be blank' : null,
          onSaved: (String value) {
            requiredUpto = value;
          },
        ),
      ),
    );
  }

  Widget _availableDateTextField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: InputDecoration(
              hintText: "Live Till",
              hintStyle: TextStyle(
                fontSize: 16.0,
                fontFamily: "Roboto",
              ),
              enabledBorder: InputBorder.none),
          validator: (value) => value.isEmpty ? ' cannot be blank' : null,
          onSaved: (String value) {
            requestClose = value;
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
          validator: (value) => value.isEmpty ? ' cannot be blank' : null,
          onSaved: (String value) {
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
          validator: (value) => value.isEmpty ? ' cannot be blank' : null,
          onSaved: (String value) {
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
          validator: (value) => value.isEmpty ? ' cannot be blank' : null,
          onSaved: (String value) {
            userPhoneNumber = value;
          },
        ),
      ),
    );
  }

  void _submitTheForm() {
    final _form = _formKey.currentState;
    if (_form.validate()) {
      print('Form is vaild');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PostView()),
      );
    } else {
      print('Form is invaild');
    }
    _formKey.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    final AuthServices _authService = Provider.of<AuthServices>(context);
    final HospitalDetailsServices _hospitalDetailsServices =
        Provider.of<HospitalDetailsServices>(context);
    final UserService _userService = Provider.of<UserService>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                        "Tell us your condition?",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                _conditionTextField(),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Till when you need blood?",
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                _dateTextField(),
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
                FutureBuilder(
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
                                  style: TextStyle(
                                      fontFamily: 'Roboto', fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // width: double.infinity,
                            // height: 65,
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: _boxDecoration(),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 7, left: 24, right: 16),
                              child: DropdownButtonFormField(
                                items: dropDownItems,
                                decoration: InputDecoration(
                                  hintText: 'Select a Hospital ',
                                  hintStyle: TextStyle(
                                      fontSize: 16.0, fontFamily: "Roboto"),
                                  enabledBorder: InputBorder.none,
                                ),
                                onChanged: (hospitalValue) {
                                  print(hospitalValue);
                                  final snackBar = SnackBar(
                                    content: Text(
                                        'Selected Hospital is $hospitalValue',
                                        style:
                                            TextStyle(color: Colors.blueGrey)),
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);

                                  for (var i = 0;
                                      i < hospitalItems.length;
                                      i++) {
                                    if (hospitalValue ==
                                        hospitalItems[i].bloodBankName) {
                                      addressController.text =
                                          hospitalItems[i].bloodBankAddress;
                                    }
                                  }

                                  setState(() {
                                    selectedHospital = hospitalValue;
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
                                  style: TextStyle(
                                      fontFamily: 'Roboto', fontSize: 16.0),
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
                              padding: const EdgeInsets.only(
                                  top: 4, left: 24, right: 16),
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
                    }),
                Divider(
                  height: 50.0,
                ),
                FutureBuilder<DocumentSnapshot>(
                    future:
                        _userService.requestUserDetails(_authService.user.uid),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text(
                            'Press the button to fetch data',
                            textAlign: TextAlign.center,
                          );
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return CircularProgressIndicator();
                        default:
                          if (snapshot.hasError)
                            return Text(
                              'Error:\n\n${snapshot.error}',
                              textAlign: TextAlign.center,
                            );
                          UserModel data =
                              UserModel.fromMap(snapshot.data.data);
                          userFNameController.text = data.firstName;
                          userLNameController.text = data.lastName;
                          userPhoneNoController.text = data.mobileNo;
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
                                      style: TextStyle(
                                          fontFamily: 'Roboto', fontSize: 16.0),
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
                                      style: TextStyle(
                                          fontFamily: 'Roboto', fontSize: 16.0),
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
                                      style: TextStyle(
                                          fontFamily: 'Roboto', fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                              _userPhoneNumber()
                            ],
                          );
                      }
                    }),
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
}
