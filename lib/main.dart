import 'package:blood_collector/UI/router.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/hospital_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}
// void main() => runApp(
//   DevicePreview(
//     enabled: !kReleaseMode,
//     builder: (context) => MyApp(),
//   ),
// );

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthServices()),
        ChangeNotifierProvider(create: (_) => HospitalDetailsServices()),
         ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => EventService()),
        // ChangeNotifierProvider(create: (_) => UserStatus()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // builder: DevicePreview.appBuilder,
        theme: ThemeData(
            canvasColor: Colors.white,
            brightness: Brightness.light,
            primaryColor: Colors.white,
            appBarTheme: AppBarTheme(color: Colors.white, elevation: 0)),
        // home: Wrapper(),
        initialRoute: AppConstants.SPLASH,
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
