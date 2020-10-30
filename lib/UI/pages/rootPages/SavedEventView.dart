import 'package:blood_collector/UI/widgets/savedEventWidget.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/save_event_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_widget_guide/utils.dart';

class SavedEventView extends StatefulWidget {
  @override
  _SavedEventViewState createState() => _SavedEventViewState();
}

class _SavedEventViewState extends State<SavedEventView> {
  UserService _userService;
  EventService _eventServices;
  AuthServices _authService;
  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);
    _authService = Provider.of<AuthServices>(context);

    _eventServices = Provider.of<EventService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved"),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          ///First sliver is the App Bar
          // SliverAppBar(
          //   ///Properties of app bar
          //   backgroundColor: Colors.white,
          //   floating: false,
          //   pinned: true,
          //   expandedHeight: 200.0,
          getImagesList()
          //   ///Properties of the App Bar when it is expanded
          //   flexibleSpace: FlexibleSpaceBar(
          //     centerTitle: true,
          //     title: Text(
          //       "SliverGrid Widget",
          //       style: TextStyle(
          //         color: Colors.black87,
          //         fontSize: 20.0,
          //         fontWeight: FontWeight.bold,
          //         // fontFamily: Utils.ubuntuRegularFont
          //       ),
          //     ),
          //     background: Container(
          //       decoration: BoxDecoration(
          //         border: Border(
          //           top: BorderSide(
          //             color: Colors.black26,
          //             width: 1.0,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget listItem(String title) => Container(
        height: 100.0,
        color: Colors.blue.shade200,
        child: Center(
          child: Text(
            "$title",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
              // fontFamily: Utils.ubuntuRegularFont
            ),
          ),
        ),
      );

  Widget getImagesList() {
    // List<ImageModel> images;
    return FutureBuilder(
        future: _userService.getSavedEvents(_authService.user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text("No saved events found"),
              ),
            );
          } else {
            List<SavedEventModel> dataList = snapshot.data.documents
                .map<SavedEventModel>(
                    (doc) => SavedEventModel.fromMap(doc.data))
                .toList();

            return SliverPadding(
              padding: EdgeInsets.only(left: 15, right: 15),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (2 / 3),
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    var data = dataList[index];

                    return SaveEventTile(docRef: data.docRef);
                  },
                  childCount: dataList.length,
                ),
              ),
            );
          }
        });
  }
}
