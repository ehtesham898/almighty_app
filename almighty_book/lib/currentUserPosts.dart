import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PostsCurrentUser extends StatefulWidget {
  String id;
  String name;

  PostsCurrentUser({this.name, this.id});

  @override
  _PostsCurrentUserState createState() => _PostsCurrentUserState();
}

class _PostsCurrentUserState extends State<PostsCurrentUser> {
  List<FlickManager> videosDispose = List<FlickManager>();
  makeVideoPost() {
    FlickManager fm = FlickManager(
        videoPlayerController: VideoPlayerController.network(
            "https://media.istockphoto.com/videos/woman-excited-in-her-first-skydive-in-a-tandem-video-id531111570"));
    videosDispose.add(fm);
    return FlickVideoPlayer(flickManager: fm);
  }

  @override
  dispose() {
    for (int h = 0; h < videosDispose.length; h++) {
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
    return Container(
      child: ListView.builder(

          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.white.withOpacity(0.5),
                      Colors.brown.withOpacity(0.8),
                    ])),
                    margin: EdgeInsets.only(left: 2, top: 7, bottom: 7),
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.width * 0.23,
                    child: index == 0
                        ? Image.network(
                            "https://content.active.com/Assets/Active.com+Content+Site+Digital+Assets/Article+Image+Update/Cycling/Tips+for+Beginner+Cyclists/carousel.jpg",
                          )
                        : index == 1
                            ? makeVideoPost()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 8),
                                child: Text("Feeling well now!!!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Raleway-Bold")),
                              )),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  width: MediaQuery.of(context).size.width * 0.52,
                  height: MediaQuery.of(context).size.width * 0.23,
                  color: Colors.brown,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.grey.withOpacity(0.6),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1.0, horizontal: 1),
                              child: Text("12th Oct, 2020",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11)),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          color: Colors.white.withOpacity(0.4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.brown,
                                size: 21,
                              ),
                              Text("Vatican city",
                                  style: TextStyle(color: Colors.white,fontSize: 11),),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                color: Colors.grey,
                                padding: EdgeInsets.all(3),
                                child: Row(
                                  children: [
                                    Icon(Icons.thumb_up,
                                        color: Colors.white, size: 18),
                                    SizedBox(width: 2),
                                    Text("221",
                                        style: TextStyle(color: Colors.white))
                                  ],
                                )),
                            SizedBox(width:2),
                            Container(
                                color: Colors.white.withOpacity(0.5),
                                padding: EdgeInsets.all(3),
                                child: Row(
                                  children: [
                                    Icon(Icons.thumb_down,
                                        color: Colors.white, size: 18),
                                    SizedBox(width: 2),
                                    Text("2",
                                        style: TextStyle(color: Colors.white))
                                  ],
                                )),
                            SizedBox(width:2),
                            Container(
                                color: Colors.grey,
                                padding: EdgeInsets.all(3),
                                child: Row(
                                  children: [
                                    Icon(Icons.add_comment,
                                        color: Colors.white, size: 18),
                                    SizedBox(width: 2),
                                    Text("292",
                                        style: TextStyle(color: Colors.white))
                                  ],
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
