//pages
import 'package:blood_collector/UI/pages/rootPages/map_view.dart';
import 'package:blood_collector/UI/pages/rootPages/request_history.dart';
import 'package:blood_collector/UI/pages/rootPages/settingView.dart';
import 'package:blood_collector/UI/pages/rootPages/timelineView.dart';

//packages
import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatefulWidget {
  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _currentTab = 0;

  void onTappedBar(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  final List<Widget> _children = [
    TimelineView(),
    RequestHistory(),
    MapView(),
    SettingView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentTab],
        bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.red[600],
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentTab,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), label: 'Request List'),
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ],
            onTap: onTappedBar));
  }
}
