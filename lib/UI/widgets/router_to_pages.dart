
import 'package:flutter/material.dart';

import 'package:blood_collector/UI/widgets/home_view.dart';
import 'package:blood_collector/UI/widgets/map_view.dart';
import 'package:blood_collector/UI/widgets/settings.dart';



class RouterToPages{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_)=> HomePage());
      case 'Login':
        return MaterialPageRoute(builder: (_) => ListView());
      case 'Signin':
        return MaterialPageRoute(builder: (_)=> MapView());
      case 'HomePage':
        return MaterialPageRoute(builder: (_)=> SettingView());
      default:
        return MaterialPageRoute(builder: (_){
          return Scaffold(body: Center(child: Text('No route defines for ${settings.name}'),),);
        });
    }
  }
}