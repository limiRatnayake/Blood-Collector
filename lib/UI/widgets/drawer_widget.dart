//pages
import 'package:blood_collector/UI/pages/rootPages/savedEventView.dart';
import 'package:blood_collector/UI/pages/rootPages/map_view.dart';
import 'package:blood_collector/UI/pages/rootPages/request_history.dart';
import 'package:blood_collector/UI/pages/rootPages/settingView.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:blood_collector/UI/widgets/home_widget.dart';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthServices _authServices = Provider.of<AuthServices>(context);

    final UserService _userService = Provider.of<UserService>(context);

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
                    child: FutureBuilder<DocumentSnapshot>(
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
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    data.proPicUrl,
                                  ),
                                  radius: 50.0,
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Center(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        data.firstName + " " + data.lastName,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        data.email,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.0),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          }
                        })),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RequestHistory()));
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
            title: Text("Save Events"),
            leading: Icon(Icons.bookmark),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SavedEventView()));
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
                  onTap: () async {
                    await _authServices.logOut();
                    Navigator.pushReplacementNamed(
                        context, AppConstants.SPLASH);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
