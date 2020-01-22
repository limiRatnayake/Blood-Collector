import 'package:blood_collector/UI/pages/rootPages/add_details_view.dart';
import 'package:flutter/material.dart';



import 'package:blood_collector/UI/widgets/bottom_navigator.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';

class HomePageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePageView>
    with TickerProviderStateMixin<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DrawerWidget(),
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
