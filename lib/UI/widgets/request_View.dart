
import 'package:blood_collector/UI/widgets/addcampaign_view.dart';
import 'package:blood_collector/UI/widgets/requestBlood_view.dart';

import 'package:flutter/material.dart';


class RequestView extends StatefulWidget {
  @override
  _RequestViewState createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: 'Request Blood',),
              Tab(text:'Add Campaigns')
            ],
          ),
          title:Text(' Add Details', style: TextStyle(fontFamily:"Roboto" ),),
        ),
        body: TabBarView(
          children: <Widget>[
              RequestBloodView(),
              AddCampaignsView()
          ],
        ),
      ),
    );
  }
}