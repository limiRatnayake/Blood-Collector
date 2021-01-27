//pages
import 'package:blood_collector/UI/pages/rootPages/notificationView/notificationView.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/user_service.dart';

//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppTopBar extends StatefulWidget {
  final String title;

  AppTopBar({@required this.title});

  @override
  _AppTopBarState createState() => _AppTopBarState();
}

class _AppTopBarState extends State<AppTopBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, kToolbarHeight),
      child: AppBar(
        iconTheme: new IconThemeData(color: Colors.red[600]),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.red[600]),
        ),
        actions: <Widget>[appBarIcon()],
      ),
    );
  }

  Widget appBarIcon() {
    final AuthServices _authService = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);

    return FutureBuilder(
        future: _userService.requestUserDetails(_authService.user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            UserModel data = UserModel.fromMap(snapshot.data.data());

            return Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications),
                  color: Colors.red[600],
                  iconSize: 30,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationView()));
                  },
                ),
                data.notificationCount != 0
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        // height: MediaQuery.of(context).size.height * 0.3,
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(top: 3),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                              border:
                                  Border.all(color: Colors.white, width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(data.notificationCount.toString()),
                          ),
                        ))
                    : Container()
              ],
            );
          }
        });
  }
}
