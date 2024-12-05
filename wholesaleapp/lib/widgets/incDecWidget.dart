import 'package:flutter/material.dart';

import '../helper/constant/colors_resource.dart';
import '../screens/homeScreen/cart_screen.dart';

class incDecWidget extends StatelessWidget {
  const incDecWidget({
    super.key,
    required this.cartController,
    required this.quantity,
    required this.index,
  });

  final CartController cartController;
  final int quantity;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => cartController.decrementQuantity(index),
          child: Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.remove,
              color: Colors.black,
              size: 18.0,
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Text(
          quantity.toString(),
        ),
        SizedBox(width: 10.0),
        InkWell(
          onTap: () => cartController.incrementQuantity(index),
          child: Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
              color: ColorsResource.PRIMARY_COLOR,
              shape: BoxShape.circle, // Circular shape
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 18.0, // Adjust icon size
            ),
          ),
        ),
      ],
    );
  }
}
