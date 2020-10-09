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
        child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.grey[200],
              bottom: TabBar(
                indicatorColor: Colors.black,
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
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to Discard Changes?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("NO, BY MISTAKE")),
                FlatButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("YES, I WANT TO"))
              ],
            ));
  }
}
