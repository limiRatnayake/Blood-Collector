import 'package:blood_collector/UI/widgets/signin_view.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(3, 6)) //BoxShadow
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: ListView(children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 180.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/backgroundImage.jpg"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(45.0, 15.0),
                      bottomRight: Radius.elliptical(45.0, 15.0)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text('Blood Collector',
                            style: TextStyle(
                                fontFamily: "Raleway", fontSize: 35.0)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 58,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Roboto",
                  ),
                  enabledBorder: InputBorder.none),
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  value.isEmpty ? 'Name should be filled' : null,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          width: double.infinity,
          height: 58,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Organzation Name",
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Roboto",
                  ),
                  enabledBorder: InputBorder.none),
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  value.isEmpty ? 'Name should be filled' : null,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          width: double.infinity,
          height: 58,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Mobile No",
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Roboto",
                  ),
                  enabledBorder: InputBorder.none),
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  value.isEmpty ? 'Name should be filled' : null,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          width: double.infinity,
          height: 58,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "City",
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Roboto",
                  ),
                  enabledBorder: InputBorder.none),
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  value.isEmpty ? 'Name should be filled' : null,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          width: double.infinity,
          height: 58,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Posatl Address",
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Roboto",
                  ),
                  enabledBorder: InputBorder.none),
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  value.isEmpty ? 'Name should be filled' : null,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          width: double.infinity,
          height: 58,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, left: 24, right: 16),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Roboto",
                  ),
                  enabledBorder: InputBorder.none),
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  value.isEmpty ? 'Name should be filled' : null,
            ),
          ),
        ),
        SizedBox(
          height: 23.0,
        ),
        Container(
          width: double.infinity,
          height: 58,
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: _boxDecoration(),
          child: ButtonTheme(
            child: RaisedButton(
              elevation: 0.0,
              child: Text("SIGNUP",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 18.0,
                      color: Colors.black)),
              textColor: Colors.black,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.5)),
              onPressed: () => {
                Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SigninPage()),
      )
              },
            ),
          ),
        ),
      ]),
    );
  }
}
