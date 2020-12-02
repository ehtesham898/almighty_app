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


  searchOperation(String s){
    setState(() {
        print(friendList.length);
      friendList.retainWhere((element) {
        return element["firstname"].toString().toLowerCase().contains(s) || element["lastname"].toString().toLowerCase().contains(s);
      });
    });

  }
  List friendList;
  String status = "";
  String message = "";
  TextEditingController search = TextEditingController();

  loadFriendsList() async {

    String url = 'http://api-v1.bottrion.com/api/friend_list.php';

    Map<String, String> headers = {"Content-type": "application/json"};
    String fetchDetailsReq = '{"id": "${widget.id}"}';

    Response response =
        await post(url, headers: headers, body: fetchDetailsReq);

    String body = response.body;
    var responseFetchRaw = json.decode(body);

    setState(() {
      status = responseFetchRaw["status"];
      message = responseFetchRaw["message"];
      friendList = responseFetchRaw["friendlist"];
    });
  }
GlobalKey<FormState> searchBox = GlobalKey<FormState>();
  
  Widget appBarTitle = new Text("Friends");
 bool showSearch = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown.withOpacity(0.5),
        appBar: new AppBar(
          centerTitle: true,
          title: appBarTitle,
        ),
        body: status == "1030"
            ? Center(
                child: Text("${message}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: "Raleway-SemiBold")))
            : friendList == null
                ? Center(
                    child: CircularProgressIndicator(
                      //  backgroundColor: Colors.white.withAlpha(0),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  )
                : Column(
                    children: [
                      Container(
                          color: Colors.brown.withOpacity(0.6),
                          height: MediaQuery.of(context).size.width *
                              0.16,
                          child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.76,

                                    child: Form(
                                      key: searchBox,
                                      child: TextFormField(
style: TextStyle(color: Colors.white),

                                        controller: search,
                                        decoration: InputDecoration(



                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.white))
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 1),
                                  Visibility(
                                    visible: showSearch,
                                    child: IconButton(
                                      icon: Icon(Icons.search,
                                          color: Colors.white),
                                      onPressed: () {
                                        showSearch = false;
                                       if(search.text == "") {
                                         search.text="Enter search term";
                                       }
                                        String searchL = search.text.toLowerCase();


                                        searchOperation(searchL);

                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: !showSearch,
                                    child: IconButton(
                                      icon: Icon(Icons.clear,
                                          color: Colors.white),
                                      onPressed: () {
                                        showSearch = true;

                                        search.text = "";
                                        loadFriendsList();
                                        String searchL = search.text.toLowerCase();


                                        searchOperation(searchL);

                                      },
                                    ),
                                  )
                                ],
                              ))),
                      Expanded(
                        child: Container(
                          color: Colors.black38.withOpacity(0.43),
                          child: ListView.builder(
                              itemCount: friendList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                FriendDetails(
                                                  id: "${friendList[index]["iduser"]}",
                                                  name:
                                                      "${friendList[index]["firstname"]} ${friendList[index]["lastname"]}",
                                                )));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          //  gradient: LinearGradient(colors: [Colors.yellowAccent, Colors.limeAccent,Colors.yellowAccent,Colors.limeAccent,Colors.yellowAccent, Colors.limeAccent,Colors.yellowAccent,Colors.limeAccent], begin: Alignment.bottomLeft, end: Alignment.topRight)
                                          color:
                                              Colors.brown.withOpacity(0.7),
                                          border: Border.all(
                                              color: Colors.amber
                                                  .withOpacity(0.6),
                                              width: 0.5)),
                                      margin: EdgeInsets.all(10),
                                      // height: MediaQuery.of(context).size.width*0.1,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 15),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.09,
                                                backgroundColor: Colors.white,
                                                child: CircleAvatar(
                                                  radius:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.086,
                                                  backgroundImage:
                                                      NetworkImage(
                                                          friendList[index]
                                                              ["avatar"]),
                                                )),
                                            SizedBox(width: 25),
                                            Column(
                                              children: [
                                                Text(
                                                    "${friendList[index]["firstname"]} ${friendList[index]["lastname"]}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 19,
                                                        fontFamily:
                                                            "Raleway-SemiBold")),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(
                                                          10.0),
                                                  child: Container(
                                                      height: 0.5,
                                                      width: 200,
                                                      color: Colors.grey),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Icon(Icons.people,
                                                        color: Colors.amber,
                                                        size: 17),
                                                    Text("197",
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color: Colors
                                                                .white)),
                                                    SizedBox(width: 50),
                                                    Container(
                                                      width: 100,
                                                      height: 18,
                                                      child: FlatButton(
                                                        color:
                                                            Color(0xff808000),
                                                        child: Text(
                                                            "Prayer request",
                                                            style: TextStyle(
                                                                fontSize: 8,
                                                                color: Colors
                                                                    .white)),
                                                        onPressed: () {},
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              }),
                        ),
                      ),
                    ],
                  ));
  }
}
