import 'package:blood_collector/Module/userFirebase.dart';
import 'package:blood_collector/UI/pages/router.dart';
import 'package:blood_collector/services/auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserFirebase>.value(
      value: AuthServices().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            canvasColor: Colors.white,
            brightness: Brightness.light,
            primaryColor: Colors.white,
            appBarTheme: AppBarTheme(color: Colors.white, elevation: 0)),
        // home: Wrapper(),
        initialRoute: '/',
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}


