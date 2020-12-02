import 'package:AlmightyBook/suggestions.dart';
import 'package:flutter/material.dart';

class Follower extends StatefulWidget {
  String id;
  String name;
  Follower({this.id, this.name});

  @override
  _FollowerState createState() => _FollowerState();
}

class _FollowerState extends State<Follower> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.withOpacity(0.5),
appBar: AppBar(
  title: Text("Followers"),
),

      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${widget.name}'s followers",
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
