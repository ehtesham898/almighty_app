import 'package:AlmightyBook/suggestions.dart';
import 'package:flutter/material.dart';

class Following extends StatefulWidget {
  String id;
  String name;
  Following({this.id, this.name});

  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber.withOpacity(0.7),
        appBar: AppBar(
          title: Text("Following"),
        ),

        body: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${widget.name} is following the listed users ",
                        style: TextStyle(color: Colors.brown, fontSize: 16)),
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
