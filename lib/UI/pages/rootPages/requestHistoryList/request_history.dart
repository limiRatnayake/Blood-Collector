//pages
import 'package:blood_collector/UI/pages/rootPages/requestHistoryList/donatedRequestHistory/donated_request.dart';
import 'package:blood_collector/UI/pages/rootPages/requestHistoryList/raised_request.dart';
import 'package:blood_collector/UI/pages/rootPages/requestHistoryList/request_acceptence.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';

//packages
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
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.grey.withOpacity(0.3),
          appBar: AppBar(
            iconTheme: new IconThemeData(color: Colors.red[600]),
            title: Text(
              "Request List",
              style: TextStyle(color: Colors.red[600]),
            ),
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.red,
              tabs: [
                Text("Raised Request", style: TextStyle(fontSize: 16.0)),
                Text(
                  "Donated Request",
                  style: TextStyle(fontSize: 16.0),
                ),
                Text("Accept Request", style: TextStyle(fontSize: 16.0))
              ],
            ),
          ),
          drawer: DrawerWidget(),
          body: TabBarView(children: <Widget>[
            RaisedRequestView(),
            DonatedRequestView(),
            //users event history
            AcceptRequestView()
          ])),
    );
  }
}
