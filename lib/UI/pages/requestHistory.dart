import 'package:flutter/material.dart';

class RequestHistory extends StatefulWidget {
  @override
  _RequestHistoryState createState() => _RequestHistoryState();
}

class _RequestHistoryState extends State<RequestHistory>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(35.0),
            child: new Container(
              child: new SafeArea(
                child: Column(
                  children: <Widget>[
                    new Expanded(child: new Container()),
                    new TabBar(
                      indicatorColor: Colors.red,
                      tabs: [
                        new Text(
                          "Donated Request",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        new Text("Raised Request",
                            style: TextStyle(fontSize: 16.0))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: new TabBarView(children: <Widget>[
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const ListTile(
                leading: Icon(Icons.verified_user),
                title: Text('The Enchanted Nightingale'),
                subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
              ),
              const ListTile(
                leading: Icon(Icons.album),
                title: Text('The Enchanted Nightingale'),
                subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
              ),
            ]),
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const ListTile(
                leading: Icon(Icons.album),
                title: Text('The Enchanted Nightingale'),
                subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
              ),
            ]),
          ])),
    );
  }
}
