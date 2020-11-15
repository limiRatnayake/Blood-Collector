import 'package:blood_collector/UI/pages/rootPages/donatedRequestHistory/donated_request.dart';
import 'package:blood_collector/UI/pages/rootPages/raised_request.dart';
import 'package:blood_collector/UI/pages/rootPages/request_acceptence.dart';
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
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Request List"),
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
          // appBar: PreferredSize(
          //   preferredSize: Size.fromHeight(95.0),
          //   child: Column(
          //     children: <Widget>[
          //       AppTopBar(title: "Request List"),
          //       SizedBox(
          //         height: 10.0,
          //       ),
          //       TabBar(
          //         indicatorColor: Colors.red,
          //         tabs: [
          //           Text(
          //             "Donated Request",
          //             style: TextStyle(fontSize: 16.0),
          //           ),
          //           Text("Raised Request", style: TextStyle(fontSize: 16.0)),
          //           Text("Request Acceptence", style: TextStyle(fontSize: 16.0))
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
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
