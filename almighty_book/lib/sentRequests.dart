import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class SentRequests extends StatefulWidget {
  String id;

  SentRequests({this.id});

  @override
  _SentRequestsState createState() => _SentRequestsState();
}

class _SentRequestsState extends State<SentRequests> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List sentList = List();
  String message = "";
  String status = "";
  fetchSentRequests() async {
    String url = 'http://api-v1.bottrion.com/api/sent_friends_request_list.php';
    Map<String, String> headers = {"Content-type": "application/json"};
    String fetchDetailsReq = '{"id": "${widget.id}"}';
    print("id is ${widget.id}");
    Response response =
        await post(url, headers: headers, body: fetchDetailsReq);

    String body = response.body;
    var responseFetchRaw = json.decode(body);
    print(responseFetchRaw);
    String statusCode = responseFetchRaw["status"];
    if (statusCode == "1039") {
      print("in");
      setState(() {
        sentList = responseFetchRaw["sendFriendRequestList"];
        status = responseFetchRaw["status"];
        message = responseFetchRaw["message"];
      });
    } else if (statusCode == "1040") {
      setState(() {
        // sentList = responseFetchRaw["receivedfriendrequest"];
        status = responseFetchRaw["status"];
        message = responseFetchRaw["message"];
      });
    }
  }

  @override
  void initState() {
    fetchSentRequests();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown.withOpacity(0.5),
        appBar: AppBar(
          title: Text("Sent Requests"),
        ),
        body: status == "1040"
            ? Center(child: Text("${message}"))
            : ListView.builder(
                cacheExtent: 9999,
                itemCount: sentList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.brown.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white70),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(sentList[index]["avatar"]),
                              radius: MediaQuery.of(context).size.width*0.08,
                            ),
                            SizedBox(width: 25),
                            Text(
                                "${sentList[index]["firstname"]} ${sentList[index]["lastname"]}",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontFamily: "Raleway-SemiBold")),
Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            )
                          ],
                        ),
                      )

                      );
                }));
  }
}
