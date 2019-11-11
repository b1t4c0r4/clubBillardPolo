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
                itemBuilder: (buildContext, index) =>
                  //ProductCard(productDetails: products[index]),
                   Text(tournaments[index].name)
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

      //   builder: (BuildContext context, AsyncSnapshot<List<Tournamnet>> snapshot){
      //     // print("Name: "+ snapshot.data.first.name);
      //       if (!snapshot.hasData) {
      //         return Center(
      //           child: CircularProgressIndicator(
      //             valueColor: new AlwaysStoppedAnimation<Color>(
      //               Color.fromRGBO(212, 20, 15, 1.0),
      //             ),
      //           ),
      //         );
      //       }else{
      //         return Center(
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: <Widget>[
      //               LimitedBox(
      //                 maxHeight: 48,
      //                 child: Row(
      //                   children: [
      //                     AspectRatio(
      //                       aspectRatio: 1,
      //                       child: Container(
      //                         // color: item.color,
      //                       ),
      //                     ),
      //                     SizedBox(width: 24),
      //                     Expanded(
      //                       child: Text(snapshot.data[0].name, 
      //                         // style: textTheme
      //                       ),
      //                     ),
      //                     SizedBox(width: 24),
      //                     // _AddButton(item: item),
      //                   ],
      //                 ),
      //               ),

      //               // Text("Name: ${snapshot.data.firstName}"),
      //               // Text("Email: ${snapshot.data.email}"),
      //               // Text("UID: ${snapshot.data.userID}"),
      //             ],
      //           ),
      //         );
      //       }
      //   },
       ),



    );
  }

  // StreamBuilder<User> _body() {
  //   return StreamBuilder(
  //     stream: Auth.getUser(widget.firebaseUser.uid),
  //     builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
  //       if (!snapshot.hasData) {
  //         return Center(
  //           child: CircularProgressIndicator(
  //             valueColor: new AlwaysStoppedAnimation<Color>(
  //               Color.fromRGBO(212, 20, 15, 1.0),
  //             ),
  //           ),
  //         );
  //       } else {
  //         return Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               Container(
  //                 height: 100.0,
  //                 width: 100.0,
  //                 child: CircleAvatar(
  //                   backgroundImage: (snapshot.data.profilePictureURL != '')
  //                       ? NetworkImage(snapshot.data.profilePictureURL)
  //                       : AssetImage("assets/images/default.png"),
  //                 ),
  //               ),
  //               Text("Name: ${snapshot.data.firstName}"),
  //               Text("Email: ${snapshot.data.email}"),
  //               Text("UID: ${snapshot.data.userID}"),
  //             ],
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

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
