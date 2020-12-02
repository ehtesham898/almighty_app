import 'package:AlmightyBook/FriendList.dart';
import 'package:AlmightyBook/receivedRequests.dart';
import 'package:AlmightyBook/sentRequests.dart';
import 'package:flutter/material.dart';
import 'Suggestions.dart';

class Friends extends StatefulWidget {
  String id;

  Friends({this.id});

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.amber.withOpacity(0.4),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlineButton(


                child: Text("Suggestions", style:TextStyle(color: Colors.white,fontSize: 11)),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FriendsList(id: widget.id,)));

                },
                borderSide: BorderSide(color: Colors.white),
              ),
              FlatButton(


                child: Text("Friends", style:TextStyle(color: Colors.white,fontSize: 12)),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FriendsList(id: widget.id,)));

                },
              ),
              FlatButton(


                child: Text("Sent\nRequests", style:TextStyle(color: Colors.white,fontSize: 12)),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SentRequests(id: widget.id,)));

                },
              ),
              FlatButton(


                child: Text("Received\nRequests", style:TextStyle(color: Colors.white,fontSize: 12)),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ReceivedRequests(id: widget.id,)));

                },
              )
            ],
          ),
        ),
       Container(


         child: Suggestions(id: widget.id),
       ),

      /*  Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.teal.withOpacity(0.15),
          padding: const EdgeInsets.all(8.0),
          child: Text("Friends",
              style: TextStyle(
                  fontFamily: 'Raleway-Bold',
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
        ),*/




      ],
    );


  }
}
