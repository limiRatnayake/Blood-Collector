import 'package:blood_collector/UI/pages/rootPages/editPassword_view.dart';
import 'package:blood_collector/UI/pages/rootPages/editProfileView.dart';
import 'package:blood_collector/UI/pages/rootPages/notificationView.dart';
import 'package:blood_collector/UI/widgets/bottom_navigator.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final UserService _userService = Provider.of<UserService>(context);
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FutureBuilder<DocumentSnapshot>(
                          future: _userService
                              .requestUserDetails(_authServices.user.uid),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              UserModel data =
                                  UserModel.fromMap(snapshot.data.data);
                              return Column(
                                children: <Widget>[
                                  Center(
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.grey,
                                      backgroundImage: NetworkImage(
                                        data.proPicUrl,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(data.firstName + " " + data.lastName),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(data.email),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  data.userRole != "User"
                                      ? RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: data.userRole,
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style),
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.stars,
                                                  size: 14,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Text("Blood Group: " + data.bloodGroup),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  InkWell(
                                    child: Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18.0),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfileView()));
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              );
                            }
                          })
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EdiPasswordView()));
                      },
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
                          onTap: () async {
                            await _authServices.logOut();
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
