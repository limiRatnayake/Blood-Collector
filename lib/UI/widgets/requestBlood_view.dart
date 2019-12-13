import 'package:blood_collector/UI/widgets/create_post_view.dart';

import 'package:flutter/material.dart';

class RequestBloodView extends StatefulWidget {
  @override
  _RequestBloodViewState createState() => _RequestBloodViewState();
}

class _RequestBloodViewState extends State<RequestBloodView> {
  final Map<String, dynamic> _formData = {'bloodgroup': null};
  bool _criticalState = false;

  final _formKey = GlobalKey<FormState>();
  List<String> countries = ['A', 'A+', 'A-'];
  String _countries = 'A';

  void something(String value) {
    setState(() {
      _countries = value;
    });
  }

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

  Widget _bloodGroupTextField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: _boxDecoration(),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: DropdownButtonFormField(
          value: _countries,
          decoration: InputDecoration(
              hintText: 'Blood Type',
              hintStyle: TextStyle(fontSize: 16.0, fontFamily: "Roboto"),
              enabledBorder: InputBorder.none),
          onChanged: (String value) {
            something(value);
          },
          items: countries.map((String value) {
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
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: InputDecoration(
              hintText: "Not available",
              hintStyle: TextStyle(
                fontSize: 16.0,
                fontFamily: "Roboto",
              ),
              enabledBorder: InputBorder.none),
          validator: (value) => value.isEmpty ? ' cannot be blank' : null,
          onSaved: (String value) {
            _formData['bloodgroup'] = value;
          },
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
          decoration: InputDecoration(
              hintText: "1",
              hintStyle: TextStyle(
                fontSize: 16.0,
                fontFamily: "Roboto",
              ),
              enabledBorder: InputBorder.none),
          validator: (value) => value.isEmpty ? ' cannot be blank' : null,
          onSaved: (String value) {
            _formData['bloodgroup'] = value;
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
            _formData['bloodgroup'] = value;
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
            _formData['bloodgroup'] = value;
          },
        ),
      ),
    );
  }

  Widget _hospitalNameTextField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: InputDecoration(
              hintText: "Enter the hospital name",
              hintStyle: TextStyle(
                fontSize: 16.0,
                fontFamily: "Roboto",
              ),
              enabledBorder: InputBorder.none),
          validator: (value) => value.isEmpty ? ' cannot be blank' : null,
          onSaved: (String value) {
            _formData['bloodgroup'] = value;
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
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "Hospital Name & Address will help Blood Donors to navigate easily",
                          style:
                              TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                _hospitalNameTextField(),
                SizedBox(
                  height: 20.0,
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
