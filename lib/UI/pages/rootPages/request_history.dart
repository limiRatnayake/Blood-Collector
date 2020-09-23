import 'package:blood_collector/UI/pages/rootPages/donated_request.dart';
import 'package:blood_collector/UI/pages/rootPages/raised_request.dart';
import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';
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
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(95.0),
            child: Column(
              children: <Widget>[
                AppTopBar(title: "Request List"),
                SizedBox(
                  height: 10.0,
                ),
                TabBar(
                  indicatorColor: Colors.red,
                  tabs: [
                    Text(
                      "Donated Request",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text("Raised Request", style: TextStyle(fontSize: 16.0))
                  ],
                ),
              ],
            ),
          ),
          drawer: DrawerWidget(),
          body: TabBarView(children: <Widget>[
           DonatedRequestView(),
            //users event history
            RaisedRequestView()
          ])),
    );
  }
}
