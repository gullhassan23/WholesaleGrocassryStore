import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// CartController to manage state
class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;

  // Add item to cart
  void addToCart(Map<String, dynamic> item) {
    cartItems.add(item);
  }

  // Remove item from cart
  void removeFromCart(int index) {
    cartItems.removeAt(index);
  }

  // Increment quantity
  void incrementQuantity(int index) {
    cartItems[index]['quantity']++;
    cartItems.refresh();
  }

  // Decrement quantity
  void decrementQuantity(int index) {
    if (cartItems[index]['quantity'] > 1) {
      cartItems[index]['quantity']--;
      cartItems.refresh();
    } else {
      Get.snackbar('Error', 'Quantity cannot be less than 1');
    }
  }

  // Get total amount
  double getTotalAmount() {
    return cartItems.fold(0.0, (sum, item) {
      return sum + (item['quantity'] * item['cost']);
    });
  }
}

// Main Application
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: CartScreen(),
    );
  }
}

// CartScreen with GetX
class CartScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  final int quantity = item['quantity'];
                  final double price = item['cost'];
                  final double totalPriceForItem = price * quantity;

                  return Card(
                    color: Colors.brown,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.error,
                                    color: Colors.white,
                                  ),
                                  imageUrl: item['imageUrls'][0],
                                  height: 100.0,
                                  width: 100.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['productName'],
                                    style: GoogleFonts.fredoka(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () => cartController
                                            .decrementQuantity(index),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        quantity.toString(),
                                        style: GoogleFonts.fredoka(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      InkWell(
                                        onTap: () => cartController
                                            .incrementQuantity(index),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$ ${totalPriceForItem.toStringAsFixed(2)}',
                                style: GoogleFonts.fredoka(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              InkWell(
                                onTap: () =>
                                    cartController.removeFromCart(index),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Total Amount Widget
          Obx(
            () => Container(
              color: Colors.grey[900],
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Total Amount: \$ ${cartController.getTotalAmount().toStringAsFixed(2)}',
                style: GoogleFonts.fredoka(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cartController.addToCart({
            'productName': 'New Product',
            'quantity': 1,
            'cost': 15.0,
            'imageUrls': ['https://via.placeholder.com/100'],
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
