import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/CartController.dart';
import 'package:wholesaleapp/helper/constant/colors_resource.dart';
import 'package:wholesaleapp/screens/homeScreen/cart_screen.dart';

import '../Controllers/ItemController.dart';

class Header extends StatefulWidget {
  const Header({
    super.key,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final search = TextEditingController();
  final ItemController itemController = Get.put(ItemController());
  final CartController cartController = Get.put(CartController());

  void searchProductt(String value) {
    itemController.searchProduct(value.obs);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .82,
              child: TextFormField(
                controller: search,
                onChanged: (value) {
                  searchProductt(value);
                },
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
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartScreen()),
                    );
                  },
                  icon: Icon(Icons.shopping_cart),
                ),
                if (cartController.cartItems.isNotEmpty)
                  Obx(() {
                    return Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cartController.cartItems.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  })
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

//
// class Header extends StatefulWidget {
//   const Header({
//     super.key,
//   });
//
//   @override
//   State<Header> createState() => _HeaderState();
// }
//
// class _HeaderState extends State<Header> {
//   final search = TextEditingController();
//   final ItemController itemController = Get.put(ItemController());
//   final CartController cartController = Get.put(CartController());
//
//   void searchProductt(String value) {
//     itemController.searchProduct(value.obs);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width * .82,
//               child: TextFormField(
//                 onChanged: (value) {
//                   searchProductt(value);
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Search Product',
//                   contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                   prefixIcon: Icon(
//                     Icons.search,
//                     color: ColorsResource.PRIMARY_COLOR,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: ColorsResource.PRIMARY_COLOR,
//                       width: 1.0,
//                     ),
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: ColorsResource.PRIMARY_COLOR,
//                       width: 1.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//             ),
//             Stack(
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => CartScreen()),
//                     );
//                   },
//                   icon: Icon(Icons.shopping_cart),
//                 ),
//                 if (cartController.cartItems.isNotEmpty)
//                   Obx(() {
//                     return Positioned(
//                       right: 4,
//                       top: 4,
//                       child: Container(
//                         padding: EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                           color: Colors.red,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Text(
//                           '${cartController.cartItems.length}',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     );
//                   })
//               ],
//             )
//           ],
//         ),
//         SizedBox(
//           height: 2,
//         ),
//         GetBuilder<ItemController>(
//           id: 'search',
//           builder: (productController) {
//             if (search.text.isEmpty) {
//               return SizedBox.shrink();
//             } else if (productController.itemsSearch.isEmpty) {
//               return Center(child: Text('No products found'));
//             } else {
//               return ListView.builder(
//                 padding: EdgeInsets.all(16),
//                 itemCount: productController.itemsSearch.length,
//                 itemBuilder: (ctx, index) {
//                   final product = productController.itemsSearch[index];
//                   return AllProductsCard(itemModel: product);
//                 },
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
