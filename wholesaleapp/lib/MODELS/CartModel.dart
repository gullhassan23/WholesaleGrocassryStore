import 'dart:convert';

class Cart {
  final String cid;
  final String productImage;
  final String productName;
  final double cost;
  final String productId;
  final int quantity;
  final DateTime orderedAt;
  final String uSerid;
  Cart({
    this.cid = '',
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
      'productImage': productImage,
      'productName': productName,
      'cost': cost,
      'productId': productId,
      'quantity': quantity,
      'orderedAt': orderedAt.millisecondsSinceEpoch,
      'uSerid': uSerid,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      cid: map['cid'] as String,
      productImage: map['productImage'] as String,
      productName: map['productName'] as String,
      cost: map['cost'] as double,
      productId: map['productId'] as String,
      quantity: map['quantity'] as int,
      orderedAt: DateTime.fromMillisecondsSinceEpoch(map['orderedAt'] as int),
      uSerid: map['uSerid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);
}
