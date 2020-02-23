import 'package:blood_collector/UI/pages/rootPages/editProfileView.dart';
import 'package:blood_collector/UI/pages/rootPages/notificationView.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/shared/appConstant.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    final AuthServices _authServices = Provider.of<AuthServices>(context);
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
                Container(
                  height: 150.0,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 35.0, top: 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/person.jpg"),
                                minRadius: 30,
                                maxRadius: 45,
                              ),
                              SizedBox(
                                width: 25.0,
                              ),
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Azenz Allibe Dongro"),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text("+94 165252326"),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text("Email"),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            child: Text(
                              "Edit",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 18.0),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfileView()));
                            },
                          ),
                        ],
                      ),
                    ),
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
                          onTap: () async{
                           
                             await  _authServices.logOut();
                              Navigator.pushReplacementNamed(
                                  context, AppConstants.SPLASH);
                            
                          }),
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
