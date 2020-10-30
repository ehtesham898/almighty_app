
import 'package:AlmightyBook/userFriends.dart';
import 'package:flutter/material.dart';
import 'Profile.dart';
import 'package:AlmightyBook/userVideos.dart';
import 'UserPosts.dart';
import 'follower.dart';
import 'folowing.dart';
import 'photos.dart';
import 'Events.dart';

class FriendDetails extends StatefulWidget {

  String id;
  String name;
  FriendDetails({this.id, this.name});

  @override
  _FriendDetailsState createState() => _FriendDetailsState();
}

class _FriendDetailsState extends State<FriendDetails> {
  var tiles = ["Profile","Posts","Prayers","Testimonies","Followers","Following","Friends","Photos","Videos","Events"];
var icons = [Icons.person, Icons.message, Icons.record_voice_over, Icons.check_circle_outline, Icons.people, Icons.face, Icons.wc, Icons.image, Icons.video_library, Icons.notifications_active];
//  var links = [Profile("${widget.id}"), Icons.message, Icons.record_voice_over, Icons.check_circle_outline, Icons.people, Icons.face, Icons.wc, Icons.image, Icons.video_library, Icons.notifications_active];

openDetails(index){
switch(index) {
  case 0: Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Profile(id: widget.id,)));
  break;
  case 1: Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PostsUser(id: widget.id,name: widget.name,)));
  break;
  case 2: Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FriendDetails(id: widget.id,)));
  break;
  case 3: Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FriendDetails(id: widget.id,)));
  break;
  case 4: Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Follower(id: widget.id,name: widget.name)));
  break;
  case 5: Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Following(id: widget.id,name: widget.name,)));
  break;
  case 6: Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UserFriends(id: widget.id,name: widget.name,)));
  break;
  case 7: Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Photos(id: widget.id, name: widget.name,)));
  break;
  case 8: Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SamplePlayer(id: widget.id, name: widget.name,)));
  break;
  case 9: Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Events(id: widget.id,)));
  break;

}

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(widget.name),
      ),
      body:

              GridView.builder(
                  itemCount: tiles.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        openDetails(index);

                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width*0.32,
                        decoration: BoxDecoration(
                          color: Colors.brown.withOpacity(0.5),
                          //    gradient: LinearGradient(colors: [Color(0xfff5daef), Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(icons[index], color: Colors.white, size:40),
                            Text(tiles[index], style: TextStyle(color: Colors.white)),
                          ],
                        )
                      ),
                    );
                  }),


    );
  }
}
