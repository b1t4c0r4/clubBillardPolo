import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poloTournamnets/models/player.dart';
import 'package:poloTournamnets/providers/data_service.dart';
// import 'package:poloTournamnets/providers/player_provider.dart';
import 'package:provider/provider.dart';

class TorunamentScreen extends StatefulWidget {
  
  final String titleBar;
  final String tournamentId;

  TorunamentScreen({this.titleBar, this.tournamentId});

  _TorunamentScreenState createState() => _TorunamentScreenState();
}

class _TorunamentScreenState extends State<TorunamentScreen> {

  List<Player> players;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // print(widget.firebaseUser);
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<DataService>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.5,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: (){ return Navigator.pop(context); }),
        title: Text(widget.titleBar),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: provider.streamFetchPlayerByTorunamnetId(widget.tournamentId) ,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          
          if (snapshot.hasData) {

            players = snapshot.data.documents
              .map((doc) => Player.fromDocument(doc))
              .toList();
            
            return ListView.builder(
                itemCount: players.length,
                itemBuilder: (buildContext, index){
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: ( players[index].photoUrl != '') 
                        ? NetworkImage(players[index].photoUrl)
                        : AssetImage('assets/images/default.png'),
                    ),
                    title: Text(players[index].nickname),
                    subtitle: Text(players[index].userId) //           <-- subtitle
                  );
                }                     
              );            
          } 

          return Container(child: Text(players[players.length-1].nickname));                
                  
        },
       )
    );
  }

}