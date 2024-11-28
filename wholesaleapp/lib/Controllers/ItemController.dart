import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/MODELS/ItemModel.dart';
import 'package:wholesaleapp/helper/cloudResources/CloudMethod.dart';

class ItemController extends GetxController {
  RxList<ItemModel> items = <ItemModel>[].obs;
  RxList<ItemModel> itemsSearch = <ItemModel>[].obs;
  RxString addToDBStatus = ''.obs;
  RxString query = ''.obs;
  RxString id = ''.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProductData();
      findById(id);
      searchProduct(query); // Ensure this is an RxString
    });
  }

  ItemModel findById(id) {
    return items.firstWhere((product) => product.uid == id,
        orElse: () => ItemModel(createdAT: DateTime.now()));
  }

  Future<void> fetchProductData() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Items').get();
      if (snapshot.docs.isNotEmpty) {
        items.clear();
        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          ItemModel item = ItemModel.fromMap(data);
          items.add(item);
        }
        print("Products fetched successfully: ${items.length}");
      } else {
        print("No products found in the database.");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print("Error fetching product data: $e");
    }
  }

  void fetchProductsByCategory(String category) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Items')
          .where('type', isEqualTo: category)
          .get();

      items.value = querySnapshot.docs.map((doc) {
        return ItemModel(
          createdAT: DateTime.now(),
          uid: doc.id,
          itemName: doc['productName'],
          type: doc['type'],
          cost: doc['cost'].toDouble(),
          imageUrls: List<String>.from(doc['imageUrls']),
        );
      }).toList();
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<String> productToFirestore({
    String weight='',
    String type = '',
    String quantity = '',
    required String productName,
    required String rawCost,
    required String description,
    required List<Uint8List> images,
  }) async {
    try {
      // Parse quantity and check for errors

      try {} catch (e) {
        addToDBStatus.value = "Invalid quantity: must be an integer.";
        return "Invalid quantity: must be an integer.";
      }

      // Upload product to the database
      String status = await cloud().uploadProductToDatabase(
        weight: weight,
          quantity: quantity,
          productName: productName,
          description: description,
          rawCost: rawCost,
          type: type,
          imageFiles: images);

      // Update status based on the result
      if (status == "success") {
        addToDBStatus.value = "Product added to cart successfully";
        fetchProductData(); // Refresh the cart items after adding
      } else {
        addToDBStatus.value = status;
      }
      return status;
    } catch (e) {
      // Log and return the error
      addToDBStatus.value = "Error: ${e.toString()}";
      return "Error: ${e.toString()}";
    }
  }

  Future<void> searchProduct(RxString query) async {
    if (query.value.isEmpty) {
      itemsSearch.clear();
    } else {
      itemsSearch.value = items
          .where((product) => product.itemName
              .toLowerCase()
              .contains(query.value.toLowerCase()))
          .toList();
    }
    update(['search']);
  }

  Future<String> updateProductToFirestore({
    required String uid,
    required String productName,
    required String type,
    required String rawCost,
    required String quantity,
    required String description,
    List<Uint8List>? images,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'itemName': productName,
        'type': type,
        'cost': double.parse(rawCost),
        'quantity': quantity,
        'description': description,
      };

      // if (images != null && images.isNotEmpty) {
      //   List<String> imageUrls = await cloud().uploadImage(images);
      //   updateData['imageUrls'] = imageUrls;
      // }

      await FirebaseFirestore.instance
          .collection('Items')
          .doc(uid)
          .update(updateData);
      fetchProductData(); // Refresh items
      return "success";
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }
}
