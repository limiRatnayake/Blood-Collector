//pages
import 'package:blood_collector/UI/pages/rootPages/userProfileSetting/editProfileView.dart';
import 'package:blood_collector/UI/widgets/filterOptions/filterChoiceChipWidget.dart';
import 'package:blood_collector/UI/widgets/filterOptions/filterOptionsWidget.dart';
import 'package:blood_collector/UI/widgets/timelinePostsCard/postWidget.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class TimelineView extends StatefulWidget {
  @override
  _TimelineViewState createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  User user;
  EventService _eventServices;
  AuthServices _authService;
  String selectedFilter;
  String selectedArea = 'All';
  String currentUser;
  String resultValue;

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
    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot result) {
      if (result["dateOfLastDonation"] != "") {
        var lastDonatedMonth = DateTime.parse(result["dateOfLastDonation"]);
        var currentMonth = DateTime.now();

        var differenceInDays = currentMonth.difference(lastDonatedMonth).inDays;
        var differenceOfMonth = (differenceInDays) ~/ 30;
        print(differenceOfMonth);

        if (differenceOfMonth >= 4) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .update({"lastDonationDateCheck": true});
        }
      }
      if (result["address"] == "") {
        Future<Null>.delayed(Duration.zero, () {
          Scaffold.of(context).showSnackBar(
            new SnackBar(
              content: new Text("Please, Add your address & other details"),
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
    });

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
                  resultValue: resultValue,
                  parentAction: _updateSelectedValues,
                )),
          ),
        ),
        selectedFilter == "Campaigns"
            ? SliverPadding(
                padding: const EdgeInsets.all(10.0),
                sliver: SliverToBoxAdapter(
                  child: Container(
                      alignment: Alignment.topLeft,
                      child: RichText(
                        text: TextSpan(
                          text: 'Filter As ',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: selectedArea,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )),
                ),
              )
            : SliverToBoxAdapter(
                child: Container(),
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
                .map<EventModel>((doc) => EventModel.fromMap(doc.data()))
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

//  Container(
//                                   padding: EdgeInsets.all(10),
//                                   alignment: Alignment.topLeft,
//                                   child: RichText(
//                                     text: TextSpan(
//                                       text: 'Filter As ',
//                                       style: TextStyle(
//                                           fontSize: 20, color: Colors.black),
//                                       children: <TextSpan>[
//                                         TextSpan(
//                                             text: selectedArea,
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold)),
//                                       ],
//                                     ),
//                                   )),
