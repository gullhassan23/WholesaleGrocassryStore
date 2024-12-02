import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String weight;
  String uid;
  String type;
  String itemName;
  double cost;
  String description;
  String quantity;
  DateTime createdAT;
  List<String> imageUrls;

  ItemModel({
    this.weight = '',
    this.uid = '',
    this.type = '',
    this.itemName = '',
    this.cost = 0.0,
    this.description = '',
    this.quantity = '',
    required this.createdAT,
    this.imageUrls = const [],
  });

  factory ItemModel.fromMap(Map<String, dynamic> data) {
    // Handle createdAT field as either a Timestamp or an int
    DateTime createdAt;
    if (data['createdAT'] is Timestamp) {
      createdAt = (data['createdAT'] as Timestamp).toDate();
    } else if (data['createdAT'] is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(data['createdAT']);
    } else {
      createdAt = DateTime.now(); // Default value if neither type is matched
    }

    return ItemModel(
      uid: data['uid'] ?? '',
      weight: data['weight'] ?? '',
      type: data['type'] ?? '',
      itemName: data['itemName'] ?? '',
      cost: (data['cost'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      quantity: data['quantity'] ?? '',
      createdAT: createdAt,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'type': type,
      'weight': weight,
      'itemName': itemName,
      'cost': cost,
      'description': description,
      'quantity': quantity,
      'createdAT': createdAT,
      'imageUrls': imageUrls,
    };
  }
}
