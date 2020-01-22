import 'package:blood_collector/UI/pages/authentication/signup_view.dart';
import 'package:blood_collector/UI/widgets/homeWidget.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:blood_collector/shared/constant.dart';
// import 'package:blood_collector/UI/widgets/homeWidget.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInPageState();
  }
}

class _SignInPageState extends State<SignInPage> {
  // final Map<String, dynamic> _formData = {'email': null, 'password': null};

  final _formKey = GlobalKey<FormState>();
  final AuthServices _auth = AuthServices();

  String email = '';
  String password = '';
  String error = '';

  Widget _emailTextField() {
    return Container(
      width: double.infinity,
      height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration, //import from shared
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: inputDecoration.copyWith(hintText: "Username"),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value.isEmpty ||
                  !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                      .hasMatch(value)
              ? 'Email cannot be blank'
              : null,
          onChanged: (value) {
            // _formData['email'] = value;
            setState(() {
              email = value;
            });
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
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
        child: TextFormField(
          decoration: inputDecoration.copyWith(hintText: "Password"),
          validator: (value) => value.isEmpty || value.length < 6
              ? 'Password cannot be blank'
              : null,
          obscureText: true,
          onChanged: (value) {
            // _formData['password'] = value;
            setState(() {
              password = value;
            });
          },
        ),
      ),
    );
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
                          decoration: boxDecoration,
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
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  dynamic result =
                                      await _auth.signinWithEmailAndPassword(
                                          email, password);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePageView()),
                                  );
                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'Could not sign in with those cridentials';
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 18.0),
                        new Container(
                          width: double.infinity,
                          height: 58,
                          margin: EdgeInsets.symmetric(horizontal: 30.0),
                          decoration: boxDecoration,
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
                          decoration: boxDecoration,
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
                            FlatButton.icon(
                              icon: Icon(Icons.person),
                              label: Text('Sign Up'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage()),
                                ); 
                              },
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
