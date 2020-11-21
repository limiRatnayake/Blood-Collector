import 'package:blood_collector/UI/pages/rootPages/exploreMore/exploreCampaignMore.dart';
import 'package:blood_collector/UI/widgets/participantListViewWidget.dart';
import 'package:blood_collector/models/participant_model.dart';
import 'package:blood_collector/services/event_participant_service.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ListOfParticipantView extends StatefulWidget {
  final String uid;
  final String docRef;
  final int totalEngage;
  final int actualEngage;
  final int avoidParticipants;
  final String submitListStatus;

  ListOfParticipantView({
    Key key,
    this.uid,
    this.docRef,
    this.totalEngage,
    this.actualEngage,
    this.avoidParticipants,
    this.submitListStatus,
  }) : super(key: key);
  @override
  _ListOfParticipantViewState createState() => _ListOfParticipantViewState();
}

class _ListOfParticipantViewState extends State<ListOfParticipantView> {
  TextEditingController _searchController = TextEditingController();
  CollectionReference eventRef;
  CollectionReference userRef;
  ParticipantModel participants;
  List _allParticipants = [];
  List _resultsList = [];
  Future resultsLoaded;

  EventParticipantService _participantService;
  EventService _eventService;
  var data;
  @override
  void initState() {
    super.initState();
    //listen to the changes that happens in the searchController and listen to the changes
    _searchController.addListener(_onSearchChanged);
    eventRef = Firestore.instance.collection("events");
    userRef = Firestore.instance.collection("users");
  }

  @override
  void dispose() {
    //clean up the listener and remove the listerner when we leave the page
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    /**getUsersPastTripsStreamSnapshots returns a future and it's async function
     * so, it can't access in initState that's why we have to call it inhere
     * bcz we are calling firebase data 
     */
    resultsLoaded = getUsersPastTripsStreamSnapshots();
    super.didChangeDependencies();
  }

  _onSearchChanged() {
    searchResultsList();
  }

//it set the _resultsList to values that we want from the _allParticipants list
/* we call this function in two places 
 * first, getUsersPastTripsStreamSnapshots() when firebase is calling
 * after the changes also we should call it _onSearchChanged()
*/
  searchResultsList() {
    var showSearchResults = [];

    if (_searchController.text != "") {
      //we have a seacrh parameter
      for (var participantSnapshot in _allParticipants) {
        //search from the participant name
        var participantName = ParticipantModel.fromMap(participantSnapshot.data)
            .participantName
            .toLowerCase();

        if (participantName.contains(_searchController.text.toLowerCase())) {
          showSearchResults.add(participantSnapshot);
        }
      }
    } else {
      showSearchResults = List.from(_allParticipants);
    }
    if (mounted) {
      setState(() {
        _resultsList = showSearchResults;
      });
    }
  }

  Future getUsersPastTripsStreamSnapshots() async {
    /** we are not using a futurebuilder bcz search should be done on the potential data that has loaded
     * when everytime someone is searching we do not needed to access firebase and seacrh all the documents in the firebase 
     * so, from the loaded data seach is implemented
     */
    data = await Firestore.instance
        .collection('participants')
        .where("docRef", isEqualTo: widget.docRef)
        .getDocuments();
    if (mounted) {
      setState(() {
        //adding the document data into a list
        _allParticipants = data.documents;
      });
    }

    searchResultsList();
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    final EventService _eventService = Provider.of<EventService>(context);
    final EventParticipantService _participantService =
        Provider.of<EventParticipantService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Participant List"),
        // actions: [FlatButton(onPressed: show, child: Text("Submit"))],
      ),
      // appBar: widget.submitListStatus != "submitted"
      //     ? PreferredSize(
      //         preferredSize: const Size(double.infinity, kToolbarHeight),
      //         child: SubmitAppTopBar(
      //             title: "Settings", docRef: widget.docRef, uid: widget.uid))
      //     : PreferredSize(
      //         preferredSize: const Size(double.infinity, kToolbarHeight),
      //         child: AppBar(
      //           title: Text("Actual Participant List"),
      //         )),

