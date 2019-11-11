import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poloTournamnets/business/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:poloTournamnets/models/providers/tournament_provider.dart';
import 'package:poloTournamnets/models/tournament.dart';
import 'package:provider/provider.dart';


class MainScreen extends StatefulWidget {
  final FirebaseUser firebaseUser;

  MainScreen({this.firebaseUser});

  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<Tournamnet> tournaments;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    print(widget.firebaseUser);
  }

  @override
  Widget build(BuildContext context) {

    final productProvider = Provider.of<TorunamentProvider>(context);
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.5,
        leading: new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        title: Text("Torneos"),
        centerTitle: true,
      ),
      drawer: _menu(),
      body: StreamBuilder(
        stream: productProvider.fetchTorunamentsAsStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {

            tournaments = snapshot.data.documents
              .map((doc) => Tournamnet.fromMap(doc.data, doc.documentID))
              .toList();

            return ListView.builder(
                itemCount: tournaments.length,
                itemBuilder: (buildContext, index){

                  return _itemTorunament(
                     tournaments[index].name, 
                     "En: " + tournaments[index].date.toDate().difference(DateTime.now()).inDays.toString() + ' dias.', 
                     tournaments[index].players
                  );
                }                 
                  
                );
          } else {
            return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(212, 20, 15, 1.0),
                  ),
                ),
              );
          }
        },
       ),



    );
  }

  Widget _itemTorunament(String title, String date, int players){

    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(title, style: TextStyle(
                  fontWeight: FontWeight.bold
                ))
              ),
              Text(date, 
                style: TextStyle(
                  color: Colors.grey[500]
                )
              )              
          ],) 
        ),
        Icon(Icons.people, color: Colors.blue),
        Text(players.toString())
      ],),
    );
  }

  Drawer _menu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: Text('Log Out'),
            onTap: () {
              _logOut();
              _scaffoldKey.currentState.openEndDrawer();
            },
          ),
        ],
      ),
    );
  }

  void _logOut() async {
    Auth.signOut();
  }
}
