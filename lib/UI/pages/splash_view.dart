import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';


import 'package:blood_collector/UI/pages/auth_view.dart';


class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 4),
        () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AuthPage()));
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
        ),//box decoration - add image to background
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             new Container(
                    width: 220.0,
                    height: 220.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    child: Center(
                      child: Text(
                              "Blood Collector",
                              style: TextStyle(
                                fontFamily: "Raleway",
                                fontSize: 25.0,
                              ),
                            ),
                    ),
                ),
            ],
          ),
        ),
      ),

    );
  }
}

void main() {
  setPortraitOrientation();

  runApp(SplashPage());
}

setPortraitOrientation() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
}
