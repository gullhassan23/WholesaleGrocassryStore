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
    {"image": "https://i.imgur.com/CGCyp1d.png", "text": "Vegetables"},
    {"image": "https://i.imgur.com/AkzWQuJ.png", "text": "Fruits"},
    {"image": "https://i.imgur.com/J7mGZ12.png", "text": "Beverages"},
    {"image": "https://i.imgur.com/q9oF9Yq.png", "text": "Grocery"},
    {"image": "https://i.imgur.com/CGCyp1d.png", "text": "Meat"},
    {"image": "https://i.imgur.com/AkzWQuJ.png", "text": "Clean"},
    {"image": "https://i.imgur.com/J7mGZ12.png", "text": "Frozen"},
    {"image": "https://i.imgur.com/q9oF9Yq.png", "text": "Dry-Fruits"},
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
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(category["image"]!),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  category["text"]!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
