//pages
import 'package:blood_collector/UI/widgets/bookmarkView/savedEventWidget.dart';
import 'package:blood_collector/models/save_event_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/user_service.dart';

//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_widget_guide/utils.dart';

class SavedEventView extends StatefulWidget {
  @override
  _SavedEventViewState createState() => _SavedEventViewState();
}

class _SavedEventViewState extends State<SavedEventView> {
  UserService _userService;

  AuthServices _authService;
  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);
    _authService = Provider.of<AuthServices>(context);

    return Scaffold(
      body: Container(
          child: CustomScrollView(
        slivers: [
          SliverAppBar(
            // expandedHeight: 156.0,
            title: Text(
              "Saved Event",
            ),
          ),
          getImagesList()
        ],
      )),
    );
  }

  Widget getImagesList() {
    // List<ImageModel> images;
    return FutureBuilder(
        future: _userService.getSavedEvents(_authService.user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //conatins a single box widget
            return SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text("No saved events found"),
                ),
              ),
            );
          } else {
            List<SavedEventModel> dataList = snapshot.data.documents
                .map<SavedEventModel>(
                    (doc) => SavedEventModel.fromMap(doc.data()))
                .toList();

            return dataList.length > 0
                ? SliverPadding(
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
                  )
                : SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Center(child: Text("No saved events found")),
                    ),
                  );
          }
        });
  }
}
