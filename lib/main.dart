import 'package:blood_collector/UI/router.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_participant_service.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/hospital_service.dart';
import 'package:blood_collector/services/push_notification_service.dart';
import 'package:blood_collector/services/request_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:blood_collector/shared/appConstant.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthServices()),
        ChangeNotifierProvider(create: (_) => HospitalDetailsServices()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => EventService()),
        ChangeNotifierProvider(create: (_) => EventParticipantService()),
        ChangeNotifierProvider(create: (_) => RequestAcceptenceService()),
        ChangeNotifierProvider(create: (_) => PushNotificationService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
