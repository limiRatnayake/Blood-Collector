import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaveEventTile extends StatefulWidget {
  final String docRef;
  SaveEventTile({Key key, this.docRef}) : super(key: key);
  @override
  _SaveEventTileState createState() => _SaveEventTileState();
}

class _SaveEventTileState extends State<SaveEventTile> {
  UserService _userService;
  EventService _eventServices;
  AuthServices _authService;
  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);
    _authService = Provider.of<AuthServices>(context);

    _eventServices = Provider.of<EventService>(context);
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, 'wallpaper', arguments: image);
      },
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Container(
          width: 136,
          child: Stack(
            overflow: Overflow.clip,
            fit: StackFit.expand,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5, bottom: 5),
                child: FutureBuilder(
                    future: _eventServices.getSavedEvents(widget.docRef),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        EventModel data =
                            EventModel.fromMap(snapshot.data.data);
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(-5, 16),
                                blurRadius: 17,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/img/loading.png',
                              image: data.imageUrl,
                              placeholderScale: 2,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }
                    }),
              ),
              Positioned.fill(
                bottom: 20,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RawMaterialButton(
                    onPressed: () {},
                    child: new Icon(
                      Icons.remove_red_eye,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    constraints:
                        const BoxConstraints(minHeight: 20, minWidth: 20),
                    shape: new CircleBorder(),
                    elevation: 0,
                    fillColor: Colors.black38,
                    padding: const EdgeInsets.all(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
