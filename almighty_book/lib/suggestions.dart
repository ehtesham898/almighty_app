import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Suggestions extends StatefulWidget {
  String id;

  Suggestions({this.id});

  @override
  _SuggestionsState createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  List userData;
  loadFriendsSuggestion() async {
    String url = 'http://api-v1.bottrion.com/api/friend_suggestions.php';

    Map<String, String> headers = {"Content-type": "application/json"};
    String fetchDetailsReq = '{"id": "${widget.id}"}';

    Response response =
        await post(url, headers: headers, body: fetchDetailsReq);

    String body = response.body;
    print(body);
    var responseFetchRaw = json.decode(body);
    setState(() {
      userData = responseFetchRaw["Userdata"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFriendsSuggestion();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: userData == null
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white.withAlpha(0),
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              ),
            )
          :

      GridView.builder(
          itemCount: userData.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return Container(
margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width*0.32,
                decoration: BoxDecoration(
                  color: Color(0xff2a4775).withOpacity(0.70),
                  gradient: LinearGradient(colors: [Colors.teal, Colors.yellow], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
alignment: Alignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "http://${userData[index]["avatar"]}"),
                                fit: BoxFit.fill),
                          ),
                        )),


                    Column(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left:8.0,),
                          child: Row(

                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right:2.0),
                                child: Icon(Icons.people,
                                    color: Colors.yellowAccent, size: 13),
                              ),
                              Text("200",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: 'Raleway-SemiBold')),
Spacer(),
                              IconButton(
                                icon: Icon(Icons.add_circle, color: Colors.white, size: 20),
                              )
                            ],
                          ),
                        ),

                        Container(

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                            color: Colors.blueGrey.withOpacity(0.7),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("${userData[index]["firstname"]} ${userData[index]["lastname"]}",
                                          style: TextStyle(

                                              fontFamily: 'Raleway-Bold',
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],

                                ),

                                Row(
                                  children: [
                                    Icon(Icons.person, color: Colors.yellow, size: 13),
                                    Expanded(
                                      child: Text("Pastor Shawn King",
                                          style: TextStyle(

                                              fontFamily: 'Raleway-Bold',
                                              color: Colors.limeAccent,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],

                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, color: Colors.tealAccent, size: 13),
                                    Expanded(
                                      child: Text("Toronto",
                                          style: TextStyle(

                                              fontFamily: 'Raleway-Bold',
                                              color: Colors.orangeAccent,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],

                                ),
                              ],
                            )
                          ),
                        ),

                      ],
                    )
                  ],
                ));
              }),
    );
  }
}
