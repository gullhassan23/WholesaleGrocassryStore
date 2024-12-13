import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  final String cid;
  final String productImage;
  final String productName;
  final String productDes;
  final double cost;
  final String productId;
  final int quantity;
  final DateTime orderedAt;
  final String uSerid;
  Cart({
    this.cid = '',
    this.productDes = '',
    this.productImage = '',
    this.productName = '',
    this.cost = 0.0,
    this.productId = '',
    this.quantity = 0,
    required this.orderedAt,
    this.uSerid = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cid': cid,
      'productDes': productDes,
      'productImage': productImage,
      'productName': productName,
      'cost': cost,
      'productId': productId,
      'quantity': quantity,
      'orderedAt': orderedAt,
      'uSerid': uSerid,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      productDes: map['productDes'] ?? '',
      cid: map['cid'] ?? '',
      productImage: map['productImage'] ?? '',
      productName: map['productName'] ?? '',
      cost: (map['cost'] ?? 0).toDouble(),
      productId: map['productId'] ?? '',
      quantity: int.tryParse(map['quantity'].toString()) ?? 0,
      orderedAt: map['orderedAt'] != null
          ? (map['orderedAt'] as Timestamp).toDate()
          : DateTime.now(),
      uSerid: map['uSerid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);
}
