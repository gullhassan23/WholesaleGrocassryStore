import 'package:flutter/material.dart';

import '../../MODELS/all_products_model.dart';
import '../../helper/constant/colors_resource.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<AllProductModel> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = majorList; // Initially, show all products
  }

  void _filterProducts(String query) {
    setState(() {
      filteredList = majorList
          .where((product) =>
              product.Name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  List<AllProductModel> majorList = [
    AllProductModel(
      image: "https://i.imgur.com/CGCyp1d.png",
      Name: "Apple",
      description: "Fresh and juicy red apples.",
      price: 3.99,
      weight: "1kg",
    ),
    AllProductModel(
      image: "https://i.imgur.com/AkzWQuJ.png",
      Name: "Banana",
      description: "Ripe bananas full of nutrients.",
      price: 1.49,
      weight: "1.5kg",
    ),
    AllProductModel(
      image: "https://i.imgur.com/J7mGZ12.png",
      Name: "Mango",
      description:
          "Sweet and tropical mango. Sweet and tropical mangoes. Sweet and tropical mangoes. Sweet and tropical mangoes. Sweet and tropical mangoes",
      price: 5.99,
      weight: "2kg",
    ),
    AllProductModel(
      image: "https://i.imgur.com/q9oF9Yq.png",
      Name: "Orange",
      description: "Citrus and vitamin-rich oranges.",
      price: 2.99,
      weight: "1.2kg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              child: TextField(
                controller: _searchController,
                onChanged: _filterProducts, // Filter list on text input
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
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final product = filteredList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5.0, // Adds shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                product.image,
                                width: 80,
                                height: 80,
                                fit: BoxFit.fill,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          product.Name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "\$${product.price.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          color: ColorsResource.PRIMARY_COLOR,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    product.description.length > 50
                                        ? "${product.description.substring(0, 50)}..."
                                        : product.description,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                // Navigate to detail screen
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ProductDetailScreen(product: product),
                                //   ),
                                // );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
