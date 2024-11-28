import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/ItemController.dart';
import 'package:wholesaleapp/screens/Admin/EditScreen.dart';
import 'package:wholesaleapp/widgets/TextForm.dart';

class StockScreen extends StatefulWidget {
  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  void searchProduct(String value) {
    itemController.searchProduct(value.obs);
  }

  final ItemController itemController = Get.put(ItemController());

  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdcf3ff),
      appBar: AppBar(
          backgroundColor: Color(0xffdcf3ff),
          centerTitle: true,
          title: Text("Stock Screen")),
      body: Column(
        children: [
          TextForm(
            onChanged: (value) {
              searchProduct(value);
            },
            icon: Icon(
              Icons.search,
              size: 23.sp,
            ),
            textEditingController: search,
            hintText: "Search Product",
            textInputType: TextInputType.name,
          ),
          SizedBox(height: 20.h),
          GetBuilder<ItemController>(
            id: 'search',
            builder: (productController) {
              if (search.text.isEmpty) {
                return SizedBox.shrink();
              } else if (itemController.itemsSearch.isEmpty) {
                return Center(child: Text('No products found'));
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16),
                  itemCount: itemController.itemsSearch.length,
                  itemBuilder: (ctx, index) {
                    final product = itemController.itemsSearch[index];
                    return Text(product.itemName);
                  },
                );
              }
            },
          ),
          Obx(() {
            final products = itemController.query.isEmpty
                ? itemController.items
                : itemController.itemsSearch;

            if (products.isEmpty) {
              return Center(child: Text('No products found.'));
            }

            return Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];
                  return Dismissible(
                    key: Key(item.uid),
                    direction:
                        DismissDirection.endToStart, // Swipe right to left
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

                      // Update local list
                      itemController.items.removeAt(index);

                      // Show a snackbar or any feedback
                      Get.snackbar(
                        'Deleted',
                        'Product deleted successfully',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: Card(
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
                            trailing: Text('Qty: ${item.quantity}'),
                          ),
                          Positioned(
                            bottom: 44,
                            left: 349,
                            child: IconButton(
                                onPressed: () {
                                  Get.to(
                                      () => EditProductScreen(product: item));
                                },
                                icon: Icon(
                                  Icons.edit,
                                  size: 15.sp,
                                )),
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
