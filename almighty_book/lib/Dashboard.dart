import 'package:AlmightyBook/index.dart';
import 'package:AlmightyBook/pushNotifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Profile.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:AlmightyBook/User.dart';
import 'package:tabbar/tabbar.dart';
import 'Friends.dart';
import 'currentUserPosts.dart';
import 'library.dart';
import 'myImagePosts.dart';
import 'myVideoPosts.dart';

class Dashboard extends StatefulWidget {
  String name;
  String id;
  Dashboard({this.name, this.id});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  logout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    Phoenix.rebirth(context);
  }

  GlobalKey<FormState> key = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> keyscaffold = GlobalKey<ScaffoldState>();
  TextEditingController postForm = TextEditingController();
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

  List _pages = [
    Library(msg: "Home"),
    Library(msg: "Search"),
    Library(msg: "Account"),
  ];
  int _currentIndex = 0;
  _changeIndex(int index) {
    // setState(() {
    //  _currentIndex = index;
    // });

    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => _pages[index]));
  }

  @override
  Widget build(BuildContext context) {
    int _radioValue1 = 0;
    return Scaffold(
      key: keyscaffold,
      backgroundColor: Colors.brown.withOpacity(0.5),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "${widget.name}",
                style: TextStyle(fontFamily: 'Raleway-SemiBold',),
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: AssetImage(("assets/images/isocial.png")),
              ),
            ),
            ListTile(
              title: Text(
                "Profile",
                style: TextStyle(fontFamily: 'Raleway-SemiBold'),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Profile(
                              id: widget.id,
                            )));
              },
              leading: CircleAvatar(
                  child: Icon(
                Icons.person,
                color: Colors.white,
              )),
            ),
            Divider(
              height: 2,
              color: Colors.brown,
            ),
            ListTile(
              title: Text(
                "Counselling",
                style: TextStyle(fontFamily: 'Raleway-SemiBold'),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => IndexPage()));
              },
              leading: CircleAvatar(
                  child: Icon(
                    Icons.video_call,
                    color: Colors.white,
                  )),
            ),
            Divider(
              height: 2,
              color: Colors.brown,
            ),
            ListTile(
              title: Text(
                "Change Password",
                style: TextStyle(fontFamily: 'Raleway-SemiBold'),
              ),
              onTap: () {},
              leading: CircleAvatar(
                  child: Icon(
                Icons.mode_edit,
                color: Colors.white,
              )),
            ),
            Divider(
              height: 2,
              color: Colors.brown,
            ),
            ListTile(
              title: Text(
                "Logout",
                style: TextStyle(fontFamily: 'Raleway-SemiBold'),
              ),
              onTap: () {
                logout();
              },
              leading: CircleAvatar(
                  child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              )),
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
              Tab(
                text: "Posts",
              ),
              Tab(text: "Friends"),
              Tab(text: "Churches"),
              Tab(text: "Moderator"),
            ],
          ),
        ),
        title: Text(
          "Almighty Book",
          maxLines: 2,
          style: TextStyle(fontFamily: 'Raleway-SemiBold'),
        ),
        centerTitle: false,
      ),
      body: TabbarContent(
        controller: controller,
        children: <Widget>[
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.brown,
                    gradient: LinearGradient(colors: [
                      Colors.white.withOpacity(0.65),
                      Colors.white.withOpacity(0.77)
                    ])),
                child: Column(
                  children: [
                    Container(
                      color: Colors.brown,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("New Post",
                                style: TextStyle(
                                    fontFamily: "Raleway-Bold",
                                    color: Colors.white,fontSize: 11)),
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: key,
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.width * 0.15,
                              child: TextFormField(

                                style: TextStyle(fontSize: 12,color: Colors.brown,),
                                maxLines: 1,
                                validator: (value) {
                                  if (null == value || value.isEmpty) {
                                    return "Please write something";
                                  }
                                  return null;
                                },
                                controller: postForm,
                                decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 14.0, horizontal: 10.0),

                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.brown, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.brown, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(23))),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(23))),
                                ),
                              ),
                            ),
                            Container(
                              width: 28,
                              child: IconButton(
                                icon: Icon(Icons.send, color: Colors.brown),
                                onPressed: () {
                                  if (key.currentState.validate()) {
                                    postForm.clear();
                                    keyscaffold.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text("Posted successfully"),
                                      duration: Duration(seconds: 2),
                                    ));
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: 28,
                              child: IconButton(
                                icon: Icon(Icons.image, color: Colors.brown),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ImagePosts(
                                                id: widget.id,
                                              )));
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.video_library,
                                  color: Colors.brown),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            VideoPosts()));
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  color: Colors.brown,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Previous Posts",
                            style: TextStyle(
                              fontSize: 11,
                                fontFamily: "Raleway-bold",
                                color: Colors.white)),
                      ),
                    ],
                  )),
              Expanded(
                  child: PostsCurrentUser(name: "My posts", id: widget.id)),
            ],
          ),
          Friends(
            id: widget.id,
          ),
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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.brown),
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
                                  color: Colors.white.withOpacity(0.3),
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
                                                      color: Colors.white,
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
                                                    color: Colors.white,
                                                    size: 18),
                                                Text("200 Members",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.white,
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
                                                      color: Colors.white,
                                                      size: 18),
                                                  Text("Pastor John Cena",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.white,
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
                                                      color: Colors.white,
                                                      size: 18),
                                                  Text("Pune",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.white,
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
          Container(
            child: Center(child: Text("Under Construction", style: TextStyle(color: Colors.white))),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber.withOpacity(0.4),
        type: BottomNavigationBarType.fixed,
        onTap: _changeIndex,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.white,
                size: 19,
              ),
              title: Text(
                "Home",
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Raleway-SemiBold'),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books, color: Colors.white, size: 19),
              title: Text("Library",
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Raleway-SemiBold'))),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: Colors.white, size: 19),
              title: Text("Prayers",
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Raleway-SemiBold'))),
          BottomNavigationBarItem(
              icon: Icon(Icons.help, color: Colors.white, size: 19),
              title: Text("Counselling",
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Raleway-SemiBold'))),
        ],
      ),
    );
  }
}
