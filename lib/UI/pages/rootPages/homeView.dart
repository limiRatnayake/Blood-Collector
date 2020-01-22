import 'package:blood_collector/UI/pages/rootPages/viewDetails.dart';

import 'package:flutter/material.dart';

import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
