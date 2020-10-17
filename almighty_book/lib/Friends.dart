import 'package:flutter/material.dart';
import 'Suggestions.dart';

class Friends extends StatefulWidget {
  String id;

  Friends({this.id});

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {


  bool friendsSelected = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Suggestions(id: widget.id),
        Text("You do not have any friends",
            style: TextStyle(
                fontFamily: 'Raleway-Bold',
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.bold)),



      ],
    );


  }
}
