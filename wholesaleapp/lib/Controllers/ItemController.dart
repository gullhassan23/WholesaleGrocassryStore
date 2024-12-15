import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/MODELS/ItemModel.dart';
import 'package:wholesaleapp/helper/cloudResources/CloudMethod.dart';

class ItemController extends GetxController {
  RxList<ItemModel> allItems = <ItemModel>[].obs;
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
        allItems.clear();
        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          print("Fetched Item Data: $data");
          ItemModel item = ItemModel.fromMap(data);
          allItems.add(item);
        }
        items.assignAll(allItems);
        print("Total products fetched: ${allItems.length}");
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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Items')
          .where('type', isEqualTo: category)
          .get();

      items.value = querySnapshot.docs.map((doc) {
        return ItemModel(
          weight: doc['weight'],
          createdAT: DateTime.now(),
          uid: doc.id,
          quantity: doc['quantity'],
          volume: doc['volume'],
          itemName: doc['itemName'],
          description: doc['description'],
          type: doc['type'],
          cost: doc['cost'].toDouble(),
          imageUrls: List<String>.from(doc['imageUrls']),
        );
      }).toList();
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void resetItems() {
    items.assignAll(allItems); // Reset to show all products
  }

  Future<String> productToFirestore({
    String volume = '',
    String weight = '',
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
          volume: volume,
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

  // Future<void> searchProduct(String query) async {
  //   if (query.isEmpty) {
  //     itemsSearch.clear();
  //   } else {
  //     itemsSearch.assignAll(allItems.where((product) =>
  //         product.itemName.toLowerCase().contains(query.toLowerCase())));
  //     print("Search results count: ${itemsSearch.length}");
  //   }
  //   update(['search']); // Ensure this matches the GetBuilder ID
  // }

  Future<void> searchProduct(RxString query) async {
    if (query.value.isEmpty) {
      itemsSearch.clear();
    } else {
      itemsSearch.value = allItems
          .where((product) => product.itemName
              .toLowerCase()
              .contains(query.value.toLowerCase()))
          .toList();
      print(" search ===> ${items.length}");
    }
    update(['search']);
  }

  Future<String> updateProductToFirestore({
    required String uid,
    required String productName,
    required String type,
    required String volume,
    required String rawCost,
    required int quantity,
    required String description,
    required String weight,
    List<Uint8List>? images,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('Items').doc(uid);

      Map<String, dynamic> updateData = {
        'itemName': productName,
        'type': type,
        'volume': volume,
        'cost': double.parse(rawCost),
        'quantity': quantity,
        'description': description,
        'weight': weight,
      };

      if (images != null && images.isNotEmpty) {
        List<String> imageUrls = await uploadImages(images);
        updateData['imageUrls'] = imageUrls;
      }

      await docRef.update(updateData);
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<String>> uploadImages(List<Uint8List> images) async {
    List<String> imageUrls = [];
    for (var image in images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child('product_images/$fileName');
      UploadTask uploadTask = ref.putData(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }
    return imageUrls;
  }
}
