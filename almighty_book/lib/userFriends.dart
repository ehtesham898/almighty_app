import 'package:AlmightyBook/User.dart';
import 'package:AlmightyBook/suggestions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserFriends extends StatefulWidget {
  String id;
  String name;
  UserFriends({this.id, this.name});

  @override
  _UserFriendsState createState() => _UserFriendsState();
}

class _UserFriendsState extends State<UserFriends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown.withOpacity(0.5),
        appBar: AppBar(title: Text("Friends List")),
        body: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${widget.name}'s friends",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
              ),
              color: Colors.amber.withOpacity(0.7),
            ),
            Container(
              child: Suggestions(id: widget.id,),
            )
          ],
        )


    );
  }
}
