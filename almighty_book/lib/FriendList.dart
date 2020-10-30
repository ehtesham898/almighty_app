import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:AlmightyBook/FriendDetails.dart';

class FriendsList extends StatefulWidget {
  String id;

  FriendsList({this.id});

  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFriendsList();
  }

  List userData;
  loadFriendsList() async {
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
  Widget appBarTitle = new Text("Friends");
  Icon actionIcon = new Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,


appBar: new AppBar(
        centerTitle: true,

        title:appBarTitle,
        actions: <Widget>[
          new IconButton(icon: actionIcon,onPressed:(){
            setState(() {
              if ( this.actionIcon.icon == Icons.search){
                this.actionIcon = new Icon(Icons.close);
                this.appBarTitle = new TextField(
                  style: new TextStyle(
                    color: Colors.white,

                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search,color: Colors.white),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white)
                  ),
                );}
              else {
                this.actionIcon = new Icon(Icons.search);
                this.appBarTitle = new Text("Friends");
              }


            });
          } ,),]
    ),


      body:userData == null
          ? Center(
        child: CircularProgressIndicator(
        //  backgroundColor: Colors.white.withAlpha(0),
          valueColor:
          AlwaysStoppedAnimation<Color>(Colors.amber),
        ),
      )
          : Container(
color: Colors.black38.withOpacity(0.43),
            child: ListView.builder(
                itemCount: userData.length,
                itemBuilder:
                    (BuildContext context, int index){
                  return   GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FriendDetails(id: "${userData[index]["iduser"]}",name: "${userData[index]["firstname"]} ${userData[index]["lastname"]}",)));
                    },
                    child: Container(

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      //  gradient: LinearGradient(colors: [Colors.yellowAccent, Colors.limeAccent,Colors.yellowAccent,Colors.limeAccent,Colors.yellowAccent, Colors.limeAccent,Colors.yellowAccent,Colors.limeAccent], begin: Alignment.bottomLeft, end: Alignment.topRight)
color: Colors.brown.withOpacity(0.7),
                        border: Border.all(color: Colors.amber.withOpacity(0.6), width: 0.5)
                      ),
                      margin: EdgeInsets.all( 10),
                       // height: MediaQuery.of(context).size.width*0.1,
                        child:
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
  child:   Row(
    children: [
      CircleAvatar(
          radius: MediaQuery.of(context)
              .size
              .width *
              0.09,

          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: MediaQuery.of(context)
                .size
                .width *
                0.086,
            backgroundImage: AssetImage(
                "assets/images/profile.jpg"),
          )),
      SizedBox(width:25),
      Column(
        children: [
          Text("${userData[index]["firstname"]} ${userData[index]["lastname"]}", style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontFamily: "Raleway-SemiBold"
          )),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(height: 0.5, width: 200,color: Colors.grey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.people, color: Colors.amber, size: 17),
              Text("197", style:TextStyle(fontSize: 11, color: Colors.white)),
SizedBox(width: 50),
              Container(
                width: 100,
                height: 18,
                child: FlatButton(
color: Color(0xff808000),
                    child: Text("Prayer request", style: TextStyle(fontSize: 8, color: Colors.white)),
                        onPressed: (){

                        },
                ),
              )
            ],
          )
        ],



      ),

    ],
  ),

)


                    ),
                  );
                }),
          ),
    );
  }
}
