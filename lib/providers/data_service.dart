import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FBCollection {

  static const _tournamnets = 'tournaments';
  static const _players = 'players';
}

class DataService extends ChangeNotifier {

  final Firestore _db = Firestore.instance;

  Stream<QuerySnapshot> streamFetchTorunaments() {
    return _db.collection(FBCollection._tournamnets).snapshots();  
  }

  Stream<QuerySnapshot> streamFetchPlayerByTorunamnetId(String torunamentId) {
    return _db.collection(FBCollection._tournamnets+'/$torunamentId/'+FBCollection._players).snapshots();
  }  

}