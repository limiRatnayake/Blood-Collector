import 'package:blood_collector/UI/widgets/participantListViewWidget.dart';
import 'package:blood_collector/models/participant_model.dart';
import 'package:blood_collector/services/event_participant_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfParticipantView extends StatefulWidget {
  final String docRef;

  ListOfParticipantView({
    Key key,
    this.docRef,
  }) : super(key: key);
  @override
  _ListOfParticipantViewState createState() => _ListOfParticipantViewState();
}

class _ListOfParticipantViewState extends State<ListOfParticipantView> {
  TextEditingController _searchController = TextEditingController();
  CollectionReference eventRef;
  List _allParticipants = [];
  List _resultsList = [];
  Future resultsLoaded;
  var data;
  @override
  void initState() {
    super.initState();
    //listen to the changes that happens in the searchController and listen to the changes
    _searchController.addListener(_onSearchChanged);
    eventRef = Firestore.instance.collection("events");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    /**getUsersPastTripsStreamSnapshots returns a future and it's async function
     * so, it can't access in initState that's why we have to call it inhere
     * bcz we are calling firebase data 
     */
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }

  @override
  void dispose() {
    //clean up the listener and remove the listerner when we leave the page
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
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
    setState(() {
      _resultsList = showSearchResults;
    });
  }

  getUsersPastTripsStreamSnapshots() async {
    /** we are not using a futurebuilder bcz search should be done on the potential data that has loaded
     * when everytime someone is searching we do not needed to access firebase and seacrh all the documents in the firebase 
     * so, from the loaded data seach is implemented
     */
    data = await Firestore.instance
        .collection('participants')
        .where("docRef", isEqualTo: widget.docRef)
        .getDocuments();
    setState(() {
      //adding the document data into a list
      _allParticipants = data.documents;
    });
    searchResultsList();
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    final EventParticipantService _participantServices =
        Provider.of<EventParticipantService>(context);

    return Scaffold(
      appBar: AppBar(
        // actionsIconTheme: null,
        iconTheme: IconThemeData(color: Colors.black),

        title: Text("Participant List"),
      ),
      body: Column(
        children: [
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
                      context, _resultsList[index], eventRef);
                }),
          )
        ],
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
