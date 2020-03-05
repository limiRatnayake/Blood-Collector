import 'dart:async';

import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/shared/appConstant.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  AuthServices _authServices;
  @override
  void initState() {
    startTime();

    super.initState();
  }
  //Splash screen animation 
  Future<Timer> startTime() async {
    return Timer(Duration(seconds: 3), _loadingApp);
  }

  navigationPage() {
    Navigator.pushReplacementNamed(context, AppConstants.AUTH);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authServices = Provider.of<AuthServices>(context);
    // _loadingApp();

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  width: 220.0,
                  height: 220.0,
                  child: Center(
                    child: Image.asset("assets/logo.png"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
//keep app load until user signout
  _loadingApp() {
    _authServices.getCurrentFirebaseUser().then((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, AppConstants.AUTH);
      } else {
        Navigator.pushReplacementNamed(context, AppConstants.HOME);
      }
    });
  }
}
