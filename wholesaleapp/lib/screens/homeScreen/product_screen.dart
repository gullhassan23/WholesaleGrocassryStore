// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wholesaleapp/MODELS/ItemModel.dart';
import 'package:wholesaleapp/helper/constant/colors_resource.dart';

import '../../MODELS/product_model.dart';
import '../../widgets/circular_icon_btn.dart';
import 'cart_screen.dart';

class ProductScreen extends StatefulWidget {
  final ItemModel itemModel;
  const ProductScreen({
    Key? key,
    required this.itemModel,
  }) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    // ProductModel product = widget.product;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Image.network(
                "https://i.imgur.com/CGCyp1d.png",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  widget.itemModel.itemName,
                  // product.productName ?? '',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Container(
                  height: 40.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red,
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Available in stock',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$ ${widget.itemModel.cost.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.itemModel.quantity} ${widget.itemModel.weight}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.itemModel.description,
              // product.description ?? '',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blueGrey,
                  width: 1, // Border width
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Quantity',
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  CircularButton(
                    icon: Icons.add,
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                  SizedBox(
                    width: 50,
                    height: 20,
                    child: Center(
                      child: Text(
                        quantity.toString(),
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                  CircularButton(
                    icon: Icons.remove,
                    onPressed: () {
                      setState(() {
                        if (quantity > 0) {
                          quantity--;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: BorderSide(color: ColorsResource.PRIMARY_COLOR),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
                child: Text(
                  'Add to cart',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ), // Optional content
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
