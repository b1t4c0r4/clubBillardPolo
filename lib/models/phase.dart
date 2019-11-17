import 'package:cloud_firestore/cloud_firestore.dart';

class Phase {

  final String id;
  final String name;

  Phase ({
    this.id,
    this.name
  });

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name      
    };
  }

  factory Phase.fromJson(Map<String, Object> doc) {
    Phase phase = new Phase(
      id: doc['id'],
      name: doc['name']      
    );
    return phase;
  }

  factory Phase.fromDocument(DocumentSnapshot doc) {
    return Phase.fromJson(doc.data);
  }
}
