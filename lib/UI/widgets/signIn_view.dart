import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/home_view.dart';

class SigninPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SigninPageState();
  }
}

class _SigninPageState extends State<SigninPage> {
  final Map<String, dynamic> _formData = {'email': null, 'password': null};

  final _formKey = GlobalKey<FormState>();

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(3, 6)) //BoxShadow
        ]);
  }

  Widget _emailTextField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: InputDecoration(
              hintText: "Username",
              hintStyle: TextStyle(
                fontSize: 16.0,
                fontFamily: "Roboto",
              ),
              enabledBorder: InputBorder.none),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value.isEmpty ||
                  !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                      .hasMatch(value)
              ? 'Email cannot be blank'
              : null,
          onSaved: (String value) {
            _formData['email'] = value;
          },
        ),
      ),
    );
  }

  Widget _passwordTextField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: _boxDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: InputDecoration(
              hintText: "Password",
              hintStyle: TextStyle(
                fontSize: 16.0,
                fontFamily: "Roboto",
              ),
              enabledBorder: InputBorder.none),
          validator: (value) => value.isEmpty || value.length < 6
              ? 'Password cannot be blank'
              : null,
          onSaved: (String value) {
            _formData['password'] = value;
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
        MaterialPageRoute(builder: (context) => HomePage()),
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
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 280.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/backgroundImage.jpg"),
                      fit: BoxFit.cover),
                  borderRadius: new BorderRadius.only(
                      bottomRight: Radius.elliptical(55.0, 35.0),
                      bottomLeft: Radius.elliptical(55.0, 35.0)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        child: Text(
                          "Blood Collector",
                          style: TextStyle(
                            fontFamily: "Raleway",
                            fontSize: 35.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _emailTextField(),
                        SizedBox(
                          height: 25.0,
                        ),
                        _passwordTextField(),
                        SizedBox(
                          height: 10.0,
                        ),
                        new Container(
                            child: InkWell(
                          child: Text("Forgot Password"),
                          onTap: () {},
                        )),
                        SizedBox(
                          height: 15.0,
                        ),
                        new Container(
                          width: double.infinity,
                          height: 58,
                          margin: EdgeInsets.symmetric(horizontal: 30.0),
                          decoration: _boxDecoration(),
                          child: ButtonTheme(
                            child: RaisedButton(
                              elevation: 0.0,
                              child: Text("SIGNIN",
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
                        SizedBox(height: 18.0),
                        new Container(
                          width: double.infinity,
                          height: 58,
                          margin: EdgeInsets.symmetric(horizontal: 30.0),
                          decoration: _boxDecoration(),
                          child: ButtonTheme(
                            child: RaisedButton(
                              elevation: 0.0,
                              child: Text("GOOGLE",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 18.0,
                                      color: Colors.red)),
                              textColor: Colors.black,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.5)),
                              onPressed: () => null,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        new Container(
                          width: double.infinity,
                          height: 58,
                          margin: EdgeInsets.symmetric(horizontal: 30.0),
                          decoration: _boxDecoration(),
                          child: ButtonTheme(
                            child: RaisedButton(
                              elevation: 0.0,
                              child: Text("FACEBOOK",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 18.0,
                                      color: Colors.blueAccent)),
                              textColor: Colors.black,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.5)),
                              onPressed: () => null,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        new Container(
                            child: Center(
                                child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't you have and account ?  ",
                              style: TextStyle(
                                  fontSize: 15.0, fontFamily: "Roboto"),
                            ),
                            InkWell(
                              child: Text(
                                "SIGN UP",
                                style: TextStyle(color: Colors.red),
                              ),
                              onTap: () {},
                            )
                          ],
                        )))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )); //Scaffold
  }
}
