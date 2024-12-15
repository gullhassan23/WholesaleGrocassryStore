import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/ItemController.dart';
import 'package:wholesaleapp/screens/homeScreen/product_by_cat.dart';

class CategoriesScreen extends StatelessWidget {
  final ItemController itemController = Get.put(ItemController());
  final String image;
  final String dataCat;
  final String cat;

  CategoriesScreen({
    Key? key,
    this.image = '',
    this.dataCat = '',
    this.cat = '',
  }) : super(key: key);

  final List<Map<String, String>> categories = [
    {"image": "assets/images/4.png", "text": "Vegetables"},
    {"image": "assets/images/fruits.png", "text": "Fruits"},
    {"image": "assets/images/drinks.png", "text": "Beverages"},
    {"image": "assets/images/grocery.png", "text": "Grocery"},
    {"image": "assets/images/meat.png", "text": "Meat"},
    {"image": "assets/images/clean.png", "text": "Dairy-products"},
    {"image": "assets/images/frozen.png", "text": "Frozen"},
    {"image": "assets/images/dry.png", "text": "Dry-Fruits"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        centerTitle: true,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return InkWell(
            onTap: () {
              itemController.fetchProductsByCategory(category["text"]!);
              Get.to(() => ProductsByCategory(category: category["text"]!));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(category["image"]!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 140,
                    child: Text(
                      category["text"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
