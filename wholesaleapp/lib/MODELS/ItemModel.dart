import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String weight;
  String volume;
  String uid;
  String type;
  String itemName;
  double cost;
  String description;
  int quantity;
  DateTime createdAT;
  List<String> imageUrls;

  ItemModel({
    this.weight = '',
    this.volume = '',
    this.uid = '',
    this.type = '',
    this.itemName = '',
    this.cost = 0.0,
    this.description = '',
    this.quantity = 0,
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
      weight: data['weight'] ?? '',
      uid: data['uid'] ?? '',
      volume: data['volume'] ?? '',
      type: data['type'] ?? '',
      itemName: data['itemName'] ?? '',
      cost: (data['cost'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      quantity: int.tryParse(data['quantity'].toString()) ?? 0,
      createdAT: createdAt,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'uid': uid,
      'type': type,
      'volume': volume,
      'itemName': itemName,
      'cost': cost,
      'description': description,
      'quantity': quantity,
      'createdAT': createdAT,
      'imageUrls': imageUrls,
    };
  }
}
