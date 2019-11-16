import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:poloTournamnets/business/auth.dart';
import 'package:poloTournamnets/models/player.dart';
import 'package:poloTournamnets/models/user.dart';
import 'package:poloTournamnets/providers/data_service.dart';
// import 'package:poloTournamnets/providers/player_provider.dart';
import 'package:provider/provider.dart';

class TorunamentScreen extends StatefulWidget {
  
  final String titleBar;
  final String tournamentId;
  final FirebaseUser firebaseUser;

  TorunamentScreen({this.titleBar, this.tournamentId, this.firebaseUser});

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
    // bool _registered = false;

    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0.5,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: (){ return Navigator.pop(context); }),
        title: Text(widget.titleBar),
        centerTitle: true,
        actions: <Widget>[          
          IconButton(
            icon: const Icon(Icons.add_box),            
            tooltip: 'Registrarme',
            // iconSize: (_isRegistered()) ? 35 : 0,
            color: Colors.blue,
            onPressed: () async {
              // _scaffoldKey.currentState.showSnackBar(snackBar);

                  User _user = await provider.getUserById(widget.firebaseUser.uid);
                  // Stream<User> _user = ;
                  Player player = new Player(
                    nickname: _user.firstName,
                    photoUrl: _user.profilePictureURL,
                    userId: _user.userID
                  );

                  provider.registerPlayerInTournamnet(widget.tournamentId, player);              
            },
          ),
        ],
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
                      backgroundImage: ( players[index].photoUrl != '' ) 
                        ? NetworkImage(players[index].photoUrl)
                        : AssetImage('assets/images/default.png'),
                    ),
                    title: Text(players[index].nickname),
                    subtitle: Text(players[index].userId),
                    trailing: ( players[index].userId == widget.firebaseUser.uid) 
                      ? IconButton( 
                        icon: Icon(Icons.remove_circle, color: Colors.red), 
                        onPressed: (){
                          if( players[index].userId == widget.firebaseUser.uid ){
                            provider.removePlayerInTournamnet(widget.tournamentId, widget.firebaseUser.uid);
                          }
                        }) 
                      : null
                  );
                }                     
              ); 

          }else{

            return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(212, 20, 15, 1.0),
                  ),
                ),
              );
          }              
                  
        },
       )
    );
  }

}