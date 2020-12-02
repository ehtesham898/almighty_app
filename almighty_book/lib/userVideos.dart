import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

import 'Comments.dart';

class SamplePlayer extends StatefulWidget {
  String id;
  String name;
  SamplePlayer({Key key, this.id, this.name}) : super(key: key);

  @override
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  bool loaded = false;

  List<FlickManager> flickManagers = List<FlickManager>();
  List<String> videoList = List<String>();

  fetchVideos() async {
    setState(() {
      videoList = [
        "https://player.vimeo.com/external/304076058.sd.mp4?s=077bbdea9c2c1a4230c443431c3536cf251d4cf7&profile_id=164",
        "https://player.vimeo.com/external/428319250.sd.mp4?s=b6b0dad3b58c3e807a5223aa82124df59e609583&profile_id=164",
        "https://player.vimeo.com/external/364430940.sd.mp4?s=fbcc9c233782aab30b77cd75cad5a0d50e2c915f&profile_id=164",
        "https://player.vimeo.com/external/224857499.sd.mp4?s=b37a693a911dc07bd020c7a43a7decc7a66ea3a9&profile_id=164",
        "https://player.vimeo.com/external/178898320.sd.mp4?s=06b41842be12b20900cd1309eb1bce449d2bed64&profile_id=164",
        "https://player.vimeo.com/external/364570143.sd.mp4?s=3ce901c7e2792daa34515d33b7b99e26b6797b45&profile_id=164",
        "https://player.vimeo.com/external/226156910.sd.mp4?s=f770885ca35f8d264ea5bee27ec0a971955dac63&profile_id=164",
        "https://player.vimeo.com/external/430090607.hd.mp4?s=2ab94f8f6478af2f8da7857c9d3e0fa5b7515faa&profile_id=174",
        'https://player.vimeo.com/external/344119052.hd.mp4?s=2569e19f521b2d9e223f457ec4b71e2ccc1bfe1a&profile_id=174',
        "https://player.vimeo.com/external/365460630.hd.mp4?s=ad623b3b9eff00e439bb9f544b40aaf4cf358c05&profile_id=174",
        "https://player.vimeo.com/external/335511588.hd.mp4?s=224c058ab473fc6b64444691665555f7da273c92&profile_id=174",
      ];
    });
    buildFlickManagers();
  }

  buildFlickManagers() {
    for (int c = 0; c < videoList.length; c++) {
      FlickManager flickManager = FlickManager(
          videoPlayerController: VideoPlayerController.network(videoList[c]));
      flickManagers.add(flickManager);
    }
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    fetchVideos();
    super.initState();
  }

  @override
  void dispose() {
    for (int count = 0; count < flickManagers.length; count++) {
      flickManagers[count].dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          backgroundColor: Colors.brown.withOpacity(0.5),
          appBar: AppBar(
            title: Text("${widget.name}"),
            centerTitle: false,
          ),
          body:

    ListView.builder(
    itemCount: videoList.length,
    itemBuilder: (BuildContext context, int index) {


      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 2),

          decoration: BoxDecoration(
            border: Border.all(color: Colors.amberAccent, width: 2),
            color: Colors.brown,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  color: Colors.amber.withOpacity(0.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("20th Oct, 2020",
                          style: TextStyle(color: Colors.white)),
                      SizedBox(width: 30),
                      IconButton(
                        icon: Icon(Icons.thumb_up, color: Colors.white,),
tooltip: "Like",

                      ),
                      Text("201", style: TextStyle(color: Colors.white)),
                      SizedBox(width: 30),
                      IconButton(
                        icon: Icon(Icons.thumb_down, color: Colors.white,),


                      ),
                      Text("10", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                )
              ),
              Container(
                  margin: EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border:
                    Border.all(color: Colors.amberAccent, width: 0.6),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(6.0, 15.0),
                        blurRadius: 20.0,
                      ),
                    ],
                  ),
                  // color: Colors.amberAccent,
                  //   height: MediaQuery.of(context).size.height * 0.28,
                  child: FlickVideoPlayer(flickManager: flickManagers[index])
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),


                      width: MediaQuery.of(context).size.width*0.61,
                      height: 30,
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Write a comment",
                            labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                            border: OutlineInputBorder( borderRadius: BorderRadius.circular(5))
                        ),
                      )
                  ),
                  IconButton(
                      icon: Icon(Icons.send, color: Colors.white,)
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.217,
                    child: FlatButton(
                      color: Colors.amber.withOpacity(0.5),
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Comments(postid: "1",)));
                      },
                      child: Text("Comments", style: TextStyle(fontSize: 9.2,color: Colors.white)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );





      /* return Container(
      child: FlickVideoPlayer(flickManager: flickManager),
    );*/
    }
      )
        );
  }
}
