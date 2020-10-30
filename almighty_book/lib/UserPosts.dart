import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:video_player/video_player.dart';

class PostsUser extends StatefulWidget {
  String id;
  String name;

  PostsUser({this.name, this.id});

  @override
  _PostsUserState createState() => _PostsUserState();
}

class _PostsUserState extends State<PostsUser> {
  List<FlickManager> videosDispose = List<FlickManager>();
  makeVideoPost(){
    FlickManager fm = FlickManager(videoPlayerController: VideoPlayerController.network("https://media.istockphoto.com/videos/woman-excited-in-her-first-skydive-in-a-tandem-video-id531111570"));
    videosDispose.add(fm);
    return FlickVideoPlayer(
        flickManager:fm



    );
  }
  @override
  dispose(){
for(int h =0; h< videosDispose.length; h++){
  videosDispose[h].dispose();
}
  }
List<String> posts = List<String>();
  loadPosts() async {
setState(() {
  posts = [
    "Hey there",
    "All is well",
    "hope all is good",

  ];
});
  }
  @override
  void initState() {
    loadPosts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.withOpacity(0.5),
      appBar: AppBar(
        title: Text("Posts"),
      ),

      body:


      Container(
        child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.brown, Colors.grey, Colors.amber])
                    ),
                    margin: EdgeInsets.only(left: 10, top:7, bottom: 7),
width: MediaQuery.of(context).size.width*0.45,
                    height: MediaQuery.of(context).size.width*0.45,

                   child:
                  index==0?
                  Image.network("https://content.active.com/Assets/Active.com+Content+Site+Digital+Assets/Article+Image+Update/Cycling/Tips+for+Beginner+Cyclists/carousel.jpg",)
:index==1? makeVideoPost()
                  :
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8),
                        child: Text("Feeling well now!!!", style: TextStyle(color: Colors.white, fontFamily: "Lemon")),
                      )
                  ),
                  Container(
                    margin: EdgeInsets.only( top:5, bottom: 5),
                    width: MediaQuery.of(context).size.width*0.52,
                    height: MediaQuery.of(context).size.width*0.35,

                   color: Colors.brown,
child: Column(
  children: [
    Container(
      color: Colors.grey.withOpacity(0.6),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical:5.0),
            child: Text("12th Oct, 2020", style: TextStyle(color: Colors.white, fontSize: 13)),
          )
        ],
      ),
    ),

    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.amberAccent,
        child: Row(
          children: [
            Icon(Icons.location_on, color: Colors.brown,),
            Text("Vatican city"),
          ],
        ),
      ),
    ),

    Container(

      child: Row(
        children: [
          Container(
            color: Colors.grey,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.thumb_up, color: Colors.white,size: 27),
                SizedBox(width:5),
                Text("221", style: TextStyle(color: Colors.white))
              ],
            )
          ),


          Container(
            color: Colors.amber.withOpacity(0.6),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.thumb_down, color: Colors.white,size: 27),
                  SizedBox(width:5),
                  Text("2", style: TextStyle(color: Colors.white))
                ],
              )
          ),
        ],
      ),
    )
  ],
),
                  )
                ],
              );
            }),
      )
    );
  }
}