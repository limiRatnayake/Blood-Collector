import 'package:blood_collector/Modules/technician.dart';
import 'package:flutter/material.dart';

import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';

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
              padding: EdgeInsets.only(top: 550, bottom: 50),
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

List<Technician> getTechices() {
  List<Technician> techies = [];
  for (int i = 0; i < 10; i++) {
    AssetImage profilePic = new AssetImage("assets/person.jpg");
    Technician myTechy = new Technician(
        'Carlos teller',
        'First road 23 elm street',
        'Electrician',
        '070-379-031',
        profilePic,
        529.3,
        4,
        'Available');
    techies.add(myTechy);
  }
  return techies;
}

List<Widget> getTechniciansInArea() {
  List<Technician> techies = getTechices();
  List<Widget> cards = [];
  for (Technician techy in techies) {
    cards.add(technicianCard(techy));
  }
  return cards;
}

Widget technicianCard(Technician technician) {
  return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 20),
      width: 180,
      // height: 150,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20.0)]),
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: CircleAvatar(
                    backgroundImage: technician.profilePic,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(technician.name),
                    Text(technician.occupation),
                  ],
                ),
              ]),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Row(
              children: <Widget>[
                Text("Status:   "),
                Text(technician.status),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Rating:  " + technician.rating.toString())
                  ],
                ),
                Row(
                  children: getRatings(technician),
                )
              ],
            ),
          )
        ],
      ));
}

List<Widget> getRatings(Technician techy) {
  List<Widget> ratings = [];
  for (int i = 0; i < 5; i++) {
    if (i < techy.rating) {
      ratings.add(Icon(
        Icons.star,
        color: Colors.yellow,
      ));
    } else {
      ratings.add(
        Icon(
          Icons.star_border,
          color: Colors.black,
        ),
      );
    }
  }
  return ratings;
}
