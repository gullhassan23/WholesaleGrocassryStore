import 'package:cloud_firestore/cloud_firestore.dart';

class Pic {
  String id;
  String photoUrl;
  Pic({
    required this.photoUrl,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photoUrl': photoUrl,
    };
  }

  static Pic fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Pic(
      id: snapshot['id'],
      photoUrl: snapshot['photoUrl'],
    );
  }
}