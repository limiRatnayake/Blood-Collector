import 'package:flutter/material.dart';

import 'package:blood_collector/UI/pages/homeView.dart';
import 'package:blood_collector/UI/pages/map_view.dart';
import 'package:blood_collector/UI/pages/requestHistory.dart';
import 'package:blood_collector/UI/pages/settingView.dart';

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
    HomeView(),
    RequestHistory(),
    MapView(),
    SettingView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentTab],
        bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentTab,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), title: Text('Request List')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.map), title: Text('Map')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), title: Text('Settings')),
            ],
            onTap: onTappedBar));
  }
}
