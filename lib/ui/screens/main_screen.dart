import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poloTournamnets/business/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:poloTournamnets/business/session.dart';
// import 'package:poloTournamnets/business/session.dart';
// import 'package:poloTournamnets/providers/tournament_provider.dart';
import 'package:poloTournamnets/models/tournament.dart';
// import 'package:poloTournamnets/models/user.dart';
import 'package:poloTournamnets/providers/data_service.dart';
import 'package:poloTournamnets/ui/screens/tournament_screen.dart';
import 'package:provider/provider.dart';


class MainScreen extends StatefulWidget {
  
  final FirebaseUser firebaseUser;
  // final User user;

  MainScreen({this.firebaseUser});

  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  // User _user;
  Session _session;
  List<Tournamnet> tournaments;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  @override
  void initState() {
    super.initState();
    //print(widget.firebaseUser);
    getUserInfo();
  }

  Future<void> getUserInfo( ) async {
    
    // final tempProvider = Provider.of<DataService>(context);
    await Auth.getUser(widget.firebaseUser.uid)
      .first
      .then( (user){
        _session = Session(userId: widget.firebaseUser.uid, user: user, firebaseUser: widget.firebaseUser);
        return true;
      });    
  }

  @override
  Widget build(BuildContext context) {

    // _user = Auth.getUser(widget.firebaseUser.uid).first.then(onValue) as User;         
    final provider = Provider.of<DataService>(context);
 
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
        stream: provider.streamFetchTorunaments(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
// print(snapshot.data.documents[0].toString());
            tournaments = snapshot.data.documents
              .map((doc) => Tournamnet.fromMap(doc.data, doc.documentID))
              .toList();

            return ListView.builder(
                itemCount: tournaments.length,
                itemBuilder: (buildContext, index){
// print(tournaments[index].players);
                  return _itemTorunament( context, tournaments[index] );
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

  Widget _itemTorunament(BuildContext context, Tournamnet tournamnet){

    String title = tournamnet.name;
    String date = "En: " + tournamnet.date.toDate().difference(DateTime.now()).inDays.toString() + ' dias.';
    int tplayers = tournamnet.tplayers;

    return Card( //                           <-- Card widget
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.only(top: 10),
          child: Column(children: <Widget>[
            Icon(Icons.person),
            Text(tplayers.toString())
          ],),
        ), 
        title: Text(title),
        subtitle: Text(date),
        onTap: (){
          // Navigator.of(context).pushNamed("/tournament");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TorunamentScreen(titleBar: title, tournament: tournamnet, session: _session),
            )
          );
        },
      ),
    );

    // return ListTile(
    //     contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    //     leading: Container(
    //       padding: EdgeInsets.only(right: 12.0),
    //       decoration: new BoxDecoration(
    //           border: new Border(
    //               right: new BorderSide(width: 1.0, color: Colors.black))),
    //       child: Icon(Icons.autorenew, color: Colors.black),
    //     ),
    //     title: Text(
    //       "Introduction to Driving",
    //       style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    //     ),
    //     // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
    //     onTap: () {

    //     },
    //     subtitle: Row(
    //       children: <Widget>[
    //         Icon(Icons.linear_scale, color: Colors.black),
    //         Text(" Intermediate", style: TextStyle(color: Colors.black))
    //       ],
    //     ),
    //     trailing:
    //         Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0));
  }

  Drawer _menu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Club Billar Polo'),      
          ),
          ListTile(
            title: Text('Salir'),
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
