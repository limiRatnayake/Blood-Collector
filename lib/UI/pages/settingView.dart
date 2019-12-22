import 'package:blood_collector/UI/pages/editProfileView.dart';
import 'package:flutter/material.dart';

import 'package:blood_collector/UI/pages/notificationView.dart';
import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: AppTopBar(title: "Settings")),
        drawer: DrawerWidget(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage("assets/person.jpg"),
                          radius: 30,
                        ),
                        contentPadding: EdgeInsets.only(left: 35.0, top: 15.0),
                        title: Text("Tom Riddle \n+941578444"),
                        subtitle: Text("Email"),
                      ),
                      ButtonTheme(
                        child: FlatButton(
                          child: Text("Edit"),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfileView()));
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  child: Column(children: <Widget>[
                    ListTile(
                      title: Text("Notification"),
                      leading: Icon(Icons.notifications),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationView()));
                      },
                    ),
                    ListTile(
                      title: Text("Privacy/Security"),
                      leading: Icon(Icons.lock_outline),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text("Help"),
                      leading: Icon(Icons.help_outline),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text("About"),
                      leading: Icon(Icons.info_outline),
                      onTap: () {},
                    ),
                  ]),
                ),
                Card(
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
          ),
        ),
      ),
    );
  }
}
