import 'package:cloud_firestore/cloud_firestore.dart';

class Round {

  final String player1;
  final String player2;
  final int p1Score;
  final int p2Score;
  final String winner;

  Round({
    this.player1,
    this.player2,
    this.p1Score,
    this.p2Score,
    this.winner
  });

  Map<String, Object> toJson() {
    return {
      'player1': player1,
      'player2': player2,
      'p1Score': p1Score,
      'p2Score': p2Score,
      'photoUrl': (p1Score > p2Score && p1Score != null) ? player1 : ( p2Score != null) ? player2 : '',      
    };
  }

  factory Round.fromJson(Map<String, Object> doc) {
    Round round = new Round(
      player1: doc['player1'],
      player2: doc['player2'],
      p1Score: doc['p1Score'],
      p2Score: doc['p2Score'],
      winner: doc['winner']      
    );
    return round;
  }

  factory Round.fromDocument(DocumentSnapshot doc) {
    return Round.fromJson(doc.data);
  }
}
