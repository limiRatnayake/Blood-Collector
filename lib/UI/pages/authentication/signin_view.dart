import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:blood_collector/shared/decoration_constant.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInPageState();
  }
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _formValidate = false;

  String email = '';
  String password = '';
  String error = '';
  bool _obscureText = true;
  String _errorMessage;
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
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off),
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
                            autovalidate: _formValidate,
                            child: Column(
                              children: <Widget>[
                                _emailTextField(),
                                SizedBox(
                                  height: 25.0,
                                ),
                                _passwordTextField(),
                                SizedBox(
                                  height: 25.0,
                                ),
                                new Center(
                                    widthFactor: double.infinity,
                                    child: InkWell(
                                      child: Text(
                                        "Forgot Password ?",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      onTap: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          AppConstants.FORGOT_PASSWORD,
                                        );
                                      },
                                    )),
                                SizedBox(
                                  height: 20.0,
                                ),
                                _errorMessage != null
                                    ? Container(
                                        padding: EdgeInsets.only(bottom: 10),
                                        width: double.infinity,
                                        child: Text(
                                          _errorMessage,
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : Container(),
                                _isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 58,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 30.0),
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
                                            color: Colors.red.withOpacity(0.9),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25.5)),
                                            onPressed: () async {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                setState(() {
                                                  _errorMessage = "";
                                                  _isLoading = true;
                                                });

                                                String response =
                                                    await _authService.signIn(
                                                        email, password);

                                                if (response != "Success") {
                                                  setState(() {
                                                    _isLoading = false;
                                                    _errorMessage = response;
                                                  });
                                                } else
                                                  Alert(
                                                      context: context,
                                                      type: AlertType.success,
                                                      title:
                                                          "You are Successfully login",
                                                      style: AlertStyle(
                                                        isCloseButton: false,

                                                        // backgroundColor:
                                                        //     Colors.black,
                                                        alertBorder:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .white)),
                                                        // titleStyle: TextStyle(
                                                        //     color: Colors
                                                        //         .white)
                                                      ),
                                                      buttons: [
                                                        DialogButton(
                                                            width: 120,
                                                            child: Text(
                                                              "ok",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20),
                                                            ),
                                                            onPressed: () {
                                                              Navigator
                                                                  .pushReplacementNamed(
                                                                context,
                                                                AppConstants
                                                                    .HOME_PAGE,
                                                              );
                                                            })
                                                      ]).show();
                                                setState(() {
                                                  _isLoading = false;
                                                });

                                                // if (response != "Success") {
                                                //   setState(() {
                                                //     _isLoading = false;
                                                //     _errorMessage = response;
                                                //   });
                                                // } else {
                                                //   Alert(
                                                //       context: context,
                                                //       type: AlertType.success,
                                                //       title: "You are login",
                                                //       style: AlertStyle(
                                                //           backgroundColor:
                                                //               Colors.black,
                                                //           alertBorder: RoundedRectangleBorder(
                                                //               borderRadius:
                                                //                   BorderRadius
                                                //                       .circular(
                                                //                           5),
                                                //               side: BorderSide(
                                                //                   color: Colors
                                                //                       .white)),
                                                //           titleStyle: TextStyle(
                                                //               color: Colors
                                                //                   .white)),
                                                //       buttons: [
                                                //         DialogButton(
                                                //             width: 120,
                                                //             child: Text(
                                                //               "ok",
                                                //               style: TextStyle(
                                                //                   color: Colors
                                                //                       .white,
                                                //                   fontSize: 20),
                                                //             ),
                                                //             onPressed: () {
                                                //               Navigator
                                                //                   .pushReplacementNamed(
                                                //                 context,
                                                //                 AppConstants
                                                //                     .ADD_POST,
                                                //               );
                                                //             })
                                                //       ]).show();
                                                //   setState(() {
                                                //     _isLoading = false;
                                                //   });
                                                // }
                                              } else {
                                                setState(() {
                                                  _formValidate = true;
                                                });
                                              }
                                            },
                                          ),
                                        )),
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

// import 'package:blood_collector/services/auth.dart';
// import 'package:blood_collector/shared/appConstant.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:blood_collector/shared/decoration_constant.dart';
// import 'package:provider/provider.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';

