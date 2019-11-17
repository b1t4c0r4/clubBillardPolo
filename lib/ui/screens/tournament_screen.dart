import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poloTournamnets/business/session.dart';
import 'package:poloTournamnets/models/player.dart';
import 'package:poloTournamnets/models/tournament.dart';
import 'package:poloTournamnets/providers/data_service.dart';
import 'package:poloTournamnets/ui/screens/phases_screen.dart';
import 'package:poloTournamnets/ui/widgets/custom_flat_button.dart';
import 'package:provider/provider.dart';

class TorunamentScreen extends StatefulWidget {
  
  final String titleBar;
  final Tournamnet tournament;
  final Session session;

  TorunamentScreen({this.titleBar, this.tournament, this.session});

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
  Widget build(BuildContext context){

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
            icon: Icon(Icons.settings, size: (widget.session.user.isAdmin == false) ? 0 : 25),            
            tooltip: "Configuracion",
            color: Colors.blue[300],
            onPressed: (){
                if( widget.session.user.isAdmin == true){

                  // Navigator.of(context).pushNamed("/tournament");
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PhaseScreen(titleBar: 'Fases de '+widget.titleBar, tournament: widget.tournament, session: widget.session),
                    )
                  );
                }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_box),            
            tooltip: 'Registrarme',
            // iconSize: (_isRegistered()) ? 35 : 0,
            color: Colors.blue,
            onPressed: () async {
              // _scaffoldKey.currentState.showSnackBar(snackBar);                  
                if( DateTime.now().isBefore(widget.tournament.date.toDate()) ){

                  Player player = new Player(
                    nickname: widget.session.user.firstName,
                    photoUrl: widget.session.user.profilePictureURL,
                    userId: widget.session.userId
                  );
                  
                  if( players.where((player) => player.userId == widget.session.userId).toList().length == 0 ){

                    provider.registerPlayerInTournamnet(widget.tournament.id, player);    
                    _showErrorAlert(title: "BIENVENIDO", content: "Al torneo. Con ud son ${players.length+1} haga cuentas e ilusione.");          

                  }else{
                    _showErrorAlert(title: "!!!!!", content: "Que si ya esta calmese.");          
                  }
                                  
                }else{
                  _showErrorAlert(title: "PAILAS :(", content: "Se perdio de la oporunitdad.");
                }
            },
          ),       
        ],
      ),
      body: StreamBuilder(
              stream: provider.streamFetchPlayerByTorunamnetId(widget.tournament.id) ,
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
                          trailing: ( players[index].userId == widget.session.userId) 
                            ? IconButton( 
                              icon: Icon(Icons.remove_circle, color: Colors.red), 
                              onPressed: (){
                                if( players[index].userId == widget.session.userId && widget.tournament.date.toDate().difference(DateTime.now()).inDays > 1 ){
                                  provider.removePlayerInTournamnet(widget.tournament.id, widget.session.userId);
                                }else{
                                  if( DateTime.now().difference(widget.tournament.date.toDate()).inDays <= 2  ){
                                    _showErrorAlert(title: "HUUYY!!!", content: "Ya no se permite patraciar.");
                                  }else{
                                    _showErrorAlert(title: "DE VERDAD!!!", content: "Esto ya paso hace rato. Que hace aca?");
                                  }                                  
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

  // void _cloaseAlert() {
  //   Navigator.pop(context);
  // }

  void _showErrorAlert({String title, String content}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Text(
            title,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.none,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: "OpenSans",
            ),
          ),
          content: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  content,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    fontFamily: "OpenSans",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CustomFlatButton(
                    title: "OK",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textColor: Colors.black54,
                    onPressed: () {
                      // onPressed();
                      Navigator.of(context).pop();
                    },
                    splashColor: Colors.black12,
                    borderColor: Colors.black12,
                    borderWidth: 2,
                  ),
                ),
              ],
            ),
          ),
          // content: Text(content),
          // title: Text(title),
          // actions: <Widget>[
          //   FlatButton(
          //     onPressed: (){
          //       _cloaseAlert();
          //     },
          //     child: Text("OK"),
          //   )
          // ],
        );
      },
    );
  }
  
}