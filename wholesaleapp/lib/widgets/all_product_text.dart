import 'package:flutter/material.dart';

import '../screens/homeScreen/all_products_screen.dart';

class AllProductText extends StatelessWidget {
  const AllProductText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllProductScreen()),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.grey.shade400,
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'All Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.grey.shade400,
              thickness: 1,
            ),
          ),
        ],
      ),
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Text(
      //       'All Products',
      //       style: TextStyle(
      //         fontSize: 20,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //     Icon(
      //       Icons.arrow_forward_ios_rounded,
      //       size: 20,
      //     ),
      //   ],
      // ),
    );
  }
}
