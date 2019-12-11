import 'package:flutter/material.dart';

class PostView extends StatefulWidget {
  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  List<String> countries = ['INDIA', 'USA', 'JAPAN'];
  String _countries = 'INDIA';

  void something(String value) {
    setState(() {
      _countries = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(100.0),
            ),
            DropdownButton(
              onChanged: (String value) {
                something(value);
              },
              value: _countries,
              items: countries.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
