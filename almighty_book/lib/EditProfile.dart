import 'package:AlmightyBook/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:flutter/services.dart";
import "package:geolocator/geolocator.dart";
import "package:geocoder/geocoder.dart";
import 'package:http/http.dart';
import "package:shared_preferences/shared_preferences.dart";
import "package:intl_phone_field/intl_phone_field.dart";
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:AlmightyBook/Profile.dart';
import 'dart:math';
class EditProfile extends StatefulWidget {
  String name;
  String email;
  String phone;
  String dob;
  String gender;
  String preacher;
  String address;
  String iduser;
  String avatar;
  EditProfile(
      {this.name,
      this.email,
      this.phone,
      this.dob,
      this.gender,
        this.iduser,
      this.preacher,
        this.avatar,
      this.address});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {


  File _image;
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  GlobalKey<FormState> editForm = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController pastorname = TextEditingController();
  TextEditingController churchname = TextEditingController();
  int _radioValue1 = -1;
  int _radioValue2 = -1;
  String genderValue = "";
  String preacherValue = "";
  var date;
  String errMessage = 'Error Uploading Image';
  String status = '';
  String base64Image;
  String uploadEndPoint = 'http://api-v1.bottrion.com/api/upload_image.php';
  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == _image) {
      setStatus(errMessage);
      return;
    }
    String fileName = _image.path.split('/').last;

