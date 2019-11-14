// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TorunamentScreen extends StatefulWidget {
  
  //final FirebaseUser firebaseUser;
  final String titleBar;

  // TorunamentScreen({this.firebaseUser});
  TorunamentScreen({this.titleBar});

  _TorunamentScreenState createState() => _TorunamentScreenState();
}

class _TorunamentScreenState extends State<TorunamentScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // print(widget.firebaseUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.5,
        leading: new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        title: Text(widget.titleBar),
        centerTitle: true,
      ),
      body: Container()
    );
  }

}