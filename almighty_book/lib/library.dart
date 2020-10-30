import 'package:flutter/material.dart';

class Library extends StatefulWidget {
  String msg;

  Library({this.msg});

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.msg);
  }
}
