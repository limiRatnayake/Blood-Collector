import 'package:blood_collector/UI/pages/rootPages/map_view.dart';
import 'package:blood_collector/UI/pages/rootPages/settingView.dart';
import 'package:flutter/material.dart';

import 'package:blood_collector/UI/widgets/home_widget.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/drawer.PNG"), fit: BoxFit.fill),
              ),
              child: DrawerHeader(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/person.jpg"),
                        radius: 50.0,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Aurélien Salomon",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "@aureliensalomon",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeWidgetView()));
            },
          ),
          ListTile(
            title: Text("History"),
            leading: Icon(Icons.history),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ListView()));
            },
          ),
          ListTile(
            title: Text("Map"),
            leading: Icon(Icons.map),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MapView()));
            },
          ),
          ListTile(
            title: Text("Setting"),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingView()));
            },
          ),
          Divider(
            thickness: 1.0,
          ),
          Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text("FAQ's"),
                  onTap: () {},
                ),
                ListTile(
                  title: Text("How to use"),
                  onTap: () {},
                ),
                ListTile(
                  title: Text("Terms of services"),
                  onTap: () {},
                ),
                ListTile(
                  title: Text("Privacy Policy"),
                  onTap: () {},
                ),
                ListTile(
                  title: Text("Log Out"),
                  onTap: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
