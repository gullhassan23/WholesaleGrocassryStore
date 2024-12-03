import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/helper/constant/colors_resource.dart';

// CartController to manage state
class CartController extends GetxController {
  var radioSelection = false.obs;
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

  double getTotalAmount() {
    double totalAmount = cartItems.fold(0.0, (sum, item) {
      return sum + (item['quantity'] * item['cost']);
    });
    if (totalAmount != 0) {
      totalAmount += 15;
    }

    return totalAmount;
  }
}

// CartScreen with GetX
class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.put(CartController());
  final TextEditingController locationController = TextEditingController();
  int _selectedRadio = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Products',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: cartController.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartController.cartItems[index];
                          final int quantity = item['quantity'];
                          final double price = item['cost'];
                          final double totalPriceForItem = price * quantity;

                          return Card(
                            color: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      ),
                                      imageUrl: item['imageUrls'][0],
                                      height: 50.0,
                                      width: 50.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['productName'],
                                      ),
                                      SizedBox(height: 10.0),
                                      SizedBox(
                                        width: 200.w,
                                        height: 40.h,
                                        child: Text(
                                          item['productDescription'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () => cartController
                                                .decrementQuantity(index),
                                            child: Container(
                                              height: 30.0, // Adjust height
                                              width: 30.0, // Adjust width
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                // Background color
                                                shape: BoxShape
                                                    .circle, // Circular shape
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.black,
                                                size: 18.0, // Adjust icon size
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          Text(
                                            quantity.toString(),
                                          ),
                                          SizedBox(width: 10.0),
                                          InkWell(
                                            onTap: () => cartController
                                                .incrementQuantity(index),
                                            child: Container(
                                              height: 30.0,
                                              width: 30.0,
                                              decoration: BoxDecoration(
                                                color: ColorsResource
                                                    .PRIMARY_COLOR,
                                                shape: BoxShape
                                                    .circle, // Circular shape
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 18.0, // Adjust icon size
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\$ ${totalPriceForItem.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 50.h),
                                      InkWell(
                                        onTap: () => cartController
                                            .removeFromCart(index),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
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
                    SizedBox(height: 15.0),
                    Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        hintText: 'Enter your address',
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
                    SizedBox(height: 15.0),
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<int>(
                          value: 0,
                          activeColor: ColorsResource.PRIMARY_COLOR,
                          groupValue: _selectedRadio,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedRadio = value!;
                            });
                          },
                        ),
                        Text(
                          'Card Payment',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Radio<int>(
                          value: 1,
                          activeColor: ColorsResource.PRIMARY_COLOR,
                          groupValue: _selectedRadio,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedRadio = value!;
                            });
                          },
                        ),
                        Text(
                          'Cash on delivery',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          fillColor: WidgetStateProperty.all(
                              ColorsResource.PRIMARY_COLOR),
                          value: true,
                          groupValue: true, // Always selected
                          onChanged: null, // Disabl
                        ),
                        Text(
                          'Card Payment',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ),
          // Total Amount Widget
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  maximumSize: Size(double.infinity, 50),
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: ColorsResource.PRIMARY_COLOR,
                  padding: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // perform navigation
                },
                child: Center(
                  child: Text(
                    'Checkout: \$ ${cartController.getTotalAmount().toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cartController.addToCart({
            'productName': 'Apple',
            'productDescription':
                'Apple is good for your health ccd Apple is good for your health cndj cjs e cdnc cdnc cnsdj',
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
