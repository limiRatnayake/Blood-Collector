import 'package:blood_collector/UI/pages/rootPages/viewDetails.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';

class HomeTimelineView extends StatefulWidget {
  @override
  _HomeTimelineViewState createState() => _HomeTimelineViewState();
}

class _HomeTimelineViewState extends State<HomeTimelineView> {
 AuthServices _authServices;

 @override
  void initState() {
   
  _stateLoadingApp();
   
    super.initState();
    // new Future.delayed(const Duration(seconds: 2));
  }
  @override
  Widget build(BuildContext context) {
    _authServices = Provider.of<AuthServices>(context);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: AppTopBar(title: "Home")),
        drawer: DrawerWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  height: 400.0,
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage("assets/person.jpg"),
                            minRadius: 30,
                            maxRadius: 35,
                          ),
                          title: Text("Azenz Allibe Dongro"),
                          subtitle: Text("15 min"),
                          trailing: IconButton(icon: Icon(Icons.more_horiz),
                          onPressed: (){},),
                        ),
                        Container(
                          height: 250.0,
                          
                          child: Image.asset(
                            'assets/cam2.png',
                            fit: BoxFit.fill,
                          ),
                          margin: EdgeInsets.all(10),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.map),
                                    onPressed: (){},
                                  ),
                                  Text("Map")
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewDetails()));
                                    },),
                                  Text("View")
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.favorite_border),
                                    onPressed: (){},),
                                  Text("Like")
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }

  //keep app load until user signout
  _stateLoadingApp() {
    // FirebaseAuth.instance.currentUser().then((user) {
    //   if(user == null){
    //   Navigator.pushReplacementNamed(context, AppConstants.AUTH);
    //   }
    // });
// FirebaseAuth.instance.onAuthStateChanged.listen();
  }
  // FirebaseAuth.instance.currentUser().then((user) => user != null
  //       ? print("User login")
  //       : );

  // }
}

