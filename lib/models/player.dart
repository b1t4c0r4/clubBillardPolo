import 'package:cloud_firestore/cloud_firestore.dart';

class Player {

  final String userId;
  final String nickname;
  final String photoUrl;

  Player({
    this.userId,
    this.nickname,
    this.photoUrl
  });

  Map<String, Object> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'photoUrl': photoUrl == null ? '' : photoUrl,      
    };
  }

  factory Player.fromJson(Map<String, Object> doc) {
    Player player = new Player(
      userId: doc['userId'],
      nickname: doc['nickname'],
      photoUrl: doc['photoUrl']      
    );
    return player;
  }

  factory Player.fromDocument(DocumentSnapshot doc) {
    return Player.fromJson(doc.data);
  }
}
