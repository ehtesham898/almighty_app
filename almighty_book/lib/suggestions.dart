import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Suggestions extends StatefulWidget {
  String id;

  Suggestions({this.id});

  @override
  _SuggestionsState createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {



  List userData;
  loadFriends() async {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFriends();
  }

  @override
  Widget build(BuildContext context) {
    return


    Expanded(
    child: userData == null
    ? Center(
    child: CircularProgressIndicator(
    backgroundColor: Colors.white.withAlpha(0),
    valueColor: AlwaysStoppedAnimation<Color>(
    Colors.deepPurpleAccent),
    ),
    )
        : ListView.builder(
    itemCount: userData.length,
    itemBuilder: (BuildContext context, int index) {
    return Padding(
    padding: const EdgeInsets.symmetric(
    horizontal: 20.0, vertical: 8),
    child: Container(
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.15),
    borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
    children: [
    Row(
    children: [
    Padding(
    padding:
    const EdgeInsets.all(8.0),
    child: Container(
    width: 110,
    height: 115,
    decoration: BoxDecoration(
    image: DecorationImage(
    image: NetworkImage(
    userData[index]
    ["avatar"]),
    fit: BoxFit.fill),
    ),
    )),
    Column(
    crossAxisAlignment:
    CrossAxisAlignment.start,
    children: [
    Padding(
    padding:
    const EdgeInsets.all(8.0),
    child: Text(
    userData[index]
    ["firstname"],
    style: TextStyle(
    fontFamily:
    'Raleway-Bold',
    color: Colors.black87,
    fontSize: 16,
    fontWeight:
    FontWeight.bold)),
    ),
    SizedBox(
    height: 10,
    ),
    Divider(color: Colors.grey),
    Row(
    children: [
    Icon(Icons.person,
    color:
    Colors.orangeAccent,
    size: 18),
    Text("200 Friends/followers",
    style: TextStyle(
    fontSize: 11,
    fontFamily:
    'Raleway-SemiBold')),
    ],
    ),
    Padding(
    padding:
    const EdgeInsets.symmetric(
    vertical: 8.0),
    child: Row(
    children: [
    Icon(Icons.perm_identity,
    color:
    Colors.purpleAccent,
    size: 18),
    Text(
    userData[index][
    "preacher"] ==
    "1"
    ? "${userData[index]["churchname"] == null ? "Church " : userData[index]["churchname"] == null} preacher"
        : "Non preacher",
    style: TextStyle(
    fontSize: 11,
    fontFamily:
    'Raleway-SemiBold')),
    ],
    ),
    ),
    Padding(
    padding:
    const EdgeInsets.symmetric(
    vertical: 8.0),
    child: Row(
    children: [
    Icon(Icons.location_on,
    color:
    Colors.lightGreen,
    size: 18),
    Text("Congo",
    style: TextStyle(
    fontSize: 11,
    fontFamily:
    'Raleway-SemiBold')),
    ],
    ),
    ),
    ],
    ),
    ],
    ),
    Divider(color: Colors.purple),
    ],
    )),
    );
    }),
    );
  }
}
