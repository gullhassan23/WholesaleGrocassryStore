import 'package:flutter/material.dart';

import '../../MODELS/product_model.dart';

class ProductScreen extends StatefulWidget {
  final ProductModel product;

  ProductScreen({required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    ProductModel product = widget.product;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'All Products',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Image.network(
            product.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 250,
          ),
          const SizedBox(height: 16),
          Text(
            product.productName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '\$ ${product.price.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20, color: Colors.green),
          ),
          const SizedBox(height: 16),
          Text(
            'Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
