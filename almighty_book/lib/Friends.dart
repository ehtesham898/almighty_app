import 'package:AlmightyBook/FriendList.dart';
import 'package:flutter/material.dart';
import 'Suggestions.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

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
          color: Colors.amber,
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Suggestions",
                  style: TextStyle(
                      fontFamily: 'Raleway-Bold',
                      color: Colors.brown,
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
              OutlineButton(

                borderSide: BorderSide( //                   <--- left side
                  color: Colors.brown,
                  width: 1.0,
                ),
                child: Text("Go to Friends List", style:TextStyle(color: Colors.brown)),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FriendsList(id: widget.id,)));

                },
              )
            ],
          ),
        ),
       Container(


         child: Suggestions(id: widget.id),
       ),
      GestureDetector(
        onTap: (){

    },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            alignment: Alignment.center,

            height: 40,

            child: Text("Load more", style: TextStyle(color: Colors.brown)),
            color: Colors.amber,

          ),
        ),
      )
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
