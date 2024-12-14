import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/ItemController.dart';
import 'package:wholesaleapp/MODELS/ItemModel.dart';
import 'package:wholesaleapp/screens/Admin/EditProduct.dart';
import 'package:wholesaleapp/widgets/TextForm.dart';

class StockScreen extends StatefulWidget {
  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  List<ItemModel> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = itemController.allItems;
    search.addListener(() {
      _filterProducts(search.text);
    });
    print("-----> ${filteredList.length}");
    // Initially, show all products
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        // Show all products if search query is empty.
        filteredList = itemController.items;
      } else {
        // Filter products based on the search query.
        filteredList = itemController.items
            .where((product) =>
                (product.itemName.toLowerCase()).contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  // void searchProduct(String value) {
  //   itemController.searchProduct(value.obs);
  // }

  final ItemController itemController = Get.put(ItemController());

  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        centerTitle: true,
        title: Text("Stock Screen"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextForm(
              onChanged: _filterProducts,
              icon: Icon(
                Icons.search,
                size: 23.sp,
              ),
              textEditingController: search,
              hintText: "Search Product",
              textInputType: TextInputType.name,
            ),
          ),
          SizedBox(height: 20.h),
          // GetBuilder<ItemController>(
          //   id: 'search',
          //   builder: (productController) {
          //     if (search.text.isEmpty) {
          //       return SizedBox.shrink();
          //     } else if (itemController.itemsSearch.isEmpty) {
          //       return Center(child: Text('No products found'));
          //     } else {
          //       return ListView.builder(
          //         shrinkWrap: true,
          //         padding: EdgeInsets.all(16),
          //         itemCount: filteredList.length,
          //         itemBuilder: (ctx, index) {
          // final product = filteredList[index];
          //           return Text(product.itemName);
          //         },
          //       );
          //     }
          //   },
          // ),
          Obx(() {
            final products = itemController.query.isEmpty
                ? itemController.items
                : itemController.itemsSearch;

            if (products.isEmpty) {
              return Center(child: Text('No products found.'));
            }

            return Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final item = filteredList[index];
                  return Dismissible(
                    key: Key(item.uid),
                    direction: DismissDirection.endToStart,
                    // Swipe right to left
                    background: Container(
                      color: Colors.red, // Background color when swiping
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) async {
                      // Remove from Firestore
                      await FirebaseFirestore.instance
                          .collection('Items')
                          .doc(item.uid)
                          .delete();

                      setState(() {
                        // Update the local filtered list
                        filteredList.removeAt(index);

                        // Optionally update the main list
                        itemController.items
                            .removeWhere((i) => i.uid == item.uid);
                      });

                      // Show a snackbar or any feedback
                      Get.snackbar(
                        'Deleted',
                        'Product deleted successfully',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    // onDismissed: (direction) async {
                    //   // Remove from Firestore
                    //   await FirebaseFirestore.instance
                    //       .collection('Items')
                    //       .doc(item.uid)
                    //       .delete();

                    //   // Update local list
                    //   itemController.items.removeAt(index);

                    //   // Show a snackbar or any feedback
                    //   Get.snackbar(
                    //     'Deleted',
                    //     'Product deleted successfully',
                    //     snackPosition: SnackPosition.BOTTOM,
                    //   );
                    // },
                    child: Card(
                      elevation: 5.0, // Adds shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          ListTile(
                            leading: item.imageUrls.isNotEmpty
                                ? Image.network(
                                    item.imageUrls[
                                        0], // Use single image URL here
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.image_not_supported);
                                    },
                                  )
                                : Icon(Icons.image_not_supported),
                            title: Text(item.itemName),
                            subtitle: Text(
                                'Type: ${item.type}\nCost: \$${item.cost}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(
                                        () => EditProductScreen(product: item));
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    size: 15.sp,
                                  ),
                                ),
                                Text('Qty: ${item.quantity}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
