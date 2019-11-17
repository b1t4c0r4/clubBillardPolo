import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userID;
  final String firstName;
  final String email;
  final String profilePictureURL;
  final bool isAdmin;

  User({
    this.userID,
    this.firstName,
    this.email,
    this.profilePictureURL,
    this.isAdmin
  });

  Map<String, Object> toJson() {
    return {
      'userID': userID,
      'firstName': firstName,
      'email': email == null ? '' : email,
      'profilePictureURL': profilePictureURL,
      'isAdmin': isAdmin == null ? false : isAdmin,
      'appIdentifier': 'clubBiilardPolo'
    };
  }

  factory User.fromJson(Map<String, Object> doc) {
    User user = new User(
      userID: doc['userID'],
      firstName: doc['firstName'],
      email: doc['email'],
      isAdmin: (doc['isAdmin'] == null) ? false : doc['isAdmin'],
      profilePictureURL: doc['profilePictureURL'],
    );
    return user;
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}
