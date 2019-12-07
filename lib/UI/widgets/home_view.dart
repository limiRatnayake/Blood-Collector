import 'package:flutter/material.dart';

import 'package:blood_collector/UI/widgets/map_view.dart';
import 'package:blood_collector/UI/widgets/settings.dart';



class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white70,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.redAccent),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            color: Colors.grey,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.grey,
            onPressed: () {},
          ),
        ],
      ),
      drawer: 
      // Theme(
      //   data: ThemeData(
      //     canvasColor:
      //         Colors.red, //This will change the drawer background to red.
      //   ),
        Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/drawer.PNG"),
                        fit: BoxFit.fill),
                  ),
                  child: DrawerHeader(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: AssetImage("assets/person.jpg"),
                            radius: 50.0,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Center(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Aurélien Salomon",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "@aureliensalomon",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10.0),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              ListTile(
                title: Text("Home"),
                leading: Icon(Icons.home),
                onTap: (){
                   Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              ListTile(
                title: Text("History"),
                leading: Icon(Icons.history),
                onTap: (){
                  Navigator.push(
              context, MaterialPageRoute(builder: (context) => ListView()));
                },
              ),
              ListTile(
                title: Text("Map"),
                leading: Icon(Icons.map),
                onTap: (){
                   Navigator.push(
              context, MaterialPageRoute(builder: (context) => MapView()));
                },
              ),
              ListTile(
                title: Text("Setting"),
                leading: Icon(Icons.settings),
                onTap: (){
                   Navigator.push(
              context, MaterialPageRoute(builder: (context) => SettingView()));
                },
              ),
              Divider(thickness: 1.0,),
              Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text("FAQ's"),
                      onTap: (){

                      },
                    ),
                    ListTile(
                      title: Text("How to use"),
                      onTap: (){},
                    ),
                    ListTile(
                      title: Text("Terms of services"),
                      onTap: (){},
                    ),
                    ListTile(
                      title: Text("Privacy Policy"),
                      onTap: (){},
                    ),
                    ListTile(
                      title: Text("Log Out"),
                      onTap: (){},
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

      body: Container(
        child:Center()
      ),

      
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTab,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text('List')),
            BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Map')),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text('Settings')),
          ],
          onTap: (int index) {
            setState(() {
              _currentTab = index;
               
            });
            
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        tooltip: 'Add a post',
      ),
    );
  }
}