// class SignInPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _SignInPageState();
//   }
// }

// class _SignInPageState extends State<SignInPage> {
//   final _formKey = GlobalKey<FormState>();

//   bool _isLoading = false;
//   bool _formValidate = false;

//   String email = '';
//   String password = '';
//   String error = '';
//   bool _obscureText = true;
// String _errorMessage;
//   void _toggle() {
//     setState(() {
//       _obscureText = !_obscureText;
//     });
//   }

//   Widget _emailTextField() {
//     return Container(
//       width: double.infinity,
//       height: 58,
//       margin: EdgeInsets.symmetric(horizontal: 30.0),
//       decoration: boxDecoration, //import from shared
//       child: Padding(
//         padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
//         child: TextFormField(
//           decoration: inputDecoration.copyWith(hintText: "Username"),
//           keyboardType: TextInputType.emailAddress,
//           validator: (value) => value.isEmpty ||
//                   !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
//                       .hasMatch(value)
//               ? 'Email cannot be blank'
//               : null,
//           onChanged: (value) {
//             setState(() {
//               email = value;
//             });
//           },
//         ),
//       ),
//     );
//   }

//   Widget _passwordTextField() {
//     return Container(
//       width: double.infinity,
//       // height: 58,
//       margin: EdgeInsets.symmetric(horizontal: 30.0),
//       decoration: boxDecoration,
//       child: Padding(
//         padding: const EdgeInsets.only(top: 4, left: 24),
//         child: Row(
//           children: [
//             Expanded(
//               child: TextFormField(
//                 // controller: _passController,
//                 decoration: inputDecoration.copyWith(
//                   hintText: "Password",
//                 ),
//                 keyboardType: TextInputType.visiblePassword,
//                 validator: validatePassword,
//                 obscureText: _obscureText,
//                 onChanged: (val) {
//                   setState(() {
//                     password = val;
//                   });
//                 },
//               ),
//             ),
//             FlatButton(
//               onPressed: _toggle,
//               child: _obscureText
//                   ? Icon(Icons.visibility_off)
//                   : Icon(Icons.visibility),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget _passwordTextField() {
//   //   return Container(
//   //     width: double.infinity,
//   //     height: 58,
//   //     margin: EdgeInsets.symmetric(horizontal: 30.0),
//   //     decoration: boxDecoration,
//   //     child: Padding(
//   //       padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
//   //       child: TextFormField(
//   //         decoration: inputDecoration.copyWith(hintText: "Password"),
//   //         validator: (value) => value.isEmpty || value.length < 6
//   //             ? 'Password cannot be blank'
//   //             : null,
//   //         obscureText: true, //visibiity of the password
//   //         onChanged: (value) {
//   //           setState(() {
//   //             password = value;
//   //           });
//   //         },
//   //       ),

//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final AuthServices _authService = Provider.of<AuthServices>(context);

