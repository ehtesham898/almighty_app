import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class Suggestions extends StatefulWidget {
  String id;

  Suggestions({this.id});

  @override
  _SuggestionsState createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  int offset = 0;
  int limit = 8;
  sendFriendrequestAsync(friendid) async {
    String url = 'http://api-v1.bottrion.com/api/add_friends.php';

    Map<String, String> headers = {"Content-type": "application/json"};
    String addFriendReq =
        '{"id": "${widget.id}", "friendid": "${friendid}"}';

    Response response =
    await post(url, headers: headers, body: addFriendReq);

    String body = response.body;
    var responseFetchRaw = json.decode(body);
print(responseFetchRaw);
    String status = responseFetchRaw["status"];
    String message = responseFetchRaw["message"];
if(status == "1026"){

   Scaffold.of(context).showSnackBar(SnackBar(content: Text(message),));


}else if(status == "1027"){
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(message), duration: Duration(seconds: 2),));

}else if(status == "1025"){
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(message),duration: Duration(seconds: 2)));

}else if(status == "1024"){
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(message),duration: Duration(seconds: 2)));

}else if(status == "1023"){
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(message),duration: Duration(seconds: 2)));

}

  }
sendFriendRequest(friendid){
      sendFriendrequestAsync(friendid);
}

  List userData = List<Object>();
  loadFriendsSuggestion() async {
    String url = 'http://api-v1.bottrion.com/api/friend_suggestions.php';

    Map<String, String> headers = {"Content-type": "application/json"};
    String fetchDetailsReq =
        '{"id": "${widget.id}", "limit": "${limit}", "offset": "${offset}"}';
print(fetchDetailsReq);
    Response response =
        await post(url, headers: headers, body: fetchDetailsReq);

    String body = response.body;
    var responseFetchRaw = json.decode(body);
    List userDataTemp = responseFetchRaw["Userdata"];
    setState(() {
      userData.addAll(userDataTemp);
      setState(() {
        loadMoreItems = false;
      });
    });
  }
bool loadMoreItems = false;
  bool loadMore = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFriendsSuggestion();

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        print("edge");
        if (_controller.position.pixels == 0) {
        } else {
          print("edge bottom");
          setState(() {
            loadMore = true;
            loadMoreItems = true;
              offset += limit;
            loadFriendsSuggestion();
          });
        }
      } else {
        setState(() {
          loadMore = false;
        });
      }
    });
  }

  var _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: (userData == null || userData.length == 0)
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white.withAlpha(0),
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            )
          : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GridView.builder(
                  cacheExtent: 9999,
                    controller: _controller,
                    itemCount: userData.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          margin: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.32,
                          decoration: BoxDecoration(
                            color: Colors.brown.withOpacity(1),
                          border: Border.all(color: Colors.amber.withOpacity(0.7), width: 1),
                          //  gradient: LinearGradient(
                            //    colors: [Colors.teal, Colors.yellow],
                            //    begin: Alignment.topLeft,
                             //   end: Alignment.bottomRight),

                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.387,
                                    height: MediaQuery.of(context).size.width *
                                        0.335,
                                   child: CachedNetworkImage(
                                     imageUrl: "${userData[index]["avatar"]}",
                                     placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                     errorWidget: (context, url, error) => Icon(Icons.error),
                                     fit: BoxFit.cover,
                                   )
                                  )),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 2.0),
                                          child: Icon(Icons.people,
                                              color: Colors.white,
                                              size: 13),
                                        ),
                                        Text("200",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontFamily:
                                                    'Raleway-SemiBold')),
                                        Spacer(),
                                        IconButton(
                                          
                                          icon: Icon(Icons.add_circle,
                                              color: Colors.white, size: 25),
                                          onPressed: (){
                                            sendFriendRequest(userData[index]["iduser"]);
                                          }
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      color: Colors.blueGrey.withOpacity(0.5),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      "${userData[index]["firstname"]} ${userData[index]["lastname"]}",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Raleway-Bold',
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.person,
                                                    color: Colors.white,
                                                    size: 13),
                                                Expanded(
                                                  child: Text(
                                                      "Pastor Shawn King",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Raleway-Bold',
                                                          color:
                                                              Colors.white,
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.location_on,
                                                    color: Colors.white,
                                                    size: 13),
                                                Expanded(
                                                  child: Text("Toronto",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Raleway-Bold',
                                                          color: Colors
                                                              .white,
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ));
                    }),
                Visibility(
                  visible: loadMoreItems,
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),),
                ),
             /*   Visibility(
              //    visible: loadMore && !loadMoreItems,
                  visible: false,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        offset += limit;
                      });
                      loadFriendsSuggestion();
                      setState(() {
                        loadMoreItems = true;
                      });
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          radius: 25,
                          child: Icon(Icons.keyboard_arrow_down,
                              color: Colors.brown, size: 47),
                          backgroundColor: Colors.amberAccent.withOpacity(1),
                        )),
                  ),
                )*/
              ],
            ),
    );
  }
}
