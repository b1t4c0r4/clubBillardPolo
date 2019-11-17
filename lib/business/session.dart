import 'package:firebase_auth/firebase_auth.dart';
import 'package:poloTournamnets/models/user.dart';

class Session {

  final String userId;
  final User user;
  // final String tournamnetId;
  final FirebaseUser firebaseUser;

  Session({
    this.userId,
    this.user,
    this.firebaseUser
  });
  
}