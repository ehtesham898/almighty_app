import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Profile.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:AlmightyBook/User.dart';
import 'package:tabbar/tabbar.dart';
import 'Friends.dart';

class Dashboard extends StatefulWidget {
  String name;
  String id;
  Dashboard({this.name, this.id});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int count = 0;
  List<User> users = List<User>();
  final controller = PageController();
  String _userType = "";
  int _radioValue1 = -1;
  List<String> namesUsers = List<String>();

  Future<List<User>> _fetchNetworkCall() async {

    String urlSave = 'http://api-v1.bottrion.com/api/user_details.php';
    Map<String, String> headers = {"Content-type": "application/json"};
    String req = '{"id": "${widget.id}"}';
    Response response = await post(urlSave, headers: headers, body: req);
    String resBody = response.body;
    var respJson = json.decode(resBody);
    print(respJson);

    users.add(User(
      address: respJson["address"],
      dob: respJson["dob"],
      firstname: respJson["firstname"],
      gender: respJson["gender"],
      phone: respJson["phone"],
      email: respJson["email"],
    ));
    users.add(User(
      address: respJson["address"],
      dob: respJson["dob"],
      firstname: respJson["firstname"],
      gender: respJson["gender"],
      phone: respJson["phone"],
      email: respJson["email"],
    ));
    users.add(User(
      address: respJson["address"],
      dob: respJson["dob"],
      firstname: respJson["firstname"],
      gender: respJson["gender"],
      phone: respJson["phone"],
      email: respJson["email"],
    ));
    users.add(User(
      address: respJson["address"],
      dob: respJson["dob"],
      firstname: respJson["firstname"],
      gender: respJson["gender"],
      phone: respJson["phone"],
      email: respJson["email"],
    ));

     setState(() {

    count = users.length;
    print(count);
    });
    return users;
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue1 = value;

      switch (_radioValue1) {
        case 0:
          _userType = "0";

          break;
        case 1:
          _userType = "1";

          break;
        case 2:
          _userType = "2";

          break;
      }
    });
  }



  int _selectedIndex = 0;
  PageController _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchNetworkCall();
    _pageController = PageController();

  }



  @override
  Widget build(BuildContext context) {
    int _radioValue1 = 0;
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.brown,
        ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                        Text("Welcome ${widget.name.length > 10 ? widget.name.substring(0, 10):widget.name}...", style: TextStyle(color: Colors.white, fontSize: 18)),
                    Image.asset("assets/images/isocial.png",)
                  ],
                ),

              ),
            ),
            ListTile(
              title: Text("Profile"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Profile(id: widget.id,)));
              },
              leading: Icon(
                Icons.person,
                color: Colors.amber,
              ),
            ),
            Divider(
              height: 2,
              color: Colors.brown,
            ),
            ListTile(
              title: Text("Change Password"),
              onTap: () {},
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.amber,
              ),
            ),
            Divider(
              height: 2,
              color: Colors.brown,
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () {},
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.amber,
              ),
            ),
            Divider(
              height: 2,
              color: Colors.brown,
            ),
          ],
        ),
      ),
      appBar: AppBar(

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabbarHeader(
            controller: controller,
            tabs: [
              Tab(text: "Posts"),
              Tab(text: "Friends"),
              Tab(text: "Churches"),
              Tab(text: "Moderator"),
            ],
          ),
        ),
        title: Text(
          "Almighty Book",
          maxLines: 2,
        ),
        centerTitle: false,
      ),
      body: TabbarContent(
        controller: controller,
        children: <Widget>[
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: users == null || users.length == 0
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white.withAlpha(0),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.brown),
                        ),
                      )
                    : ListView.builder(
                        itemCount: count,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 6),
                            child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Colors.brown.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 8),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.06,
                                              backgroundColor: Colors.brown,
                                              child: CircleAvatar(
                                                radius: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.058,
                                                backgroundImage: AssetImage(
                                                    "assets/images/profile.jpg"),
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("James Anderson",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[600])),
                                                Text("Oct 8, 2020",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[600]))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Image.asset(
                                        "assets/images/roses.jpeg",
                                      ),
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("20 Likes"),
                                          Text("34 comments"),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RaisedButton(
                                            child: Text("Like"),
                                            onPressed: () {},
                                          ),
                                          RaisedButton(
                                            child: Text("Comment"),
                                            onPressed: () {},
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          );
                        }),
              )
            ],
          ),
          Friends(id: widget.id,),
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: users == null || users.length == 0
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white.withAlpha(0),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.brown),
                        ),
                      )
                    : ListView.builder(
                        itemCount: count,
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            child: CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  "assets/images/church.jpg"),
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1273,
                                            ),
                                            radius: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.13,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  users[index].firstname,
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
                                                    color: Colors.orangeAccent,
                                                    size: 18),
                                                Text("200 Members",
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
                                                          Colors.brown,
                                                      size: 18),
                                                  Text("Pastor John Cena",
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
                                                      color: Colors.lightGreen,
                                                      size: 18),
                                                  Text("Pune",
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
                                    Divider(color: Colors.brown),
                                  ],
                                )),
                          );
                        }),
              )
            ],
          ),
          Container(color: Colors.orange),
        ],
      ),
      /*  bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        }),
       items: [
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.book),
              title: Text('Library'),
              activeColor: Colors.purpleAccent),
          BottomNavyBarItem(
              icon: Icon(Icons.add_box),
              title: Text('Prayers'),
              activeColor: Colors.pink),
          BottomNavyBarItem(
              icon: Icon(Icons.wb_sunny),
              title: Text('Counselling'),
              activeColor: Colors.blue),
        ],
      ),*/
    );
  }
}
