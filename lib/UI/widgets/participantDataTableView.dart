import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParticipantDataTableView extends StatefulWidget {
  final String uid;
  ParticipantDataTableView({
    Key key,
    this.uid,
  }) : super(key: key);
  @override
  _ParticipantDataTableViewState createState() =>
      _ParticipantDataTableViewState();
}

class _ParticipantDataTableViewState extends State<ParticipantDataTableView> {
  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);
    print(widget.uid);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FutureBuilder(
          future: _userService.getUsersForParticipantList(widget.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              // List<UserModel> users = snapshot.data.documents
              //     .map<UserModel>((doc) => UserModel.fromMap(doc.data))
              //     .toList();
              List<UserModel> users = snapshot.data;
              List<DataRow> dataRowItems = [];
              for (int i = 0; i < users.length; i++) {
                dataRowItems.add(DataRow(cells: [
                  DataCell(
                    Text(users[i].firstName),
                  ),
                  DataCell(
                    Text(users[i].lastName),
                  )
                ]));
              }
              return users.length > 0
                  ? DataTable(columns: [
                      DataColumn(
                        label: Text("First Name"),
                      ),
                      DataColumn(label: Text("Last Name")),
                    ], rows: dataRowItems.toList())
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
    );
  }
}
