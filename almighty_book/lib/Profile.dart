import 'package:AlmightyBook/EditProfile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import "dart:convert";

class Profile extends StatefulWidget {
  String id;

  Profile({this.id});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var responseFetch;
  String preacherType = "";
  String genderType = "";
  var networkImg;
  fetchNetworkImage() async {
    Response re = await get("${responseFetch["avatar"]}");
    if (re.statusCode == 404 || re.statusCode == 403) {
      setState(() {
        networkImg = AssetImage('assets/images/no-image.jpg');
      });
    } else {
      setState(() {
        networkImg = NetworkImage("${responseFetch["avatar"]}");
      });
    }
  }

  fetchProfileDetails() async {
    print("asasasasasasa ${widget.id}");
    String urlFetch = 'http://api-v1.bottrion.com/api/user_details.php';
    Map<String, String> headers = {"Content-type": "application/json"};
    String fetchDetailsReq = '{"id": "${widget.id}"}';

    Response response =
        await post(urlFetch, headers: headers, body: fetchDetailsReq);
    int statusCode = response.statusCode;
    String body = response.body;
    var responseFetchRaw = json.decode(body);
    setState(() {
      responseFetch = responseFetchRaw;
    });
    print(responseFetch["avatar"].toString());
    String preacherCode = responseFetch["preacher"];
    String gender = responseFetch["gender"];

    fetchNetworkImage();

    if (preacherCode == "0") {
      preacherType = "Church";
    } else if (preacherCode == "1") {
      preacherType = "Preacher";
    } else if (preacherCode == "2") {
      preacherType = "Non Preacher";
    } else if (preacherCode == "-1") {
      preacherType = "Not updated";
    }

    if (gender == "0") {
      genderType = "Male";
    } else if (gender == "1") {
      genderType = "Female";
    } else if (gender == "2") {
      genderType = "Others";
    } else if (gender == "-1") {
      genderType = "Not updated";
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber.withOpacity(0.75),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => EditProfile(
                              name: "${responseFetch['firstname']}",
                              email: "${responseFetch['user_email']}",
                              address: "${responseFetch['address']}",
                              dob: "${responseFetch['dob']}",
                              gender: "${responseFetch['gender']}",
                              phone: "${responseFetch['phone']}",
                              preacher: "${responseFetch['preacher']}",
                              iduser: widget.id,
                              avatar: "${responseFetch['avatar']}",
                            )));
              },
              icon: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            )
          ],
          title: Text("Profile"),
          centerTitle: true,
        ),
        body: null == responseFetch
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white.withAlpha(0),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 40),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.55),
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(90)),
                  ),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      CircleAvatar(
                        child: CircleAvatar(
                          backgroundImage: networkImg == null
                              ? AssetImage('assets/images/no-image.jpg')
                              : networkImg,
                          radius: MediaQuery.of(context).size.width * 0.176,
                        ),
                        radius: MediaQuery.of(context).size.width * 0.18,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.98,
                          height: MediaQuery.of(context).size.height * 0.65,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${responseFetch['firstname']}",
                                          style: TextStyle(
                                              color: Colors.brown,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                ListTile(
                                  title: Text("Address",
                                      style: TextStyle(
                                          color: Colors.brown, fontSize: 17)),
                                  subtitle: Text("${responseFetch['address']}",
                                      style: TextStyle(
                                          color: Colors.brown, fontSize: 14)),
                                  leading: Icon(
                                    Icons.home,
                                    color: Colors.amber,
                                  ),
                                ),
                                Divider(
                                  color: Colors.brown,
                                  height: 5,
                                ),
                                ListTile(
                                  title: Text("Mobile",
                                      style: TextStyle(
                                          color: Colors.brown, fontSize: 17)),
                                  subtitle: Text(
                                      " ${responseFetch['countryCode']} ${responseFetch['phone']}",
                                      style: TextStyle(
                                          color: Colors.brown, fontSize: 14)),
                                  leading: Icon(
                                    Icons.phone_iphone,
                                    color: Colors.amber,
                                  ),
                                ),
                                Divider(
                                  color: Colors.brown,
                                  height: 5,
                                ),
                                ListTile(
                                  title: Text("Email",
                                      style: TextStyle(
                                          color: Colors.brown, fontSize: 17)),
                                  subtitle: Text(
                                      "${responseFetch['user_email']}",
                                      style: TextStyle(
                                          color: Colors.brown, fontSize: 14)),
                                  leading: Icon(
                                    Icons.alternate_email,
                                    color: Colors.amber,
                                  ),
                                ),
                                Divider(
                                  color: Colors.brown,
                                  height: 5,
                                ),
                                preacherType == "Church"
                                    ? SizedBox(height: 0, width: 0)
                                    : ListTile(
                                        title: Text("Gender",
                                            style: TextStyle(
                                                color: Colors.brown,
                                                fontSize: 17)),
                                        subtitle: Text("$genderType",
                                            style: TextStyle(
                                                color: Colors.brown,
                                                fontSize: 14)),
                                        leading: Icon(
                                          Icons.account_circle,
                                          color: Colors.amber,
                                        ),
                                      ),
                                preacherType == "Church"
                                    ? SizedBox(height: 0, width: 0)
                                    : Divider(
                                        color: Colors.brown,
                                        height: 5,
                                      ),
                                ListTile(
                                  title: Text("Preacher Type",
                                      style: TextStyle(
                                          color: Colors.brown, fontSize: 17)),
                                  subtitle: Text("$preacherType",
                                      style: TextStyle(
                                          color: Colors.brown, fontSize: 14)),
                                  leading: Icon(
                                    Icons.book,
                                    color: Colors.amber,
                                  ),
                                ),
                                Divider(
                                  color: Colors.brown,
                                  height: 5,
                                ),
                                preacherType == "Church"
                                    ? ListTile(
                                        title: Text("Pastor Name",
                                            style: TextStyle(
                                                color: Colors.brown,
                                                fontSize: 17)),
                                        subtitle: Text("St. Michael",
                                            style: TextStyle(
                                                color: Colors.brown,
                                                fontSize: 14)),
                                        leading: Icon(
                                          Icons.watch,
                                          color: Colors.amber,
                                        ),
                                      )
                                    : SizedBox(height: 0, width: 0),
                                preacherType == "Church"
                                    ? Divider(
                                        color: Colors.brown,
                                        height: 5,
                                      )
                                    : SizedBox(height: 0, width: 0),
                                preacherType == "Preacher"
                                    ? ListTile(
                                        title: Text("Church Name",
                                            style: TextStyle(
                                                color: Colors.brown,
                                                fontSize: 17)),
                                        subtitle: Text("St. Mary's",
                                            style: TextStyle(
                                                color: Colors.brown,
                                                fontSize: 14)),
                                        leading: Icon(
                                          Icons.watch,
                                          color: Colors.amber,
                                        ),
                                      )
                                    : SizedBox(height: 0, width: 0),
                                preacherType == "Preacher"
                                    ? Divider(
                                        color: Colors.brown,
                                        height: 5,
                                      )
                                    : SizedBox(height: 0, width: 0),
                                ListTile(
                                  title: Text(
                                      preacherType == "Church"
                                          ? "Date of establishment"
                                          : "Date of birth",
                                      style: TextStyle(
                                          color: Colors.brown, fontSize: 17)),
                                  subtitle: Text("${responseFetch['dob']}",
                                      style: TextStyle(
                                          color: Colors.brown, fontSize: 14)),
                                  leading: Icon(
                                    Icons.child_care,
                                    color: Colors.amber,
                                  ),
                                ),
                                Divider(
                                  color: Colors.brown,
                                  height: 5,
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ));
  }
}
