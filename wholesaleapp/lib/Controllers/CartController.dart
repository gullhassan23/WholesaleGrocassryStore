import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/MODELS/CartModel.dart';
import 'package:wholesaleapp/MODELS/ItemModel.dart';
import 'package:wholesaleapp/helper/constant/images_resource.dart';

class CartController extends GetxController {
  var cartItems = <QueryDocumentSnapshot>[].obs;
  // RxList cartItems = <Cart>[].obs;
  var totalPrice = 0.0.obs;
  var totalPriceGst = 0.0.obs;
  var shippingAddress = ''.obs;
  RxString addTocartStatus = ''.obs;
  // CommonFunctions cMethod = CommonFunctions();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> clearCart() async {
    try {
      // Get the current user
      User currentUser = firebaseAuth.currentUser!;

      // Reference to the 'items' subcollection of the current user's cart
      CollectionReference cartItemsRef = FirebaseFirestore.instance
          .collection("Cart")
          .doc(currentUser.uid)
          .collection("items");

      // Fetch all documents in the 'items' subcollection
      QuerySnapshot cartSnapshot = await cartItemsRef.get();

      // Check if there are any items in the cart
      if (cartSnapshot.docs.isNotEmpty) {
        // Loop through each document and delete it
        for (var doc in cartSnapshot.docs) {
          await doc.reference.delete();
          print('Cart item deleted: ${doc.id}');
        }
        print('All cart items deleted from Firestore.');
      } else {
        print('No items found in the cart.');
      }

      // Clear local cart items and total price
      cartItems.clear();
      totalPrice.value = 0.0;
    } catch (e) {
      print("Failed to clear cart: ${e.toString()}");
    }
  }

  void updateShippingAddress(String address) {
    shippingAddress.value = address;
  }

  // Future<void> clearCart() async {
  //   try {
  //     User currentUser = firebaseAuth.currentUser!;
  //     DocumentReference cartDocRef = FirebaseFirestore.instance
  //         .collection("Cart")
  //         .doc(currentUser.uid)
  //         .collection("items").doc();

  //     // Check if the document exists before attempting to delete it
  //     DocumentSnapshot cartDocSnapshot = await cartDocRef.get();
  //     print("cart---> ${cartDocSnapshot.id.length}");
  //     if (cartDocSnapshot.exists) {
  //       // Delete the document (cart)
  //       await cartDocRef.delete();
  //       print('Cart document deleted from Firestore.');
  //     } else {
  //       print('Cart document does not exist.');
  //     }

  //     // Clear local cart items and total price
  //     cartItems.clear();
  //     totalPrice.value = 0.0;
  //   } catch (e) {
  //     print("Failed to clear cart: ${e.toString()}");
  //   }
  // }

  // Mock method to get product quantity from Firestore
  Future<int> getProductQuantity(String itemId) async {
    // Fetch product from Firestore using productId and get the available quantity
    DocumentSnapshot productDoc =
        await FirebaseFirestore.instance.collection('Items').doc(itemId).get();
    if (productDoc.exists) {
      return productDoc['quantity'];
    } else {
      return 0;
    }
  }

  Future<void> fetchCartItems() async {
    User currentUser = firebaseAuth.currentUser!;
    final snapshot = await firebaseFirestore
        .collection('Cart')
        .doc(currentUser.uid)
        .collection("items")
        .get();
    cartItems.value = snapshot.docs;
    calculateTotalPrice();
    calculatewithGST();
  }

  void calculateTotalPrice() {
    double total = 0.0;
    for (var cartItem in cartItems) {
      final itemData = cartItem.data() as Map<String, dynamic>;
      // final price = itemData['price'] ?? 0.0;
      // final quantity = itemData['quantity'] ?? 1;
      final double price = double.tryParse(itemData['cost'].toString()) ?? 0.0;
      final int quantity = int.tryParse(itemData['quantity'].toString()) ?? 0;
      total += price * quantity;
    }
    totalPrice.value = total;
  }

  // void calculatewithGST() {
  //   double sub = 0.0;
  //   if (totalPrice.value != 0.0) {
  //     sub += 10;
  //   }
  //   totalPriceGst.value = sub;
  //   print("subPrice ${totalPriceGst}");
  // }

  void calculatewithGST() {
    if (totalPrice.value > 0.0) {
      totalPriceGst.value = totalPrice.value + 10; // Adding 10% GST
    } else {
      totalPriceGst.value = 0.0;
    }
    print("Total Price with GST: ${totalPriceGst.value}");
  }

  void removeFromCart(String cartItemId) {
    User currentUser = firebaseAuth.currentUser!;
    firebaseFirestore
        .collection('Cart')
        .doc(currentUser.uid)
        .collection("items")
        .doc(cartItemId)
        .delete();
    fetchCartItems(); // Refresh the cart items after removing
  }

  void updateQuantity(String cartItemId, int quantity) {
    User currentUser = firebaseAuth.currentUser!;
    if (quantity > 0) {
      firebaseFirestore
          .collection('Cart')
          .doc(currentUser.uid)
          .collection("items")
          .doc(cartItemId)
          .update({'quantity': quantity});
      fetchCartItems(); // Refresh the cart items after updating
    } else {
      Get.snackbar("Quantity Message", "Quantity cannot be zero");
    }
  }

  Future<Map<String, dynamic>> getProductData(String itemId) async {
    DocumentSnapshot productSnapshot =
        await firebaseFirestore.collection('Cart').doc(itemId).get();

    return productSnapshot.exists
        ? productSnapshot.data() as Map<String, dynamic>
        : {};
  }

  Future<void> deleteCart(String cartItemId) async {
    User currentUser = firebaseAuth.currentUser!;
    firebaseFirestore
        .collection('Cart')
        .doc(currentUser.uid)
        .collection("items")
        .doc(cartItemId)
        .delete();
  }

  void incrementQuantity(int index) async {
    try {
      final document = cartItems[index]; // Get the Firestore document.
      final cartItemId = document.id; // Get the document ID.
      final data = document.data() as Map<String, dynamic>;

      int currentQuantity = data['quantity'] ?? 0; // Get the current quantity.
      currentQuantity++; // Increment the quantity.

      // Update the quantity in Firestore.
      await firebaseFirestore
          .collection('Cart')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('items')
          .doc(cartItemId)
          .update({'quantity': currentQuantity});

      fetchCartItems(); // Refresh the cart items after updating.
    } catch (e) {
      print('Error incrementing quantity: $e');
    }
  }

  void decrementQuantity(int index) async {
    try {
      final document = cartItems[index]; // Get the Firestore document.
      final cartItemId = document.id; // Get the document ID.
      final data = document.data() as Map<String, dynamic>;

      int currentQuantity = data['quantity'] ?? 0; // Get the current quantity.
      if (currentQuantity > 1) {
        currentQuantity--; // Decrement the quantity.

        // Update the quantity in Firestore.
        await firebaseFirestore
            .collection('Cart')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('items')
            .doc(cartItemId)
            .update({'quantity': currentQuantity});

        fetchCartItems(); // Refresh the cart items after updating.
      } else {
        // Show a snackbar if the quantity cannot be decremented further.
        Get.snackbar(
          'Error',
          'Quantity cannot be less than 1',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error decrementing quantity: $e');
    }
  }

  Future<void> addToCart(ItemModel itemModel) async {
    try {
      cartItems.clear();
      String uid = ImagesResource().getUid();
      User currentUser = firebaseAuth.currentUser!;
      CollectionReference cartCollection = firebaseFirestore
          .collection('Cart')
          .doc(currentUser.uid)
          .collection("items");

      DocumentReference itemDoc = cartCollection.doc(itemModel.uid);

      DocumentSnapshot itemSnapshot = await itemDoc.get();

      if (itemSnapshot.exists) {
        // If the product is already in the cart, update the quantity
        int currentQuantity = itemSnapshot.get('quantity');
        itemDoc.update({'quantity': currentQuantity + 1});
      } else {
        // If the product is not in the cart, add it using Cart model
        Cart cart = Cart(
          cid: uid,
          productImage: itemModel.imageUrls[0],
          // productImage: itemModel.imageUrls.isNotEmpty == true
          //     ? itemModel.imageUrls[0]
          //     : '',
          productName: itemModel.itemName,
          cost: itemModel.cost,
          productId: itemModel.uid,
          quantity: 1,
          orderedAt: DateTime.now(),
          uSerid: currentUser.uid,
        );

        await cartCollection.doc(itemModel.uid).set(cart.toMap());
      }

      addTocartStatus.value = "success";
      fetchCartItems(); // Refresh the cart items after adding
    } catch (e) {
      addTocartStatus.value = e.toString();
    }
  }
}
