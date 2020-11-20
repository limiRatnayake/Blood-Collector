import 'package:blood_collector/UI/pages/rootPages/editProfileView.dart';
import 'package:blood_collector/UI/widgets/filterChoiceChipWidget.dart';
import 'package:blood_collector/UI/widgets/filterOptionsWidget.dart';
import 'package:blood_collector/UI/widgets/postWidget.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class TimelineView extends StatefulWidget {
  @override
  _TimelineViewState createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  FirebaseUser user;
  EventService _eventServices;
  AuthServices _authService;
  String selectedFilter;
  String selectedArea = 'All';
  String currentUser;

  _updateSelectedValues(String selectValue) async {
    print(selectValue);
    var result;
    if (selectValue == "Campaigns") {
      result = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            //get a list of areas according to districts
            return FilterChoiceChipWidget();
          });
    }
    setState(() {
      selectedArea = result;
      selectedFilter = selectValue;
    });
  }

  @override
  void initState() {
    //ask for the user loaction
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
              Firestore.instance
                  .collection("users")
                  .document(currentUser.uid)
                  .get()
                  .then((DocumentSnapshot result) {
                if (result["dateOfLastDonation"] != null) {
                  var lastDonatedMonth =
                      DateTime.parse(result["dateOfLastDonation"]);
                  var currentMonth = DateTime.now();

                  setState(() {
                    var differenceInDays =
                        currentMonth.difference(lastDonatedMonth).inDays;
                    var differenceOfMonth = (differenceInDays) ~/ 30;

                    if (differenceOfMonth >= 4) {
                      Firestore.instance
                          .collection("users")
                          .document(currentUser.uid)
                          .updateData({"lastDonationDateCheck": true});
                    }
                  });
                }
                if (result["address"] == "") {
                  Future<Null>.delayed(Duration.zero, () {
                    Scaffold.of(context).showSnackBar(
                      new SnackBar(
                        content: new Text(
                            "Please, Add your address & other details"),
                        action: SnackBarAction(
                          label: 'Go',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfileView()));
                          },
                        ),
                      ),
                    );
                  });
                }
              })
            })
        .catchError((err) => print(err));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _eventServices = Provider.of<EventService>(context);
    _authService = Provider.of<AuthServices>(context);
    currentUser = _authService.user.uid;

    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.3),
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppTopBar(title: "Home")),
      drawer: DrawerWidget(),
      body: CustomScrollView(slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(10.0),
          sliver: SliverToBoxAdapter(
            child: Container(
                height: MediaQuery.of(context).size.width * 0.12,
                //filter the events according to selections
                child: FilterOptions(
                  parentAction: _updateSelectedValues,
                )),
          ),
        ),
        postView()
      ]),
    );
  }

  Widget postView() {
    return FutureBuilder(
        future: selectedArea == "All"
            ? _eventServices.getEvents()
            : _eventServices.filterEvents(selectedArea, selectedFilter),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text("No saved events found"),
                ),
              ),
            );
          } else {
            List<EventModel> dataList = snapshot.data.documents
                .map<EventModel>((doc) => EventModel.fromMap(doc.data))
                .toList();
            return dataList.length > 0
                ? SliverPadding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          var data = dataList[index];

                          return PostView(
                              currentUser: currentUser,
                              imageUrl: data.imageUrl,
                              uid: data.uid,
                              docRef: data.docRef,
                              description: data.description,
                              createdAt: data.createdAt,
                              category: data.category);
                        },
                        childCount: dataList.length,
                      ),
                    ),
                  )
                : SliverToBoxAdapter(
                    child: Center(
                    child: Text("No matching events"),
                  ));
          }
        });
  }
}
