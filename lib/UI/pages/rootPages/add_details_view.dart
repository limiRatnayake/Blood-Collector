//pages
import 'package:blood_collector/UI/pages/rootPages/addcampaign_view.dart';
import 'package:blood_collector/UI/pages/rootPages/addrequest_view.dart';

//packages
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
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.red),
            backgroundColor: Colors.grey[200],
            bottom: TabBar(
              indicatorColor: Colors.black,
              indicatorWeight: 3.0,
              labelColor: Colors.black,
              tabs: <Widget>[
                Tab(text: 'Add Campaigns'),
                Tab(text: 'Request Blood'),
              ],
            ),
            title: Text(
              'Add Details',
              style: TextStyle(fontFamily: "Roboto", color: Colors.red),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              AddCampaignsView(),
              RequestBloodView(),
            ],
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
