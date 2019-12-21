
import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/bottom_navigator.dart';
import 'package:flutter/material.dart';


import 'package:blood_collector/UI/pages/settings.dart';
import 'package:blood_collector/UI/pages/add_details_view.dart';
import 'package:blood_collector/UI/pages/map_view.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';
import 'package:blood_collector/UI/pages/requestHistory.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  // int _currentTab = 0;

  // final List<Widget> _children = [
  //  MapView(),
  //   RequestHistory(),
  //   MapView(),
  //   SettingView()
  // ];
  // void onTappedBar(int index) {
  //   setState(() {
  //     _currentTab = index;
  //   });
  // }
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppTopBar(title:"Home")),
        drawer: DrawerWidget(),
        body: BottomNavigationWidget(),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
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
