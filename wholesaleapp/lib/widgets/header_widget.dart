import 'package:flutter/material.dart';

import '../helper/constant/colors_resource.dart';
import '../screens/homeScreen/cart_screen.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .82,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Product',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  prefixIcon: Icon(
                    Icons.search,
                    color: ColorsResource.PRIMARY_COLOR,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorsResource.PRIMARY_COLOR,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorsResource.PRIMARY_COLOR,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
              icon: Icon(Icons.shopping_cart),
            )
          ],
        ),
        SizedBox(
          height: 7,
        ),
      ],
    );
  }
}
