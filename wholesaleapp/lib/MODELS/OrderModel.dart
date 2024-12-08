import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String pid;

  final String cartIID;
  final String productName;
  final String productImage;
  DateTime orderDate;
  final int quantity;
  final double price;
  final String userid;
  final String shippingAddress;
  final String userName;
  final double totalBIll;
  String status;

  OrderModel({
    this.pid = '',
    this.shippingAddress = '',
    this.cartIID = '',
    this.productName = '',
    this.productImage = '',
    required this.orderDate,
    this.quantity = 0,
    this.price = 0.0,
    this.userid = '',
    this.userName = '',
    this.totalBIll = 0.0,
    this.status = 'Pending',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pid': pid,
      'shippingAddress': shippingAddress,
      'cartIID': cartIID,
      'productName': productName,
      'productImage': productImage,
      'orderDate': orderDate,
      'quantity': quantity,
      'price': price,
      'userid': userid,
      'userName': userName,
      'totalBIll': totalBIll,
      'status': status,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderDate: map['orderDate'] != null
          ? (map['orderDate'] as Timestamp).toDate()
          : DateTime.now(),
      shippingAddress: map['shippingAddress'] ?? '',
      pid: map['pid'] ?? '',
      cartIID: map['cartIID'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      quantity: int.tryParse(map['quantity'].toString()) ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      userid: map['userid'] ?? '',
      userName: map['userName'] ?? '',
      totalBIll: (map['totalBIll'] ?? 0).toDouble(),
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
