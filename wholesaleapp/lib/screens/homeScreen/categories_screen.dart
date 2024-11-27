import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Map<String, String>> items = [
    {"text": "Fruits", "image": "https://i.imgur.com/CGCyp1d.png"},
    {"text": "Vegetables", "image": "https://i.imgur.com/AkzWQuJ.png"},
    {"text": "Groceries", "image": "https://i.imgur.com/J7mGZ12.png"},
    {"text": "Meat", "image": "https://i.imgur.com/q9oF9Yq.png"},
    {"text": "Cleaner", "image": "https://i.imgur.com/CGCyp1d.png"},
    {"text": "Beverages", "image": "https://i.imgur.com/AkzWQuJ.png"},
    {"text": "Dry Fruits", "image": "https://i.imgur.com/J7mGZ12.png"},
    {"text": "Frozen", "image": "https://i.imgur.com/q9oF9Yq.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Categories',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          backgroundColor: Colors.white,
          toolbarHeight: 40,
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return InkWell(
              onTap: () {
                // perform navigation
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(item["image"]!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item["text"]!,
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
        ));
  }
}
