import 'package:blood_collector/UI/widgets/router.dart';
import 'package:flutter/material.dart';



void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        brightness: Brightness.light,
      ),
      initialRoute:'/',
      onGenerateRoute: Router.generateRoute,
    );
  }
}