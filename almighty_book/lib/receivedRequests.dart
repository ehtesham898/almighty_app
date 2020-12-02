import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class ReceivedRequests extends StatefulWidget {
  String id;
  ReceivedRequests({this.id});

  @override
  _ReceivedRequestsState createState() => _ReceivedRequestsState();
}

class _ReceivedRequestsState extends State<ReceivedRequests> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List receivedList;
  String message = "";
  String status = "";
  fetchReceivedRequests() async {
    String url = 'http://api-v1.bottrion.com/api/received_friend_request.php';
    Map<String, String> headers = {"Content-type": "application/json"};
    String fetchDetailsReq = '{"id": "${widget.id}"}';
    print("id is ${widget.id}");
    Response response =
        await post(url, headers: headers, body: fetchDetailsReq);
    String body = response.body;
    var responseFetchRaw = json.decode(body);
    setState(() {
      receivedList = responseFetchRaw["receivedfriendrequest"];
      status = responseFetchRaw["status"];
      message = responseFetchRaw["message"];
    });
  }

  @override
  void initState() {
    fetchReceivedRequests();
    super.initState();
  }

  var cancelIndices = [];
  cancelFriendRequest(int index, String friendid) async {
    String url = 'http://api-v1.bottrion.com/api/cancel_friends_request.php';
    Map<String, String> headers = {"Content-type": "application/json"};
    String cancelRequest = '{"id": "${widget.id}", "friendid": "${friendid}"}';
    Response response = await post(url, headers: headers, body: cancelRequest);
    int statusCodeHttp = response.statusCode;
    String body = response.body;
    var mapBody = json.decode(body);
    String statusCode = mapBody["status"];
    if (statusCode == "1034") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${mapBody["message"]}"),
        duration: Duration(seconds: 1),
      ));
    } else if (statusCode == "1035") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${mapBody["message"]}"),
        duration: Duration(seconds: 1),
      ));
    }
   setState(() {
      cancelIndices.add(index);
    });
  }

  var confirmIndices = [];
  confirmRequest(int index,String friendid) async {
    print(index);
    String url = 'http://api-v1.bottrion.com/api/confirm_friends_request.php';
    Map<String, String> headers = {"Content-type": "application/json"};
    String confirmRequest = '{"id": "${widget.id}", "friendid": "${friendid}"}';
    Response response = await post(url, headers: headers, body: confirmRequest);
    int statusCodeHttp = response.statusCode;
    String body = response.body;
    var mapBody = json.decode(body);
    String statusCode = mapBody["status"];
    if (statusCode == "1013") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${mapBody["message"]}"),
        duration: Duration(seconds: 1),
      ));
    } else if (statusCode == "1030") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${mapBody["message"]}"),
        duration: Duration(seconds: 1),
      ));
    } else if (statusCode == "1028") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${mapBody["message"]}"),
        duration: Duration(seconds: 1),
      ));
    } else if (statusCode == "1029") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${mapBody["message"]}"),
        duration: Duration(seconds: 1),
      ));
    } else if (statusCode == "1015") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${mapBody["message"]}"),
        duration: Duration(seconds: 1),
      ));
    } else if (statusCode == "1013") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${mapBody["message"]}"),
        duration: Duration(seconds: 1),
      ));
    }
    setState(() {

      confirmIndices.add(index);

    });
    print(confirmIndices.length);
  }

  var blockedIndices = [];
  blockFriendRequest(int index, String friendid) async {

    String url = 'http://api-v1.bottrion.com/api/block_friends_request.php';
    Map<String, String> headers = {"Content-type": "application/json"};
    String blockRequest = '{"id": "${widget.id}", "friendid": "${friendid}"}';
    Response response = await post(url, headers: headers, body: blockRequest);
    int statusCodeHttp = response.statusCode;
    String body = response.body;
    var mapBody = json.decode(body);
    String statusCode = mapBody["status"];
    if (statusCode == "1036") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${mapBody["message"]}"),
        duration: Duration(seconds: 1),
      ));
    } else if (statusCode == "1037") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${mapBody["message"]}"),
        duration: Duration(seconds: 1),
      ));
    } else if (statusCode == "1038") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${mapBody["message"]}"),
        duration: Duration(seconds: 1),
      ));
    }
    setState(() {
      blockedIndices.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        backgroundColor: Colors.brown.withOpacity(0.5),
        appBar: AppBar(
          title: Text("Received Requests"),
        ),
        body: status == "1033"
            ? Center(
                child: Text("${message}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Raleway-SemiBold")))
            : receivedList == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    cacheExtent: 9999,
                    itemCount: receivedList.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return Visibility(
                        visible: !confirmIndices.contains(index) || !cancelIndices.contains(index),
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            width: MediaQuery.of(context).size.width * 0.32,
                            decoration: BoxDecoration(
                              //  color: Colors.white.withOpacity(0.6),
                              border: Border.all(color: Colors.white, width: 1),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.5),
                                    Colors.brown.withOpacity(0.9)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),

                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.387,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.335,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${receivedList[index]["avatar"]}",
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ))),
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
                                          Expanded(
                                              child: Text(
                                            "${receivedList[index]["firstname"]} ${receivedList[index]["lastname"]}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontFamily: "Raleway-Bold"),
                                          ))
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
                                              Visibility(
                                                visible: !blockedIndices
                                                    .contains(index),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                        width: 25,
                                                        height: 35,
                                                        child: IconButton(
                                                          icon: Icon(
                                                              Icons
                                                                  .check_circle_outline,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () {
                                                            confirmRequest(
                                                                index, "${receivedList[index]["iduser"]}");
                                                          },
                                                        )),
                                                    Container(
                                                        width: 25,
                                                        height: 35,
                                                        child: IconButton(
                                                          icon: Icon(
                                                              Icons.cancel,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () {
                                                            cancelFriendRequest(
                                                                index,"${receivedList[index]["iduser"]}");
                                                          },
                                                        )),
                                                    Container(
                                                        width: 25,
                                                        height: 35,
                                                        child: IconButton(
                                                          icon: Icon(
                                                              Icons.block,
                                                              color:
                                                                  Colors.white),
                                                          onPressed: () {
                                                            blockFriendRequest(
                                                                index,"${receivedList[index]["iduser"]}");
                                                          },
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Visibility(
                                                visible: blockedIndices
                                                    .contains(index),
                                                child: RaisedButton(
                                                  child: Text("Unblock"),
                                                  onPressed: () {},
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            )),
                      );
                    }));
  }
}
