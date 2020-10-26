import 'package:flutter/material.dart';

import 'Comments.dart';

class Photos extends StatefulWidget {
  String id;
  String name;
  Photos({this.id, this.name});

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  List<String> imageUrls = List<String>();

  fetchImageurls() async {
    setState(() {
      imageUrls = [
        "https://media.istockphoto.com/videos/aerial-drone-video-lille-city-from-the-citadel-park-4k-video-id1153522465?b=1&k=6&m=1153522465&s=640x640&h=mw5bUNPOpivKEgP4VjJv9tc_MVQPXZJMc7TTsWM5Fb8=",
        "https://media.istockphoto.com/videos/aerial-view-of-bangkok-at-sunset-video-id956240436?b=1&k=6&m=956240436&s=640x640&h=0ryzjd30Gbgs842p6rie2Ii5oT63YsVsqpUG2QUWcQE=",
        "https://i.vimeocdn.com/video/766606439_640x360.jpg",
        "https://i.vimeocdn.com/video/656782465_640x360.jpg",
        "https://i.vimeocdn.com/video/656782269_640x360.jpg",
        "https://i.vimeocdn.com/video/530244722_640x360.jpg",
        "https://i.vimeocdn.com/video/546686268_640x360.jpg",
        "https://i.vimeocdn.com/video/746217747_640x360.jpg",
        "https://i.vimeocdn.com/video/969222563_640x360.jpg",
        "https://i.vimeocdn.com/video/753480563_640x360.jpg",
      ];
    });
  }

  @override
  void initState() {
    fetchImageurls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber.withOpacity(0.7),
        appBar: AppBar(
          title: Text("${widget.name}"),
        ),
        body: ListView.builder(
            itemCount: imageUrls.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10,),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber, width: 1.5),
                  color: Colors.brown,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Container(
                        color: Colors.amber.withOpacity(0.3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("20th Oct, 2020",
                                style: TextStyle(color: Colors.white)),
                            SizedBox(width: 30),
                            IconButton(
                              icon: Icon(Icons.thumb_up,color: Colors.white),
                            ),
                            Text("199", style: TextStyle(color: Colors.white),),
                            SizedBox(width: 30),
                            IconButton(
                              icon: Icon(Icons.thumb_down,color: Colors.white),
                            ),
                            Text("22", style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      )
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4,),
                      //width: MediaQuery.of(context).size.width*0.90,
                      height: MediaQuery.of(context).size.height * 0.26,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(imageUrls[index]))),
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
              );
            }));
  }
}
