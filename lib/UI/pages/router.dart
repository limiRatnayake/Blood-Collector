

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import 'package:blood_collector/UI/pages/home_view.dart';
import 'package:blood_collector/UI/pages/auth_view.dart';
import 'package:blood_collector/UI/pages/signIn_view.dart';
import 'package:blood_collector/UI/pages/splash_view.dart';


class Router{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_)=> SplashPage());
      case 'Login':
        return MaterialPageRoute(builder: (_) => AuthPage());
      case 'Signin':
        return MaterialPageRoute(builder: (_)=> SigninPage());
      case 'HomePage':
        return MaterialPageRoute(builder: (_)=> HomePage());
      default:
        return MaterialPageRoute(builder: (_){
          return Scaffold(body: Center(child: Text('No route defines for ${settings.name}'),),);
        });
    }
  }
}