
import 'package:flutter/material.dart';


import 'package:blood_collector/UI/pages/settings.dart';
import 'package:blood_collector/UI/pages/add_details_view.dart';
import 'package:blood_collector/UI/pages/List_view.dart';
import 'package:blood_collector/UI/pages/map_view.dart';
import 'package:blood_collector/UI/widgets/bottom_navigator.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  int _currentTab = 0;

  final List<Widget> _children = [
    ListPage(),
    ListPage(),
    MapView(),
    SettingView()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Home',
            style: TextStyle(color: Colors.redAccent),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.favorite),
              color: Colors.grey,
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              color: Colors.grey,
              onPressed: () {},
            ),
          ],
        ),
        drawer: DrawerWidget(),
        body: _children[_currentTab],
        bottomNavigationBar: BottomNavigationWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => RequestView()));
          },
          child: Icon(Icons.add),
          tooltip: 'Add a post',
        ),
      ),
    );
  }
}
