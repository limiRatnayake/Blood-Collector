import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostView extends StatefulWidget {
  final String imageUrl;
  final String uid;
  final String docRef;
  final String description;
  final String createdAt;

  PostView(
      {Key key,
      this.imageUrl,
      this.uid,
      this.docRef,
      this.createdAt,
      this.description})
      : super(key: key);
  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  bool isLiked = false;

  _isLiked() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);

    String date;
    // print(widget.createdAt);
    //get the event created date
    var checkedTime = DateTime.parse(widget.createdAt);
    // print(dateTime);
    //get the event created time
    String roughTimeString = DateFormat('jm').format(checkedTime);

    //get the current date
    DateTime currentTime = DateTime.now();
    if ((currentTime.year == checkedTime.year) &&
        (currentTime.month == checkedTime.month) &&
        (currentTime.day == checkedTime.day)) {
      date = "TODAY";
    } else if ((currentTime.year == checkedTime.year) &&
        (currentTime.month == checkedTime.month)) {
      if ((currentTime.day - checkedTime.day) == 1) {
        date = "YESTERDAY";
      } else if ((currentTime.day - checkedTime.day) == -1) {
        date = "TOMORROW";
      } else {
        date = DateFormat('yMd').format(checkedTime) + " " + roughTimeString;
      }
    }

    return Container(
        child: Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          FutureBuilder(
              future: _userService.requestUserDetails(widget.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  UserModel data = UserModel.fromMap(snapshot.data.data);

                  return data != null
                      ? ListTile(
                          leading: GestureDetector(
                            child: CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(data.proPicUrl),
                            ),
                          ),
                          title: Text(
                            data.firstName + " " + data.lastName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            date,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500]),
                          ),
                        )
                      : Text("try again later");
                }
              }),
          // ListTile(
          //   leading: Container(
          //     child: FutureBuilder(
          //         future: _userService.requestUserDetails(widget.uid),
          //         builder: (context, snapshot) {
          //           if (!snapshot.hasData) {
          //             return Center(child: CircularProgressIndicator());
          //           } else {
          //             UserModel data = UserModel.fromMap(snapshot.data.data);
          //             print(data.proPicUrl);
          //             return data != null
          //                 ? CircleAvatar(
          //                     backgroundImage: NetworkImage(data.proPicUrl),
          //                   )
          //                 : Text("try again later");
          //           }
          //         }),
          //   ),
          //   title: const Text('Card title 1'),
          //   subtitle: Text(
          //     'Secondary Text',
          //     style: TextStyle(color: Colors.black.withOpacity(0.6)),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  _isLiked();
                },
                icon: IconButton(
                    icon: isLiked
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    onPressed: null),
              ),
              IconButton(
                onPressed: () {
                  // Perform some action
                },
                icon: IconButton(
                    icon: Icon(Icons.remove_red_eye), onPressed: null),
              ),
              IconButton(
                onPressed: () {
                  // Perform some action
                },
                icon: IconButton(icon: Icon(Icons.map), onPressed: null),
              ),
            ],
          ),
          // Image.asset()
        ],
      ),
    ));
  }

  Container porfilePicture(String uid) {
    final UserService _userService = Provider.of<UserService>(context);

    return Container(
      child: FutureBuilder(
          future: _userService.requestUserDetails(uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              UserModel data = UserModel.fromMap(snapshot.data.data);
              print(data.proPicUrl);
              return data != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(data.proPicUrl),
                    )
                  : Text("try again later");
            }
          }),
    );
  }
}
