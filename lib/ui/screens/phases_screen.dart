import 'package:flutter/material.dart';
import 'package:poloTournamnets/business/session.dart';
import 'package:poloTournamnets/models/tournament.dart';

class PhaseScreen extends StatefulWidget {
  
  final String titleBar;
  final Tournamnet tournament;
  final Session session;

  PhaseScreen({this.titleBar, this.tournament, this.session});

  _PhaseScreen createState() => _PhaseScreen();
}

class _PhaseScreen extends State<PhaseScreen> {

  // List<Player> players;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.5,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: (){ return Navigator.pop(context); }),
        title: Text(widget.titleBar),
        centerTitle: true
      ),
      body: Container(),
    );
  }
}