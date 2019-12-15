import 'package:flutter/material.dart';

class PostView extends StatefulWidget {
  @override
  _PostViewState createState() => _PostViewState();
}

Widget _descriptionTextField() {
  return Container(
      child: Padding(
          padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
          child: TextField(
            maxLines: 100,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Enter a search term'),
          )));
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            "Create Post",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.3,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                child: Text(
                  "POST",
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                onTap: () {},
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(child: _descriptionTextField()),
                // Center(
                //   child: IconButton(
                //     icon: Icon(Icons.keyboard_arrow_up),
                //     onPressed: () {},
                //   ),),
                Container(
                  child: Column(
                    children: <Widget>[
                      IconButton(
                    icon: Icon(Icons.keyboard_arrow_up),
                    onPressed: () {},
                  ),
                      TextFormField(
                        enabled: false,
                        
                        decoration: InputDecoration(
                            hintText: "Enter the hospital name",
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              fontFamily: "Roboto",
                            ),
                            enabledBorder: InputBorder.none),
                      ),
                    ],
                  ),
                ),
                
                
              ],
            ),
          ),
        );
  }
}
