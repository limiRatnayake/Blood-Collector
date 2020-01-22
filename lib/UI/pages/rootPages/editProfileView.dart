import 'package:flutter/material.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actionsIconTheme: null,
          leading: Container(
            child: Icon(Icons.check),
          ),
          title: Text("Edit Profile"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 180.0,
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
                      SizedBox(
                        height: 15.0,
                      ),
                      Center(
                        child: InkWell(
                          child: Text(
                            "Change Profile Photo",
                            style:
                                TextStyle(color: Colors.blue, fontSize: 16.0),
                          ),
                          onTap: () {},
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      child: ListTile(
                        title: Text("Name"),
                        subtitle: TextField(),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Card(
                      child: ListTile(
                        title: Text("Email Address"),
                        subtitle: TextField(),
                      ),
                    ),
                     SizedBox(
                      height: 10.0,
                    ),
                    Card(
                      child: ListTile(
                        title: Text("Phone Number"),
                        subtitle: TextField(),
                      ),
                    ),
                     SizedBox(
                      height: 10.0,
                    ),
                    Card(
                      child: ListTile(
                        title: Text("Gender"),
                        subtitle: TextField(),
                      ),
                    ),
                     SizedBox(
                      height: 10.0,
                    ),
                    Card(
                      child: ListTile(
                        title: Text("Blood Group"),
                        subtitle: TextField(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
