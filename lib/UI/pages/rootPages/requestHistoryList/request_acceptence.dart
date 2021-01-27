//pages
import 'package:blood_collector/UI/widgets/requestAcceptenceCard/request_accept_widget.dart';
import 'package:blood_collector/models/request_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/request_service.dart';

//packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AcceptRequestView extends StatefulWidget {
  @override
  _AcceptRequestViewState createState() => _AcceptRequestViewState();
}

class _AcceptRequestViewState extends State<AcceptRequestView> {
  @override
  Widget build(BuildContext context) {
    final AuthServices _authServices = Provider.of<AuthServices>(context);
    final RequestAcceptenceService _requestServices =
        Provider.of<RequestAcceptenceService>(context);

    return Scaffold(
      body: Container(
        // padding: EdgeInsets.only(left: 10, right: 10, top: 45),
        child: FutureBuilder(
            future: _requestServices.getRequestsList(_authServices.user.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                List<RequestAcceptModel> requestsItems = snapshot.data;

                return requestsItems.length != 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: ListView.builder(
                                  itemCount: requestsItems.length,
                                  itemBuilder: (context, index) {
                                    RequestAcceptModel data =
                                        requestsItems[index];
                                    print(data.requesterId);
                                    return AcceptRequestCard(
                                        docRef: data.docRef,
                                        requesterId: data.requesterId,
                                        requestSentOn: data.requestSentOn,
                                        requestStatus: data.requestStatus,
                                        participantsID: data.participantsID);
                                  }))
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.all(15),
                        child: Center(
                          child: Text(
                            "Please check again later.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
              }
            }),
      ),
    );
  }
}
