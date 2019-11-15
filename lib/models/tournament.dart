import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:poloTournamnets/models/player.dart';

class Tournamnet {

  final String id;
  final String name;
  final Timestamp date;
  final int tplayers;
  // final List<Player> players;

  Tournamnet({
    this.id,
    this.name,
    this.date,
    this.tplayers
    // this.players
  });

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date == null ? '' : date,
      'tplayers': tplayers
      // 'players': players
    };
  }

  factory Tournamnet.fromJson(Map<String, Object> doc) {
    Tournamnet torunament = new Tournamnet(
      id: doc['id'],
      name: doc['name'],
      date: doc['date'],
      tplayers: doc['tplayers'],
      // players: doc['players'],
    );
    return torunament;
  }

  factory Tournamnet.fromDocument(DocumentSnapshot doc) {
    return Tournamnet.fromJson(doc.data);
  }

  Tournamnet.fromMap(Map snapshot,String id) :
        id = id ?? '',
        name = snapshot['name'] ?? '',
        date = snapshot['date'] ?? '',
        // players = snapshot['players'] ?? List<Player>(),
        tplayers = snapshot['tplayers'] ?? 0;


}
