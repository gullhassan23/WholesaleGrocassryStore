import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/ItemController.dart';
import 'package:wholesaleapp/MODELS/ItemModel.dart';
import 'package:wholesaleapp/screens/homeScreen/product_screen.dart';

import '../../helper/constant/colors_resource.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ItemController itemController = Get.find<ItemController>();
  List<ItemModel> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = itemController.allItems;
    _searchController.addListener(() {
      _filterProducts(_searchController.text);
    });
    print(filteredList.length);
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = itemController.allItems;
      } else {
        filteredList = itemController.allItems
            .where((product) =>
                (product.itemName.toLowerCase()).contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  // List<ProductModel> majorList = [
  //   ProductModel(
  //       image: "https://i.imgur.com/CGCyp1d.png",
  //       price: 650.62,
  //       productName: 'Orange',
  //       qty: '10 pieces',
  //       weight: '100lb',
  //       description:
  //           'This product is crafted with premium quality materials, offering durability and elegance. Perfect for everyday use or special occasions, it combines functionality with style to enhance your experience effortlessly.'),
  //   ProductModel(
  //       image: "https://i.imgur.com/AkzWQuJ.png",
  //       price: 1264,
  //       productName: 'Chicken',
  //       qty: '25 pieces',
  //       weight: '100lb',
  //       description:
  //           'This product is crafted with premium quality materials, offering durability and elegance. Perfect for everyday use or special occasions, it combines functionality with style to enhance your experience effortlessly.'),
  //   ProductModel(
  //       image: "https://i.imgur.com/J7mGZ12.png",
  //       price: 650.62,
  //       productName: 'Orange',
  //       qty: '11 pieces',
  //       weight: '100lb',
  //       description:
  //           'This product is crafted with premium quality materials, offering durability and elegance. Perfect for everyday use or special occasions, it combines functionality with style to enhance your experience effortlessly.'),
  //   ProductModel(
  //       image: "https://i.imgur.com/q9oF9Yq.png",
  //       price: 1264,
  //       productName: 'Chicken',
  //       qty: '100lb',
  //       description:
  //           'This product is crafted with premium quality materials, offering durability and elegance. Perfect for everyday use or special occasions, it combines functionality with style to enhance your experience effortlessly.'),
  //   ProductModel(
  //       image: "https://i.imgur.com/CGCyp1d.png",
  //       price: 650.62,
  //       productName: 'Orange',
  //       qty: '10 pieces',
  //       weight: '100lb',
  //       description:
  //           'This product is crafted with premium quality materials, offering durability and elegance. Perfect for everyday use or special occasions, it combines functionality with style to enhance your experience effortlessly.'),
  //   ProductModel(
  //       image: "https://i.imgur.com/AkzWQuJ.png",
  //       price: 1264,
  //       productName: 'Chicken',
  //       qty: '25 pieces',
  //       weight: '100lb',
  //       description:
  //           'This product is crafted with premium quality materials, offering durability and elegance. Perfect for everyday use or special occasions, it combines functionality with style to enhance your experience effortlessly.'),
  //   ProductModel(
  //       image: "https://i.imgur.com/J7mGZ12.png",
  //       price: 650.62,
  //       productName: 'Orange',
  //       qty: '11 pieces',
  //       weight: '100lb',
  //       description:
  //           'This product is crafted with premium quality materials, offering durability and elegance. Perfect for everyday use or special occasions, it combines functionality with style to enhance your experience effortlessly.'),
  //   ProductModel(
  //       image: "https://i.imgur.com/q9oF9Yq.png",
  //       price: 1264,
  //       productName: 'Chicken',
  //       qty: '100lb',
  //       description:
  //           'This product is crafted with premium quality materials, offering durability and elegance. Perfect for everyday use or special occasions, it combines functionality with style to enhance your experience effortlessly.'),
  // ];

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
        body: Obx(() {
          if (itemController.allItems.isEmpty) {
            return Center(child: Text("NO products"));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterProducts,
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
                    child: filteredList.isEmpty
                        ? Center(
                            child: Text(
                              "No products found",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              // final product = filteredList[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductScreen(
                                                itemModel: item,
                                              )),
                                    );
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 5.0, // Adds shadow
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              item.imageUrls[0],
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.fill,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
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
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Icon(Icons.error,
                                                      color: Colors.red),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                        item.itemName,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "\$${item.cost.toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                        color: ColorsResource
                                                            .PRIMARY_COLOR,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5.0),
                                                Text(
                                                  (item.description.length) > 50
                                                      ? "${item.description.substring(0, 50)}..."
                                                      : (item.description),
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.arrow_forward_ios),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }
        }));
  }
}
