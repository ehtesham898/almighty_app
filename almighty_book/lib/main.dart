import 'package:AlmightyBook/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import "dart:convert";
import "package:shared_preferences/shared_preferences.dart";
import "package:intl_phone_field/intl_phone_field.dart";
import "package:flutter/services.dart";
import "package:geolocator/geolocator.dart";
import "package:geocoder/geocoder.dart";

void main() {
  runApp(
    Phoenix(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Almighty Book',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: "Almighty Book",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  bool login = true;
  MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

SharedPreferences prefsValid;

class _MyHomePageState extends State<MyHomePage> {
  logInVerifierFuture() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefsValid = prefs;
      if (null != prefsValid) {
        if (null != prefsValid.getString("name") &&
            prefsValid.getString("name").isNotEmpty) {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Dashboard(
                        name: prefsValid.getString("name"),
                        id: prefsValid.getString("id"),
                      )));
        } else {
          setState(() {
            waiting = false;
          });
        }
      }
    });
  }

  @override
  initState() {
    super.initState();

    setState(() {
      waiting = true;
    });
    logInVerifierFuture();
  }

  bool reg = false;
  showAlert(bool success, String header, String description) {
    setState(() {
      this.waiting = false;
    });
    Alert(
      context: context,
      type: success ? AlertType.success : AlertType.error,
      title: header,
      desc: description,
      buttons: [
        DialogButton(
            child: Text(
              "Done",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              reg == true ? Phoenix.rebirth(context) : Navigator.pop(context);
            },
            width: 120)
      ],
    ).show();
  }

  registerNewUser() async {
    LocationPermission permission = await requestPermission();
    if (permission.toString().contains("whileInUse") ||
        permission.toString().contains("always")) {
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final coordinates =
          new Coordinates(position.latitude, position.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;

      String url = 'http://api-v1.bottrion.com/api/create_user.php';
      Map<String, String> headers = {"Content-type": "application/json"};

      String regDetails =
          '{"firstname" : "${name.text}", "email": "${email.text}", "countryCode":"${cc}", "phone": "${number}", "password": "${pwd.text}", "address": "${first.addressLine}","gender": "-1","dob":"Not updated","preacher":"-1","churchname":"Not updated","pastorname":"notupdated", "latitude": "${position.latitude}", "longitude": "${position.longitude}"}';
      print(regDetails);
      prefsValid.setString("countryCode", cc);
      Response response = await post(url, headers: headers, body: regDetails);

      int statusCode = response.statusCode;
      String body = response.body;
      var mapBody = json.decode(body);

      setState(() {
        waiting = false;
      });
      //  if (statusCode == 200) {
      if (mapBody["status"] == "1000") {
        // prefsValid.getString("jwt");
        /////   prefsValid.setString("n", "${name.text}");
        //  prefsValid.getString("n");
        String desc =
            "Hi ${name.text}. A verification email has been sent to ${email.text}. Please click on the verification link in the mail body and login to your profile";
        setState(() {
          reg = true;
        });

        showAlert(true, mapBody["message"], desc);
      } else if (mapBody["status"] == "1002") {
        String desc =
            "Sorry profile could not be created. Email ${email.text} already exists";
        showAlert(false, mapBody["message"], desc);
      } else if (mapBody["status"] == "1010") {
        String desc =
            "The email ${email.text} entered by you is having invalid format";
        showAlert(false, mapBody["message"], desc);
      } else if (mapBody["status"] == "1008") {
        String desc = "Access granted";
        showAlert(true, mapBody["message"], desc);
      } else {
        String desc = "Sorry profile could not be created.";
        showAlert(false, mapBody["message"], desc);
      }
    } else {
      showAlert(false, "Location access not granted",
          "Please allow us to know your location");
    }

    // } else {
    // showAlert(false, "Issue encountered", "Please try after sometime");
    //}

    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AlertPreLogin(message: body,createdProfile: true,email: email.text, name: name.text,)));
  }

  login() async {
    String url = 'http://api-v1.bottrion.com/api/login.php';
    String urlTokenValidate =
        'http://api-v1.bottrion.com/api/validate_token.php';
    Map<String, String> headers = {"Content-type": "application/json"};

    String loginDetails =
        '{"email": "${email.text}", "password": "${pwd.text}"}';

    Response response = await post(url, headers: headers, body: loginDetails);

    int statusCode = response.statusCode;
    String body = response.body;

    var mapBody = json.decode(body);

    setState(() {
      waiting = false;
    });

    // if (statusCode == 200) {
    if (mapBody["status"] == "1006") {
      if (mapBody["active"] == "1") {
        String jwt = mapBody["jwt"];
        Response responseTokenValidate = await post(urlTokenValidate,
            headers: headers, body: '{"token":"${mapBody['jwt']}"');
        var tokenRespJson = json.decode(responseTokenValidate.body);
        if (mapBody["jwt"] == tokenRespJson["jwt"]) {
          prefsValid.setString("jwt", "${mapBody['jwt']}");
          prefsValid.setString("name", "${mapBody['firstname']}");
          prefsValid.setString("id", "${mapBody['iduser']}");
          prefsValid.setString("password", "${pwd.text}");
          print(prefsValid.getString("id"));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Dashboard(
                      name: '${mapBody["firstname"]}',
                      id: '${mapBody["iduser"]}')));
        } else {
          showAlert(false, "Login failed",
              "Verification failed at server. Try after sometime");
        }
      } else {
        String desc =
            "Please verify the activation email sent to ${email.text} and login again";
        showAlert(false, "Email not verified", desc);
      }
    } else if (mapBody["status"] == "1004") {
      String desc = "The password entered by you is incorrect";
      showAlert(false, mapBody["message"], desc);
    } else if (mapBody["status"] == "1005") {
      String desc =
          "The email ${email.text} entered by you is not registered. Please register.";
      showAlert(false, mapBody["message"], desc);
    } else if (mapBody["status"] == "1010") {
      String desc =
          "The email ${email.text} entered by you is having invalid format";
      showAlert(false, mapBody["message"], desc);
    } else if (mapBody["status"] == "1011") {
      String desc =
          "The phone ${mobile.text} entered by you is having invalid format";
      showAlert(false, mapBody["message"], desc);
    } else if (mapBody["status"] == "1008") {
      String desc = "Access granted";
      showAlert(true, mapBody["message"], desc);
    } else {
      String desc = "Sorry, we could not log you in.";
      showAlert(false, mapBody["message"], desc);
    }
    // } else {

    //   showAlert(false, mapBody["message"], "Sorry, we could not log you in");
    // }

    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AlertPreLogin(message: body,createdProfile: true,email: email.text, name: name.text,)));
  }

  String number = "";
  String cc = "";
  bool waiting = false;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController cpwd = TextEditingController();
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Almighty Book'),
          centerTitle: true,
          backgroundColor: Color(0xff8e724f),
        ),
        body: waiting
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white.withAlpha(0),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                ),
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset("assets/images/mobile-bkg.jpeg",
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            widget.login == true
                                ? Text("")
                                : Container(
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: OutlineButton(
                                        onPressed: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 1, 0, 1),
                                          child: Image(
                                              image: AssetImage(
                                                  "assets/images/google_logo.png"),
                                              height: 35.0),
                                        ),
                                      ),
                                    ),
                                  ),
                            CircleAvatar(
                              child: Image.asset(
                                "assets/images/isocial.png",
                                fit: BoxFit.scaleDown,
                              ),
                              radius: widget.login == true
                                  ? MediaQuery.of(context).size.width * 0.14
                                  : MediaQuery.of(context).size.width * 0.12,
                            ),
                            widget.login == true
                                ? Text("")
                                : Container(
                                    child: CircleAvatar(
                                      radius: 33,
                                      backgroundColor: Colors.white,
                                      child: OutlineButton(
                                        onPressed: () {},
                                        child: Image(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                "assets/images/facebook_logo.png"),
                                            height: 35.0),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        ClipPath(
                          clipper: WaveClipperTwo(reverse: true),
                          child: Container(
                              padding: EdgeInsets.only(top: 40),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 60),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: widget.login == true
                                                      ? 3.0
                                                      : 0,
                                                  color: Color(0xff8e724f)),
                                            ),
                                          ),
                                          child: FlatButton(
                                            child: Text(
                                              "SIGN IN",
                                              style: TextStyle(
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                  fontSize: 15),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                widget.login = true;
                                              });
                                            },
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: widget.login == false
                                                      ? 3.0
                                                      : 0,
                                                  color: Color(0xff8e724f)),
                                            ),
                                          ),
                                          child: FlatButton(
                                            child: Text(
                                              "SIGN UP",
                                              style: TextStyle(
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                  fontSize: 15),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                widget.login = false;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Form(
                                      key: formKey,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        child: Column(
                                          children: [
                                            widget.login == true
                                                ? Text("")
                                                : Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 7.0),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (null == value ||
                                                            value.isEmpty) {
                                                          return "Enter name";
                                                        }
                                                        return null;
                                                      },
                                                      keyboardType:
                                                          TextInputType.name,
                                                      controller: name,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            new EdgeInsets
                                                                    .symmetric(
                                                                vertical: 14.0,
                                                                horizontal:
                                                                    10.0),
                                                        labelText: 'Name',
                                                        labelStyle: TextStyle(
                                                            color: Colors
                                                                .deepPurpleAccent,
                                                            fontSize: 16),
                                                        icon: Icon(
                                                          Icons.perm_identity,
                                                          color:
                                                              Color(0xff8e724f),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .deepPurpleAccent,
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Color(
                                                                        0xff8e724f),
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            23))),
                                                        errorBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            23))),
                                                      ),
                                                    ),
                                                  ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 7.0),
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (null == value ||
                                                      value.isEmpty) {
                                                    return "Enter email";
                                                  }
                                                  /*else {
                                                    if (!RegExp(
                                                    r'(^[_a-z0-9-]+(\.[_a-z0-9-]+)@[a-z0-9-]+(\.[a-z0-9-]+)(\.[a-z]{2,})$)')
                                                        .hasMatch(value)) {
                                                      return "Enter valid email";
                                                    }
                                                  }*/
                                                  return null;
                                                },
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                controller: email,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      new EdgeInsets.symmetric(
                                                          vertical: 14.0,
                                                          horizontal: 10.0),
                                                  labelText: 'Email',
                                                  labelStyle: TextStyle(
                                                      color: Colors
                                                          .deepPurpleAccent,
                                                      fontSize: 15),
                                                  icon: Icon(
                                                    Icons.email,
                                                    color: Color(0xff8e724f),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Colors
                                                              .deepPurpleAccent,
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color(
                                                                  0xff8e724f),
                                                              width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  23))),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1.0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          23))),
                                                ),
                                              ),
                                            ),
                                            widget.login == true
                                                ? Text("")
                                                : Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 7.0),
                                                    child: IntlPhoneField(
                                                      controller: mobile,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            new EdgeInsets
                                                                    .symmetric(
                                                                vertical: 14.0,
                                                                horizontal:
                                                                    10.0),
                                                        labelText: 'Phone',
                                                        labelStyle: TextStyle(
                                                            color: Colors
                                                                .deepPurpleAccent,
                                                            fontSize: 16),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .deepPurpleAccent,
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Color(
                                                                        0xff8e724f),
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            23))),
                                                        errorBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            23))),
                                                      ),
                                                      initialCountryCode: "IN",
                                                      onChanged: (phone) {
                                                        setState(() {
                                                          number = phone.number;
                                                          cc =
                                                              phone.countryCode;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                            /*    widget.login == true
                                                ? Text('')
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (null == value ||
                                                            value.isEmpty) {
                                                          return "Enter mobile";
                                                        }
                                                        /*else {
                                                          String pattern =
                                                              r'(^[6-9][0-9]{9}$)';
                                                          RegExp regExp =
                                                              new RegExp(
                                                                  pattern);
                                                          if (value.length ==
                                                              0) {
                                                            return 'Enter mobile';
                                                          } else if (!regExp
                                                              .hasMatch(
                                                                  value)) {
                                                            return 'Enter valid mobile';
                                                          }
                                                        }*/
                                                        return null;
                                                      },
                                                      controller: mobile,
                                                      keyboardType:
                                                          TextInputType.phone,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Mobile',
                                                        labelStyle: TextStyle(
                                                            color: Colors
                                                                .deepPurpleAccent,
                                                            fontSize: 16),
                                                        icon: Icon(
                                                          Icons.phone_iphone,
                                                          color:
                                                              Color(0xff8e724f),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .deepPurpleAccent,
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Color(
                                                                        0xff8e724f),
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            23))),
                                                        errorBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            23))),
                                                      ),
                                                    ),
                                                  ),*/
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 7.0),
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (null == value ||
                                                      value.isEmpty) {
                                                    return "Enter password";
                                                  }
                                                  return null;
                                                },
                                                controller: pwd,
                                                keyboardType:
                                                    TextInputType.text,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      new EdgeInsets.symmetric(
                                                          vertical: 14.0,
                                                          horizontal: 10.0),
                                                  labelText: 'Password',
                                                  labelStyle: TextStyle(
                                                      color: Colors
                                                          .deepPurpleAccent,
                                                      fontSize: 16),
                                                  icon: Icon(
                                                    Icons.lock_outline,
                                                    color: Color(0xff8e724f),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Colors
                                                              .deepPurpleAccent,
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color(
                                                                  0xff8e724f),
                                                              width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  23))),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1.0),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          23))),
                                                ),
                                              ),
                                            ),
                                            widget.login == true
                                                ? Text('')
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12.0,
                                                            right: 12,
                                                            top: 6,
                                                            bottom: 7.0),
                                                    child: TextFormField(
                                                      controller: cpwd,
                                                      validator: (value) {
                                                        if (null == value ||
                                                            value.isEmpty) {
                                                          return "Confirm password";
                                                        } else if (pwd.text !=
                                                            value) {
                                                          return "Password and Confirm Password do not match";
                                                        }
                                                        return null;
                                                      },
                                                      keyboardType:
                                                          TextInputType.text,
                                                      obscureText: true,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            new EdgeInsets
                                                                    .symmetric(
                                                                vertical: 14.0,
                                                                horizontal:
                                                                    10.0),
                                                        labelText:
                                                            'Confirm Password',
                                                        labelStyle: TextStyle(
                                                            color: Colors
                                                                .deepPurpleAccent,
                                                            fontSize: 16),
                                                        icon: Icon(
                                                          Icons.lock,
                                                          color:
                                                              Color(0xff8e724f),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .deepPurpleAccent,
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Color(
                                                                        0xff8e724f),
                                                                    width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            23))),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: RaisedButton(
                                      child: Padding(
                                        padding: const EdgeInsets.all(13.0),
                                        child: Text('CONTINUE',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      color: Colors.deepPurpleAccent,
                                      onPressed: () {
                                        if (formKey.currentState.validate()) {
                                          setState(() {
                                            waiting = true;
                                          });
                                          widget.login
                                              ? login()
                                              : registerNewUser();
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: FlatButton(
                                        onPressed: () {},
                                        child: Text('Forgot password?',
                                            style: TextStyle(
                                                color: Color(0xff8e724f)))),
                                  )
                                ],
                              )),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Text('All rights reserved - Almighty Book',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
  }
}
