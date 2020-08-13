import 'package:blood_collector/UI/pages/rootPages/add_details_view.dart';

import 'package:flutter/material.dart';

import 'package:blood_collector/UI/widgets/bottom_navigator.dart';

class HomeWidgetView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeWidgetViewState();
  }
}

class _HomeWidgetViewState extends State<HomeWidgetView>
    with TickerProviderStateMixin<HomeWidgetView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BottomNavigationWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RequestView()));
          },
          child: Icon(Icons.add),
          tooltip: 'Add a post',
        ),
      ),
    );
  }
}
