import 'package:blood_collector/UI/pages/rootPages/addcampaign_view.dart';
import 'package:blood_collector/UI/pages/rootPages/addrequest_view.dart';
import 'package:flutter/material.dart';

class RequestView extends StatefulWidget {
  @override
  _RequestViewState createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            bottom: TabBar(
              indicatorColor: Colors.red,
              indicatorWeight: 3.0,
              labelColor: Colors.black,
              tabs: <Widget>[
                Tab(text: 'Request Blood'),
                Tab(text: 'Add Campaigns')
              ],
            ),
            title: Text(
              ' Add Details',
              style: TextStyle(fontFamily: "Roboto", color: Colors.black),
            ),
          ),
          body: TabBarView(
            children: <Widget>[RequestBloodView(), AddCampaignsView()],
          ),
        ),
      ),
    );
  }
}
