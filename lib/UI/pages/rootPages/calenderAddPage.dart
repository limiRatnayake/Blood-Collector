import 'package:flutter/material.dart';

import 'package:add_2_calendar/add_2_calendar.dart';

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Event event = Event(
      title: 'Test event',
      description: 'example',
      location: 'Flutter app',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 1)),
      allDay: false,
    );

    return MaterialApp(
      home: Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          title: const Text('Add event to calendar example'),
        ),
        body: Center(
          child: RaisedButton(
            child: Text('Add test event to device calendar'),
            onPressed: () {
              Add2Calendar.addEvent2Cal(event).then((success) {
                scaffoldState.currentState.showSnackBar(
                    SnackBar(content: Text(success ? 'Success' : 'Error')));
              });
            },
          ),
        ),
      ),
    );
  }
}
