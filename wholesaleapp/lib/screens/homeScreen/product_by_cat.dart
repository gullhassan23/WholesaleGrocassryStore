import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/ItemController.dart';
import 'package:wholesaleapp/widgets/all_products_card.dart';

class ProductsByCategory extends StatefulWidget {
  final String category;

  ProductsByCategory({required this.category});

  @override
  State<ProductsByCategory> createState() => _ProductsByCategoryState();
}

class _ProductsByCategoryState extends State<ProductsByCategory> {
  ItemController itemController = ItemController();

  @override
  void initState() {
    itemController = Get.find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
          ),
        ),
        title: Text(
          '${widget.category}',
          style: TextStyle(
            color: Color(0xFF0a0d2c),
          ),
        ),
      ),
      body: Obx(() {
        if (itemController.items.isEmpty) {
          return Center(child: Text("No products"));
        } else {
          return GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            itemCount: itemController.items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 7.0,
              mainAxisSpacing: 7.0,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final product = itemController.items[index];
              return Container(child: AllProductsCard(itemModel: product));
            },
          );
        }
      }),
    );
  }
}
