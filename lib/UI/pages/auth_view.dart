import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './signin_view.dart';
import './signup_view.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

Widget button(String label, Function onTap) {
  return Material(
    color: Colors.white.withOpacity(0.6),
    borderRadius: BorderRadius.circular(30.0),
    child: InkWell(
      onTap: onTap,
      splashColor: Colors.white24,
      highlightColor: Colors.white10,
      child: Container(
        width: 268.0,
        padding: EdgeInsets.symmetric(vertical: 13.0),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 18.0,
            fontFamily: "Roboto"),
          ),
        ),
      ),
    ),
  );
}

class _AuthPageState extends State<AuthPage> {

  void _buildNavigateSignInPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SigninPage()),
    );
  }
  void _buildNavigateSignUpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/backgroundImage.jpg"),
          fit: BoxFit.cover,
        )), //box decoration - add image to background
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                  width: 290.0,
                  height: 290.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  child: Center(
                    child: Text(
                      "Blood Collector",
                      style: TextStyle(
                        fontFamily: "Raleway",
                        fontSize: 35.0,
                      ),
                    ),
                  )), // container - circle & center text
              SizedBox(
                height: 125.0,
              ),
              new Column(children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Continue with: ',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    button("Sign In", () {
                      _buildNavigateSignInPage();
                    }),

                    SizedBox(
                      height: 25.0,
                    ),
                    button("Create an account", () {
                      _buildNavigateSignUpPage();
                    }),
                  ],
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
void main() {
  setPortraitOrientation();

  runApp(AuthPage());
}

setPortraitOrientation() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
}
