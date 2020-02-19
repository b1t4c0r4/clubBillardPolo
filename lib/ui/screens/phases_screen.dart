import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poloTournamnets/business/session.dart';
import 'package:poloTournamnets/business/validator.dart';
import 'package:poloTournamnets/models/phase.dart';
import 'package:poloTournamnets/models/player.dart';
import 'package:poloTournamnets/models/tournament.dart';
import 'package:poloTournamnets/providers/data_service.dart';
import 'package:poloTournamnets/ui/widgets/custom_flat_button.dart';
import 'package:poloTournamnets/ui/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class PhaseScreen extends StatefulWidget {
  
  final String titleBar;
  final Tournamnet tournament;
  final Session session;
  final List<Player> players;

  PhaseScreen({this.titleBar, this.tournament, this.session, this.players});

  _PhaseScreen createState() => _PhaseScreen();
}

class _PhaseScreen extends State<PhaseScreen> {

  List<Phase> phases;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CustomTextField _rondaField;
  final TextEditingController _ronda = new TextEditingController();

  
  @override
  void initState() {
    super.initState();

    _rondaField = new CustomTextField(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _ronda,
      hint: "Nombre de la ronda",
      inputType: TextInputType.text,
      validator: Validator.validateName,
    );
  }

  @override
  Widget build(BuildContext context){

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_box, size: (widget.session.user.isAdmin == false) ? 0 : 30),            
            tooltip: "Configuracion",
            color: Colors.blue[300],
            onPressed: (){
                if( widget.session.user.isAdmin == true){
                  _showAddPhase(context);
                }
            },
          ),
        ],
      ),      
      body: StreamBuilder(
        stream: provider.streamFetchPhasesByTorunamnetId(widget.tournament.id) ,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          
          if (snapshot.hasData) {

            phases = snapshot.data.documents
              .map((doc) => Phase.fromDocument(doc))
              .toList();
            
            return ListView.builder(
                itemCount: phases.length,
                itemBuilder: (buildContext, index){
                                    
                  return Card( //                           <-- Card widget
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(children: <Widget>[
                          Icon(Icons.group_work, size: 35)
                          // Text(phases[index].name )
                        ],),
                      ), 
                      title: Text(phases[index].name),
                      // subtitle: Text(date),
                      onTap: (){
                        Navigator.of(context).pushNamed("/tournament");
                        // Navigator.of(context).push(
                        //   //MaterialPageRoute(
                        //     // builder: (context) => TorunamentScreen(titleBar: title, tournament: tournamnet, session: _session),
                        //   //)
                        // );
                      },
                    ),
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

      }),
    );
  }

  void _showAddPhase( BuildContext context ) {

    final provider = Provider.of<DataService>(context);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Text(
            "Nombre de Fase",
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
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: _rondaField,
                ),                                
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomFlatButton(
                    title: "Agregar",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    textColor: Colors.black54,
                    onPressed: () {
                      // onPressed(){};
                      int phaseId = (phases == null) ? 1 : phases.length + 1;
                      var phase = Phase(id: phaseId.toString(), name: _ronda.text);                      
                      provider.addPhaseInTournamnet(widget.tournament.id, phase);
                      _ronda.clear();
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
        );
      },
    );
  }

  // void _showErrorAlert({String title, String content}) {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(32.0))),
  //         title: Text(
  //           title,
  //           softWrap: true,
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             color: Colors.black,
  //             decoration: TextDecoration.none,
  //             fontSize: 18,
  //             fontWeight: FontWeight.w700,
  //             fontFamily: "OpenSans",
  //           ),
  //         ),
  //         content: Container(
  //           height: 100,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               Text(
  //                 content,
  //                 softWrap: true,
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   color: Colors.black54,
  //                   decoration: TextDecoration.none,
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w300,
  //                   fontFamily: "OpenSans",
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 10.0),
  //                 child: CustomFlatButton(
  //                   title: "OK",
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w700,
  //                   textColor: Colors.black54,
  //                   onPressed: () {
  //                     // onPressed();
  //                     Navigator.of(context).pop();
  //                   },
  //                   splashColor: Colors.black12,
  //                   borderColor: Colors.black12,
  //                   borderWidth: 2,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         // content: Text(content),
  //         // title: Text(title),
  //         // actions: <Widget>[
  //         //   FlatButton(
  //         //     onPressed: (){
  //         //       _cloaseAlert();
  //         //     },
  //         //     child: Text("OK"),
  //         //   )
  //         // ],
  //       );
  //     },
  //   );
  // }
}