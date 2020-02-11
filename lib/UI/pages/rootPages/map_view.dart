import 'package:flutter/material.dart';

import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';
import 'package:blood_collector/models/user.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: AppTopBar(title: "Map")),
        drawer: DrawerWidget(),
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 480.0, bottom: 40.0),
              child: ListView(
                padding: EdgeInsets.only(left: 20),
                children: getTechniciansInArea(),
                scrollDirection: Axis.horizontal,
              ),
            ),
          ],
        ));
  }
}

List<User> getTechices() {
  List<User> techies = [];
  for (int i = 0; i < 10; i++) {
    AssetImage profilePic = new AssetImage("assets/person.jpg");
    // User myTechy = new User('Carlos teller',
    //     'First road 23 elm street', '070-379-031', profilePic, 'B+');
    // techies.add(myTechy);
  }
  return techies;
}

List<Widget> getTechniciansInArea() {
  List<User> techies = getTechices();
  List<Widget> cards = [];
  for (User techy in techies) {
    cards.add(technicianCard(techy));
  }
  return cards;
}

Widget technicianCard(User bloodRequester) {
  return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 20),
      width: 250,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20.0)]),
      child: Column(
        children: <Widget>[
          Container(
            height: 80.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/backgroundImage.jpg',
                    ),
                    fit: BoxFit.fill)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 60.0,
                    width: 60.0,
                    child: CircleAvatar(
                      // backgroundImage: bloodRequester.profilePic,
                    ),
                  ),
                ]),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(bloodRequester.name),
                    // Text(technician.occupation),
                    // Text(
                      // "Blood Group:   " + bloodRequester.bType,
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ));
}
