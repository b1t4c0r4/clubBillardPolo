import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poloTournamnets/models/phase.dart';
import 'package:poloTournamnets/models/player.dart';
// import 'package:poloTournamnets/models/user.dart';

class FBCollection {

  static const _tournamnets = 'tournaments';
  static const _players = 'players';
  static const _phases = 'phases';
}

class DataService extends ChangeNotifier {

  final Firestore _db = Firestore.instance;

  Stream<QuerySnapshot> streamFetchTorunaments() {
    return _db.collection(FBCollection._tournamnets).snapshots();  
  }

  Stream<QuerySnapshot> streamFetchPlayerByTorunamnetId(String torunamentId) {
    return _db.collection(FBCollection._tournamnets+'/$torunamentId/'+FBCollection._players).snapshots();
  }  

  Future<void> registerPlayerInTournamnet(String tournamentId, Player player) async {
    var _set = await _db
      .collection(FBCollection._tournamnets+'/$tournamentId/'+FBCollection._players)
      .document(player.userId)
      .setData(player.toJson());
     return _set;
  }

  Future<void> removePlayerInTournamnet(String tournamentId, String userId) async {
    var _set = await _db
      .collection(FBCollection._tournamnets+'/$tournamentId/'+FBCollection._players)
      .document(userId)
      .delete();
     return _set;
  }

  Stream<QuerySnapshot> streamFetchPhasesByTorunamnetId(String torunamentId) {
    return _db.collection(FBCollection._tournamnets+'/$torunamentId/'+FBCollection._phases).orderBy('id', descending: true).snapshots();
  }

  Future<void> addPhaseInTournamnet(String tournamentId, Phase phase) async {
    var _set = await _db
      .collection(FBCollection._tournamnets+'/$tournamentId/'+FBCollection._phases)
      .document(phase.id)
      .setData(phase.toJson());
     return _set;
  }
}