    upload(fileName);
  }

  upload(String fileName) {


    base64Image = base64Encode(_image.readAsBytesSync());
    Map<String, String> headers = {"Content-type": "application/json"};
//log(base64Image.toString());
    http.post(uploadEndPoint, headers: headers, body: '{"image": "$base64Image","id": "${id}","name": "profile${new DateTime.now().second}"}').then((result) {

     if(result.statusCode == 1021){
       showAlert(false, "Invalid image uploaded", "Error in uploading image as it is invalid");
     }else if(result.statusCode == 1022){
       showAlert(false, "Image format unsupported", "Image format should be png, jpg or gif");
     }
    }).catchError((error) {
      setStatus(error);
    });
  }

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
              Navigator.pop(context);
              if (success) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Profile(id: widget.iduser,)));
              }
            },
            width: 120)
      ],
    ).show();
  }

  String c = "";
  getCountryCode() async {
    c = prefsValid.getString("countryCode");
  }

  bool waiting = false;
  submitEditDetails() async {
    // startUpload();
    waiting = true;
    startUpload();
    String urlSave = 'http://api-v1.bottrion.com/api/update_user.php';
    Map<String, String> headers = {"Content-type": "application/json"};
    String p = "";

    if (number.isEmpty) {
      p = mobile.text;
    } else {
      p = number;
    }
    if (countryCode.isEmpty) {
      getCountryCode();
    } else {
      c = countryCode;
    }
    String saveDetailsReq =
        '{"firstname" : "${name.text}", "email": "${email.text}", "phone": "$p","countryCode": "$c", "password": "${password.text}", "address": "${address.text}","gender": "$_radioValue1","dob":"$date","preacher":"$_radioValue2", "id":"$id"}';
print(saveDetailsReq);
    Response response =
        await post(urlSave, headers: headers, body: saveDetailsReq);

    int statusCode = response.statusCode;
    String body = response.body;
    var respBody = json.decode(body);
    setState(() {
      waiting = false;
    });
    if (respBody["status"] == "1019") {
      showAlert(true, respBody["message"], "Details have been saved");
    } else if (respBody["status"] == "1011") {
      showAlert(false, respBody["message"], "Mobile number is not a valid one");
    } else {
      showAlert(false, respBody["message"], "Details could not be saved");
    }
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue1 = value;

      switch (_radioValue1) {
        case 0:
          genderValue = "0";

          break;
        case 1:
          genderValue = "1";

          break;
        case 2:
          genderValue = "2";

          break;
      }
    });
  }

  void _handleRadioValueChangePreacher(int value) {
    setState(() {
      _radioValue2 = value;

      switch (_radioValue2) {
        case 0:
          setState(() {
            preacherValue = "0";
          });

          break;
        case 1:
          setState(() {
            preacherValue = "1";
          });
          break;
        case 2:
          setState(() {
            preacherValue = "2";
          });
          break;
      }
    });
  }

  String number = "";
  String countryCode = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    email.text = widget.email;
    mobile.text = widget.phone;
    name.text = widget.name;
    address.text = widget.address;
    _radioValue1 = int.parse('${widget.gender}');
    _radioValue2 = int.parse('${widget.preacher}');
    date = widget.dob;
    setPwd();
    fetchNetworkImage();
  }

  SharedPreferences prefValid;
  String id = "";
  var networkImg;
  setPwd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefValid = prefs;

    password.text = prefs.getString("password");
    id = prefs.getString("id");
  }
  fetchNetworkImage() async {

    Response re = await get("${widget.avatar}");
    if (re.statusCode == 404 || re.statusCode == 403) {
      setState(() {
        networkImg = AssetImage('assets/images/no-image.jpg');
      });

    }
    else{
      print(" cvc${widget.avatar}");
      setState(() {
        networkImg = NetworkImage(
            "${widget.avatar}");
      });

    }

  }
  fetchCurrentAddress() async {
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
      setState(() {
        address.text = first.addressLine;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body: waiting
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white.withAlpha(0),
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 8, right: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                child: ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 32,
                        ),
                        Text("${status}"),
                        Center(
                          child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Color(0xffFDCF09),
                              child: _image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.file(
                                        _image,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundImage: networkImg == null ? AssetImage('assets/images/no-image.jpg'): networkImg,
                                      radius: 50,
                                    )),
                        ),
                        IconButton(
                          icon: Icon(Icons.photo_camera,
                              color: Colors.deepPurpleAccent, size: 35),
                          onPressed: () {
                            _showPicker(context);
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),

                    Form(
                        key: editForm,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 5.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (null == value || value.isEmpty) {
                                    return "Enter name";
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
                                keyboardType: TextInputType.name,
                                controller: name,
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.perm_identity,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 10.0),
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                      color: Colors.deepPurpleAccent,
                                      fontSize: 15),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.deepPurpleAccent,
                                          width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xff8e724f), width: 1.0),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 5.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (null == value || value.isEmpty) {
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
                                keyboardType: TextInputType.emailAddress,
                                controller: email,
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.alternate_email,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 10.0),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                      color: Colors.deepPurpleAccent,
                                      fontSize: 15),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.deepPurpleAccent,
                                          width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xff8e724f), width: 1.0),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 7.0),
                              child: IntlPhoneField(
                                controller: mobile,
                                decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 14.0, horizontal: 10.0),
                                  labelText: 'Phone',
                                  labelStyle: TextStyle(
                                      color: Colors.deepPurpleAccent,
                                      fontSize: 16),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.deepPurpleAccent,
                                          width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xff8e724f), width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(23))),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(23))),
                                ),
                                initialCountryCode: 'IN',
                                onChanged: (phone) {
                                  setState(() {

                                    number = phone.number;
                                    countryCode = phone.countryCode;
                                  });
                                },
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 5.0),
                                child: TextFormField(
                                  enabled: false,
                                  validator: (value) {
                                    if (null == value || value.isEmpty) {
                                      return "Enter password";
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
                                  keyboardType: TextInputType.number,
                                  controller: password,
                                  decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.do_not_disturb_alt,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 10.0),
                                    labelText: 'Password (Read only)',
                                    labelStyle: TextStyle(
                                        color: Colors.deepPurpleAccent,
                                        fontSize: 15),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.deepPurpleAccent,
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xff8e724f),
                                            width: 1.0),
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
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  OutlineButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime(1900, 1, 1),
                                          maxTime: DateTime.now(),
                                          onConfirm: (dateValue) {
                                        setState(() {
                                          String m = dateValue.month < 10
                                              ? "0${dateValue.month}"
                                              : "${dateValue.month}";
                                          String d = dateValue.day < 10
                                              ? "0${dateValue.day}"
                                              : "${dateValue.day}";
                                          this.date = "${dateValue.year}-$m-$d";
                                        });
                                      }, locale: LocaleType.en);
                                    },
                                    child: Text("Select dob/establishment"),
                                    textColor: Colors.deepPurpleAccent,
                                  ),
                                  this.date == null
                                      ? Text("${widget.dob}")
                                      : Text('$date'),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                new Radio(
                                  value: 0,
                                  groupValue: _radioValue1,
                                  onChanged: _handleRadioValueChange,
                                ),
                                new Text(
                                  'Male',
                                  style: new TextStyle(fontSize: 12.0),
                                ),
                                new Radio(
                                  value: 1,
                                  groupValue: _radioValue1,
                                  onChanged: _handleRadioValueChange,
                                ),
                                new Text(
                                  'Female',
                                  style: new TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                                new Radio(
                                  value: 2,
                                  groupValue: _radioValue1,
                                  onChanged: _handleRadioValueChange,
                                ),
                                new Text(
                                  'Others',
                                  style: new TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                new Radio(
                                  value: 0,
                                  groupValue: _radioValue2,
                                  onChanged: _handleRadioValueChangePreacher,
                                ),
                                new Text(
                                  'Church',
                                  style: new TextStyle(fontSize: 12.0),
                                ),
                                new Radio(
                                  value: 1,
                                  groupValue: _radioValue2,
                                  onChanged: _handleRadioValueChangePreacher,
                                ),
                                new Text(
                                  'Preacher',
                                  style: new TextStyle(fontSize: 12.0),
                                ),
                                new Radio(
                                  value: 2,
                                  groupValue: _radioValue2,
                                  onChanged: _handleRadioValueChangePreacher,
                                ),
                                new Text(
                                  'Non-preacher',
                                  style: new TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: preacherValue =="0",
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 5.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (null == value || value.isEmpty) {
                                      return "Enter pastor name";
                                    }

                                    return null;
                                  },
                                  keyboardType: TextInputType.name,
                                  controller: pastorname,
                                  decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.person,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 10.0),
                                    labelText: 'Pastor Name',
                                    labelStyle: TextStyle(
                                        color: Colors.deepPurpleAccent,
                                        fontSize: 15),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.deepPurpleAccent,
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xff8e724f), width: 1.0),
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
                            ),

                            Visibility(
                              visible: preacherValue =="1",
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 5.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (null == value || value.isEmpty) {
                                      return "Enter church name";
                                    }

                                    return null;
                                  },
                                  keyboardType: TextInputType.name,
                                  controller: churchname,
                                  decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.home,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 10.0),
                                    labelText: 'Church Name',
                                    labelStyle: TextStyle(
                                        color: Colors.deepPurpleAccent,
                                        fontSize: 15),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.deepPurpleAccent,
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xff8e724f), width: 1.0),
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
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 5),
                              child: Row(
                                children: [
                                  OutlineButton(
                                    child: Text("Select current address"),
                                    onPressed: () {
                                      fetchCurrentAddress();
                                    },
                                    textColor: Colors.deepPurpleAccent,
                                  ),
                                  Text(" or change manually below",
                                      style: TextStyle(fontSize: 11)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 10.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (null == value || value.isEmpty) {
                                    return "Enter address";
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
                                keyboardType: TextInputType.streetAddress,
                                controller: address,
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.location_on,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 10.0),
                                  labelText: 'Address',
                                  labelStyle: TextStyle(
                                      color: Colors.deepPurpleAccent,
                                      fontSize: 15),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.deepPurpleAccent,
                                          width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xff8e724f), width: 1.0),
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
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: RaisedButton(
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Text('SAVE',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                color: Colors.deepPurpleAccent,
                                onPressed: () {
                                  if (editForm.currentState.validate()) {
                                    submitEditDetails();
                                  }
                                },
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
    );
  }
}
