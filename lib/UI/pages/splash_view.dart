//library
import 'dart:async';

//pages
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/shared/appConstant.dart';

//packages
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  AuthServices _authServices;
  final PermissionHandler _permissionHandler = PermissionHandler();
  // PermissionStatus _status;
  @override
  void initState() {
    super.initState();
    permissionStartTime();
    // startTime();
  }

  //Splash screen animation
  // Future<Timer> startTime() async {
  //   return Timer(Duration(seconds: 4), _loadingApp);
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authServices = Provider.of<AuthServices>(context);
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

//Location permissionHandler
  Future permissionStartTime() async {
    var result = await _permissionHandler
        .requestPermissions([PermissionGroup.locationWhenInUse]);

    switch (result[PermissionGroup.locationWhenInUse]) {
      case PermissionStatus.granted:
        Timer(Duration(seconds: 4), () {
          _loadingApp();
        });

        break;
      case PermissionStatus.denied:
        _permissionHandler
            .requestPermissions([PermissionGroup.locationWhenInUse]);
        _letUsePermission();
        break;

      default:
    }
  }

//keep app load until user signout
  _loadingApp() {
    _authServices.getCurrentFirebaseUser().then((user) {
      // print(user.isEmailVerified);

      if (user == null) {
        Navigator.pushReplacementNamed(context, AppConstants.AUTH);
      } else if (user != null && !user.emailVerified) {
        Navigator.pushReplacementNamed(context, AppConstants.AUTH);
      } else {
        Navigator.pushReplacementNamed(context, AppConstants.HOME_PAGE);
        //  Navigator.pushReplacementNamed(context, AppConstants.USER_STATE);
      }
    });
  }

  _letUsePermission() {
    Alert(
        context: context,
        type: AlertType.info,
        title:
            "Sorry, we need permission to access your location to provide a better service to you!",
        content: Container(
            child: Text(
                "Go to your settings and change the location permission!",
                style: TextStyle(fontSize: 15, color: Colors.white))),
        style: AlertStyle(
            backgroundColor: Colors.black,
            alertBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: Colors.white)),
            titleStyle: TextStyle(color: Colors.blueAccent)),
        buttons: [
          DialogButton(
              width: 120,
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ]).show();
  }
}
