import 'package:blood_collector/UI/widgets/preventDooubleTap.dart';
import 'package:flutter/material.dart';

class ViewDetails extends StatefulWidget {
  @override
  _ViewDetailsState createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 150.0,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/person.jpg"),
                        minRadius: 40,
                        maxRadius: 60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title: Text("Requested Blood Type"),
                      trailing: Text("B+"),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Units of Blood"),
                      trailing: Text("1"),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Card(
                    child: ListTile(
                      title: Text("When they need blood"),
                      trailing: Text("DD/MM/YY"),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Hospital Name"),
                      trailing: Text("Narahanpitiya Blood bank"),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Condition of the patient"),
                      trailing: Text("Critical"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PreventDoubleTap(),
      ),
    );
  }
}
