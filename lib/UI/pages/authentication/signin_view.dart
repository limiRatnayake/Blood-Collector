import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:blood_collector/shared/constant.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInPageState();
  }
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  String email = '';
  String password = '';
  String error = '';
   bool _obscureText = true;

   void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

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
      // height: 58,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 24),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                // controller: _passController,
                decoration: inputDecoration.copyWith(
                  hintText: "Password",
                ),
                keyboardType: TextInputType.visiblePassword,
                validator: validatePassword,
                obscureText: _obscureText,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
            ),
            FlatButton(
              onPressed: _toggle,
              child: _obscureText
                  ? Icon(Icons.visibility_off)
                  : Icon(Icons.visibility),
            )
          ],
        ),
      ),
    );
  }

  // Widget _passwordTextField() {
  //   return Container(
  //     width: double.infinity,
  //     height: 58,
  //     margin: EdgeInsets.symmetric(horizontal: 30.0),
  //     decoration: boxDecoration,
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
  //       child: TextFormField(
  //         decoration: inputDecoration.copyWith(hintText: "Password"),
  //         validator: (value) => value.isEmpty || value.length < 6
  //             ? 'Password cannot be blank'
  //             : null,
  //         obscureText: true, //visibiity of the password
  //         onChanged: (value) {
  //           setState(() {
  //             password = value;
  //           });
  //         },
  //       ),
        
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final AuthServices _authService = Provider.of<AuthServices>(context);

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.white,
          body: ListView(
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 280.0,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Center(
                                child: Image.asset("assets/logo_name.png"),
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
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                  height: 20.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 58,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 30.0),
                                  decoration: boxDecoration,
                                  child: ButtonTheme(
                                    child: _isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : RaisedButton(
                                            elevation: 0.0,
                                            child: Text("SIGNIN",
                                                style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 18.0,
                                                )),
                                            textColor: Colors.black,
                                            color: Colors.red.withOpacity(0.9),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25.5)),
                                            onPressed: () {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                _authService
                                                    .signIn(email, password)
                                                    .then(
                                                  (FirebaseUser user) {
                                                    if (user != null) {
                                                      Navigator
                                                          .pushReplacementNamed(
                                                        context,
                                                        AppConstants.HOME,
                                                      );
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          // returns a object of type Dialog
                                                          return AlertDialog(
                                                            title: new Text(
                                                                "UserModel Login Error"),
                                                            content: new Text(
                                                                "This user not found"),
                                                            actions: <Widget>[
                                                              new FlatButton(
                                                                child: new Text(
                                                                    "Close"),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                    setState(() =>
                                                        _isLoading = false);
                                                  },
                                                ).catchError((e) {
                                                  setState(() {
                                                    _isLoading = false;
                                                    print(e);
                                                  });
                                                });
                                              }
                                            },
                                          ),
                                  ),
                                ),
                                SizedBox(height: 33.0),
                                Container(
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
                                        Navigator.pushReplacementNamed(
                                          context,
                                          AppConstants.SIGN_UP,
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
                    ),
                  ],
                ),
              ),
            ],
          )),
    ); //Scaffold
  }
  String validatePassword(String value) {
    var strongRegex = new RegExp(
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})");

    if (value.isEmpty) {
      return "Password is required";
    } else if (!strongRegex.hasMatch(value)) {
      return "Password is not strong enough!";
    }
    return null;
  }
}