      body: Builder(
        builder: (builderContext) => Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.blue.shade300,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      child: Text(
                    "After updating all the participant details don't forget to click the submit button",
                    style: TextStyle(color: Colors.grey.shade700),
                  )),
                  FlatButton(
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Alert(
                          context: builderContext,
                          type: AlertType.success,
                          title:
                              "Make sure that you have update all the users!",
                          content: Text("You may not able to change it again!"),
                          style: AlertStyle(
                              backgroundColor: Colors.white,
                              alertBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: Colors.white)),
                              titleStyle: TextStyle(color: Colors.blueAccent)),
                          buttons: [
                            DialogButton(
                                width: 120,
                                child: Text(
                                  "Ok",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  //use pop route here becuase in slider_widget it should update & come back to same page
                                  Navigator.pop(context);
                                }),
                            DialogButton(
                                child: Text("Submit"),
                                onPressed: () async {
                                  List<ParticipantModel> participants =
                                      await _participantService
                                          .getParticipantForParticularEvent(
                                              widget.docRef);
                                  for (var i = 0;
                                      i < participants.length;
                                      i++) {
                                    await Firestore.instance
                                        .runTransaction((tx) async {
                                      DocumentSnapshot docSnapshot =
                                          await tx.get(userRef
                                              .document(participants[i].uid));
                                      if (docSnapshot.exists) {
                                        int donatedCount = docSnapshot
                                            .data['ifYesHowManyTimes'];

                                        await tx.update(
                                            userRef
                                                .document(participants[i].uid),
                                            {
                                              "userPreviouslyDonatedOrNot":
                                                  "Yes",
                                              "dateOfLastDonation":
                                                  DateTime.now().toString(),
                                              "lastDonationDateCheck": false,
                                              'ifYesHowManyTimes':
                                                  donatedCount + 1
                                            });
                                      }
                                    });
                                  }
                                  String response =
                                      await _eventService.addSubmitState(
                                    widget.docRef,
                                  );
                                  if (response != "Success") {
                                    print("Error in the submit button");
                                  } else {
                                    Navigator.of(context)
                                        .push(new MaterialPageRoute(
                                            builder: (_) => ExploreCampaignMore(
                                                  docRef: widget.docRef,
                                                  uid: widget.uid,
                                                )));
                                  }
                                })
                          ]).show();

                      // Alert(
                      //     context: context,
                      //     type: AlertType.success,
                      //     title:
                      //         "Make sure that you have update all the users!",
                      //     content: Text(
                      //         "You may not able to change it again!"),
                      //     style: AlertStyle(
                      //         backgroundColor: Colors.black,
                      //         alertBorder: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(5),
                      //             side: BorderSide(color: Colors.white)),
                      //         titleStyle:
                      //             TextStyle(color: Colors.blueAccent)),
                      //     buttons: [
                      //       DialogButton(
                      //           width: 120,
                      //           child: Text(
                      //             "Ok",
                      //             style: TextStyle(
                      //                 color: Colors.white, fontSize: 20),
                      //           ),
                      //           onPressed: () {
                      //             //use pop route here becuase in slider_widget it should update & come back to same page
                      //             Navigator.pop(context);
                      //           }),
                      //       DialogButton(
                      //           width: 120,
                      //           child: Text(
                      //             "Submit",
                      //             style: TextStyle(
                      //                 color: Colors.white, fontSize: 20),
                      //           ),
                      //           onPressed: () async {
                      //             List<ParticipantModel> participants =
                      //                 await _participantService
                      //                     .getParticipantForParticularEvent(
                      //                         widget.docRef);

                      //             for (var i = 0;
                      //                 i < participants.length;
                      //                 i++) {
                      //               // participantId = participants[i].uid;

                      //               // print(participantId);
                      //               String response = await _eventService
                      //                   .addSubmitState(widget.docRef,
                      //                       participants[i].uid);
                      //               if (response != "Success") {
                      //                 print("Error in the submit button");
                      //               } else {
                      //                     Navigator.of(context).push(
                      // new MaterialPageRoute(
                      //     builder: (_) =>
                      //         SubmittedParticipantListView(
                      //           docRef: widget.docRef,
                      //         )));
                      //               }
                      //             }
                      //           })
                      //     ]).show();
                    },
                  )
                ],
              ),
            ),

            //search textfield
            Padding(
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      color: Colors.black,
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    border: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Name"),
                Text("Participated/" + "\n" + "Not Participated"),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _resultsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildParticipantsList(
                        context,
                        _resultsList[index],
                        eventRef,
                        userRef,
                        widget.docRef,
                        widget.totalEngage,
                        widget.actualEngage,
                        widget.avoidParticipants);
                  }),
            )
          ],
        ),
      ),
      // body: FutureBuilder(
      //     future: _participantServices.getParticipantForAnEvent(widget.docRef),
      //     builder: (context, snapshot) {
      //       if (!snapshot.hasData) {
      //         return Center(child: CircularProgressIndicator());
      //       } else {
      //         List<ParticipantModel> dataList = snapshot.data.documents
      //             .map<ParticipantModel>(
      //                 (doc) => ParticipantModel.fromMap(doc.data))
      //             .toList();
      //         return dataList.length > 0
      //             ? Column(
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.only(
      //                         left: 30.0, right: 30.0, bottom: 30.0),
      //                     child: TextField(
      //                       controller: _searchController,
      //                       decoration:
      //                           InputDecoration(prefixIcon: Icon(Icons.search)),
      //                     ),
      //                   ),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                     // crossAxisAlignment: CrossAxisAlignment.stretch,
      //                     children: [
      //                       Text("Name"),
      //                       Text("Participated/" + "\n" + "Not Participated"),
      //                     ],
      //                   ),
      //                   Expanded(
      //                     child: ListView.builder(
      //                         shrinkWrap: true,
      //                         itemCount: dataList.length,
      //                         itemBuilder: (context, index) {
      //                           ParticipantModel data = dataList[index];

      //                           return ParticipantListView(
      //                               uid: data.uid,
      //                               docRef: data.docRef,
      //                               participantId: data.participantId,
      //                               participatedStatus:
      //                                   data.participatedStatus);
      //                         }),
      //                   )
      //                 ],
      //               )
      //             : Padding(
      //                 padding: EdgeInsets.all(15),
      //                 child: Center(
      //                   child: Text(
      //                     "Please check again later.",
      //                     textAlign: TextAlign.center,
      //                   ),
      //                 ),
      //               );
      //       }
      //     }),
    );
  }
}
