import 'package:flutter/material.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                            radius: 30,
                            backgroundImage: AssetImage("assets/backgroundImage.jpg"),
                            
                            ),
                        contentPadding: EdgeInsets.only(left: 35.0, top: 15.0),
                        title: Text("Tom Riddle \n+941578444"),
                        subtitle: Text("Email"),
                      ),
                      ButtonTheme(
                        child: FlatButton(
                          child: Text("Edit"),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.picture_in_picture),
                    title: Text("Name"),
                    subtitle: Text("Reason"),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.picture_in_picture),
                    title: Text("Name"),
                    subtitle: Text("Reason"),
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
