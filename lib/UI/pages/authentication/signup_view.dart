import 'package:blood_collector/UI/widgets/homeWidget.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/shared/constant.dart';
import 'package:flutter/material.dart';

// import 'package:blood_collector/UI/pages/authentication/signin_view.dart';

class SignUpPage extends StatefulWidget {
  final Function toggleViewPera;
  SignUpPage({this.toggleViewPera});
  @override
  State<StatefulWidget> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  Widget _nameTextField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: inputDecoration.copyWith(hintText: "Name"),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value.isEmpty ? 'Name should be filled' : null,
          onChanged: (val) {
            setState(() {
              email = val;
            });
          },
        ),
      ),
    );
  }

  Widget _orgnaizationNameField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: inputDecoration.copyWith(hintText: "Oraganization Name"),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value.isEmpty ? 'Name should be filled' : null,
        ),
      ),
    );
  }

  Widget _mobileNoField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: inputDecoration.copyWith(hintText: "Mobile No:"),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value.isEmpty ? 'Name should be filled' : null,
        ),
      ),
    );
  }

  Widget _cityField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: InputDecoration(
              hintText: "City",
              hintStyle: TextStyle(
                fontSize: 16.0,
                fontFamily: "Roboto",
              ),
              enabledBorder: InputBorder.none),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value.isEmpty ? 'Name should be filled' : null,
        ),
      ),
    );
  }

  Widget _postalAddressField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: inputDecoration.copyWith(hintText: "Postal Address"),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value.isEmpty ? 'Name should be filled' : null,
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: inputDecoration.copyWith(hintText: "Password"),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value.isEmpty ? 'Name should be filled' : null,
          obscureText: true,
          onChanged: (val) {
            setState(() {
              password = val;
            });
          },
        ),
      ),
    );
  }

  void _submitTheForm() async {
    if (_formKey.currentState.validate()) {
      dynamic result = await _auth.signupWithEmailAndPassword(email, password);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePageView()),
      );
      if (result == null) {
        setState(() {
          error = 'Please supply vaild email';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: ListView(children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 180.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/backgroundImage.jpg"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(45.0, 15.0),
                      bottomRight: Radius.elliptical(45.0, 15.0)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text('Blood Collector',
                            style: TextStyle(
                                fontFamily: "Raleway", fontSize: 35.0)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
            ],
          ),
        ),
        Container(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _nameTextField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _orgnaizationNameField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _mobileNoField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _cityField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _postalAddressField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _passwordField(),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: double.infinity,
                    height: 58,
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                    decoration: boxDecoration,
                    child: ButtonTheme(
                      child: RaisedButton(
                        elevation: 0.0,
                        child: Text("SIGNUP",
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 18.0,
                                color: Colors.black)),
                        textColor: Colors.black,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.5)),
                        onPressed: () async {
                          _submitTheForm();
                          
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.person),
                    label: Text('Sign in'),
                    onPressed: () {
                      widget.toggleViewPera();
                    },
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
