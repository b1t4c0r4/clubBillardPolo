import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poloTournamnets/business/api_firebase.dart';
import 'package:poloTournamnets/locator.dart';
import 'package:poloTournamnets/models/tournament.dart';

class TorunamentProvider extends ChangeNotifier {

  ApiFirebase _api = locator<ApiFirebase>();

  List<Tournamnet> tournaments;

  Future<List<Tournamnet>> fetchTorunaments() async {
    var result = await _api.getDataCollection();
    tournaments = result.documents
        .map((doc) => Tournamnet.fromMap(doc.data, doc.documentID))
        .toList();
    return tournaments;
  }

  Stream<QuerySnapshot> fetchTorunamentsAsStream() {
    return _api.streamDataCollection();
  }

  Future<Tournamnet> getTournamnetById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Tournamnet.fromDocument(doc) ;
  }

  Future removeTorunament(String id) async{
     await _api.removeDocument(id) ;
     return ;
  }
  Future updateTorunament(Tournamnet data,String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addTorunament(Tournamnet data) async{
    var result  = await _api.addDocument(data.toJson()) ;

    return result != null ? true : false;
  }


  // static Stream<List<Tournamnet>> getTorunaments() {
  //   return Firestore.instance
  //       .collection("tournaments")
  //       // .where("userID", isEqualTo: userID)
  //       .snapshots()
  //       .map((QuerySnapshot snapshot) {
  //         return snapshot.documents.map((doc) {
  //           return Tournamnet.fromDocument(doc);
  //         }).toList();
  //       });
  // }

  // Stream<List<Tournamnet>> getAllTorunamnets() {
  //   return _api.streamDataCollection().map((QuerySnapshot snapshot) {
  //     return snapshot.documents.map((doc) {
  //       return Tournamnet.fromDocument(doc);
  //       }).toList();
  //      });
  // }

  // Future<List<Tournamnet>> getAllTorunamnets() async {
  //   var result = await _api.getDataCollection();
  //   tournaments = result.documents
  //       .map((doc) => Tournamnet.fromDocument(doc))
  //       .toList();
  //   return tournaments;
  // }

}