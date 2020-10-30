import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  String postid;

  Comments({this.postid});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  List<String> comments = List<String>();

  fetchComments() async{
    setState(() {
      comments =[
        "Really cool",
        "Wow",
        "I was there",
        "Such a beautiful place. I visited this place last year with my entire family and it was such a pleasure.",      "I am bored of this now!!",
        "Hope to see you soon there",
        "Lost in the woods",
        "Great",
        "Amazing",
        "Paradise on earth",
      ];
    });
  }

  @override
  void initState() {
    fetchComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.withOpacity(0.7),
appBar: AppBar(
  title: Text("View Comments"),
),
      body:
          GridView.builder(
              itemCount: comments.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.brown,
                    ),
                    child:
                    Column(
                      children: [
                        Container(
                          color: Colors.grey.withOpacity(0.45),
                          child: Column(
                            children: [
                              SizedBox(height: 2,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("John Cena", style: TextStyle(fontSize: 13,color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                                  ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage('assets/images/profile.png'),
                                  ),
                                  SizedBox(width: 15),
                                  Text("12th Oct, 2020", style: TextStyle(fontSize: 11,color: Colors.amberAccent))
                                ],
                              ),
                            ],
                          )

                        ),

                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(comments[index], style: TextStyle(color: Colors.white,fontFamily: "Lemon", fontSize: 11)),
                        ))
                      ],
                    )

                );
              }
          ),
floatingActionButton: FloatingActionButton(
  backgroundColor: Colors.amber,
        onPressed: (){

    },
    child: Icon(Icons.refresh, color: Colors.brown),
    ),

    );
  }
}
