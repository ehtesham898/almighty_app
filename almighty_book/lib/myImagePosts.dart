import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ImagePosts extends StatefulWidget {
  String id;
  ImagePosts({this.id});
  @override
  _ImagePostsState createState() => _ImagePostsState();
}

class _ImagePostsState extends State<ImagePosts> {

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

  startUpload() {

    if (null == _image) {

      return;
    }
    String fileName = _image.path.split('/').last;

    upload(fileName);
  }
  String base64Image;
  String uploadEndPoint = 'http://api-v1.bottrion.com/api/upload_image.php';
  upload(String fileName) {


    base64Image = base64Encode(_image.readAsBytesSync());
    Map<String, String> headers = {"Content-type": "application/json"};
//log(base64Image.toString());
    http.post(uploadEndPoint, headers: headers, body: '{"image": "$base64Image","id": "${widget.id}","name": "profile${new DateTime.now().second}"}').then((result) {

      if(result.statusCode == 1021){
        Scaffold.of(context).showSnackBar(SnackBar(content:Text("Error in uploading image as it is invalid")));
      }else if(result.statusCode == 1022){
        Scaffold.of(context).showSnackBar(SnackBar(content:Text("Image format should be png, jpg or gif")));
      }
    }).catchError((error) {
      Scaffold.of(context).showSnackBar(SnackBar(content:Text("Server encountered an error")));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.withOpacity(0.7),
      appBar: AppBar(
        title: Text("Post an image"),

      ),
body:  SafeArea(
  child:   Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: 20,),
    Text("Click on the camera icon to select/reselect an image", style: TextStyle(color: Colors.white, fontFamily: "Raleway-Bold", fontSize: 12)),
        SizedBox(height: 20,),
        IconButton(
          icon: Icon(Icons.photo_camera,
              color: Colors.white, size: 65),
          onPressed: () {
            _showPicker(context);
          },
        ),
        SizedBox(height: 30,),
        _image != null ? Container(
          height: MediaQuery.of(context).size.height*0.6,
          child: Image.file(_image),
          decoration: BoxDecoration(
borderRadius: BorderRadius.circular(20),
          ),
        ):
            Container(),
        SizedBox(height: 10,),
        RaisedButton(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Text('POST',
                style:
                TextStyle(color: Colors.brown)),
          ),
          color: Colors.amber,
          onPressed: () {
            startUpload();
          },
        ),

      ],
    ),
  ),
),
    );
  }
}
