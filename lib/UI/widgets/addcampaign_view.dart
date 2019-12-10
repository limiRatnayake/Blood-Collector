import 'package:blood_collector/UI/widgets/create_post_view.dart';
import 'package:flutter/material.dart';


class AddCampaignsView extends StatefulWidget {
  @override
  _AddCampaignsViewState createState() => _AddCampaignsViewState();
}

class _AddCampaignsViewState extends State<AddCampaignsView> {
  final Map<String, dynamic> _formData = {'email': null, 'bloodgroup': null};

  final _formKey = GlobalKey<FormState>();

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
              validator: (value) => value.isEmpty ? ' cannot be blank' : null,
              onSaved: (String value) {
                _formData['bloodgroup'] = value;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _descriptionTextField() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: <Widget>[
              Text(
                "Description",
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
                  hintText:
                      "I need a B+ blood group donor Mr. Kasun. it's urgent need.Bring your National ID or Pastpost ",
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
        ),
      ],
    );
  }

  Widget _venuTextField() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: <Widget>[
              Text(
                "Venu",
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
                  hintText: "Dehiwala",
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
        ),
      ],
    );
  }

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
              onSaved: (String value) {
                _formData['bloodgroup'] = value;
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
              validator: (value) => value.isEmpty ? ' cannot be blank' : null,
              onSaved: (String value) {
                _formData['bloodgroup'] = value;
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
                _descriptionTextField(),
                SizedBox(
                  height: 10.0,
                ),
                _venuTextField(),
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
}