//     return SafeArea(
//       child: Scaffold(
//           resizeToAvoidBottomPadding: false,
//           backgroundColor: Colors.white,
//           body: ListView(
//             children: <Widget>[
//               Center(
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                       height: 280.0,
//                       child: Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             Container(
//                               child: Center(
//                                 child: Image.asset("assets/logo_name.png"),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30.0,
//                     ),
//                     Container(
//                       child: SingleChildScrollView(
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                               bottom: MediaQuery.of(context).viewInsets.bottom),
//                           child: Form(
//                             key: _formKey,
//                             autovalidate: _formValidate,
//                             child: Column(
//                               children: <Widget>[
//                                 _emailTextField(),
//                                 SizedBox(
//                                   height: 25.0,
//                                 ),
//                                 _passwordTextField(),
//                                 SizedBox(
//                                   height: 25.0,
//                                 ),
//                                 new Center(
//                                     widthFactor: double.infinity,
//                                     child: InkWell(
//                                       child: Text(
//                                         "Forgot Password ?",
//                                         style: TextStyle(fontSize: 15),
//                                       ),
//                                       onTap: () {
//                                         Navigator.pushReplacementNamed(
//                                           context,
//                                           AppConstants.FORGOT_PASSWORD,
//                                         );
//                                       },
//                                     )),
//                                 SizedBox(
//                                   height: 20.0,
//                                 ),
//                                 Container(
//                                   width: double.infinity,
//                                   height: 58,
//                                   margin:
//                                       EdgeInsets.symmetric(horizontal: 30.0),
//                                   decoration: boxDecoration,
//                                   child: ButtonTheme(
//                                     child: _isLoading
//                                         ? Center(
//                                             child: CircularProgressIndicator(),
//                                           )
//                                         : RaisedButton(
//                                             elevation: 0.0,
//                                             child: Text("SIGNIN",
//                                                 style: TextStyle(
//                                                   fontFamily: "Roboto",
//                                                   fontSize: 18.0,
//                                                 )),
//                                             textColor: Colors.black,
//                                             color: Colors.red.withOpacity(0.9),
//                                             shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         25.5)),
//                                             onPressed: () async{
//                                                 if (_formKey.currentState
//                                                   .validate()) {
//                                                 setState(() {
//                                                   _isLoading = true;
//                                                 });
//                                                String response =await _authService
//                                                     .signIn(email, password);

//                                                  if (response != "Success") {

//                                                  }

//                                               } else {
//                                                 setState(() {
//                                                   _formValidate = true;
//                                                 });
//                                               }
//                                             },
//                                             //   if (_formKey.currentState
//                                             //       .validate()) {
//                                             //     setState(() {
//                                             //       _isLoading = true;
//                                             //     });
//                                             //     _authService
//                                             //         .signIn(email, password)
//                                             //         .then(
//                                             //       (FirebaseUser user) {
//                                             //         if (user != null) {
//                                             //           Navigator
//                                             //               .pushReplacementNamed(
//                                             //             context,
//                                             //             AppConstants.ADD_POST,
//                                             //           );
//                                             //         }
//                                             //         setState(() =>
//                                             //             _isLoading = false);
//                                             //       },
//                                             //     ).catchError((e) {

//                                             //       switch (e.message) {
//                                             //         case 'The password is invalid or the user does not have a password.':
//                                             //              AlertDialog(
//                                             //                 title: new Text(
//                                             //                     "Error Message"),
//                                             //                 content:
//                                             //                     new Text("ERROR_WRONG_PASSWORD"),
//                                             //                 actions: <Widget>[
//                                             //                   new FlatButton(
//                                             //                     child: new Text(
//                                             //                         "Close"),
//                                             //                     onPressed: () {
//                                             //                       Navigator.of(
//                                             //                               context)
//                                             //                           .pop();
//                                             //                     },
//                                             //                   ),
//                                             //                 ],
//                                             //               );
//                                             //           break;

//                                             //         // ...
//                                             //         default:
//                                             //           print(
//                                             //               'Case ${e.message} is not yet implemented');
//                                             //       }
//                                             //       setState(() {
//                                             //         _isLoading = false;
//                                             //         print(e);
//                                             //       });
//                                             //     });
//                                             //   } else {
//                                             //     setState(() {
//                                             //       _formValidate = true;
//                                             //     });
//                                             //   }
//                                             // },
//                                           ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 33.0),
//                                 Container(
//                                     child: Center(
//                                         child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     Text(
//                                       "Don't you have and account ?  ",
//                                       style: TextStyle(
//                                           fontSize: 15.0, fontFamily: "Roboto"),
//                                     ),
//                                     FlatButton.icon(
//                                       icon: Icon(Icons.person),
//                                       label: Text('Sign Up'),
//                                       onPressed: () {
//                                         Navigator.pushReplacementNamed(
//                                           context,
//                                           AppConstants.SIGN_UP,
//                                         );
//                                       },
//                                     )
//                                   ],
//                                 )))
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           )),
//     ); //Scaffold
//   }

//   String validatePassword(String value) {
//     var strongRegex = new RegExp(
//         "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})");

//     if (value.isEmpty) {
//       return "Password is required";
//     } else if (!strongRegex.hasMatch(value)) {
//       return "Password is not strong enough!";
//     }
//     return null;
//   }
// }
