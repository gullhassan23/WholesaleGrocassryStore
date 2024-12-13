import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wholesaleapp/Controllers/CartController.dart';
import 'package:wholesaleapp/helper/Service/stripe_payment.dart';
import 'package:wholesaleapp/helper/constant/colors_resource.dart';
import 'package:wholesaleapp/helper/constant/images_resource.dart';

import '../../widgets/cart_border_container.dart';
import '../../widgets/incDecWidget.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.put(CartController());
  final TextEditingController locationController = TextEditingController();
  int _selectedRadio = 0;
  String displayText = '';
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    locationController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void unfocusTextField() {
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedRadio == 1) {
      displayText = 'cash';
    } else if (_selectedRadio == 0) {
      displayText = 'Debit Card.';
    } else {
      displayText = 'Please select a payment method.';
    }
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
        body: Obx(() {
          if (cartController.cartItems.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  ImagesResource.empty_cart,
                  width: 200,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Your cart is empty",
                  style: TextStyle(fontSize: 20.sp),
                ),
              ],
            ));
          } else {
            return GestureDetector(
              onTap: unfocusTextField, // Unfocus when tapping outside
              behavior: HitTestBehavior.opaque,
              child: Column(
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
                                  final double totalPriceForItem =
                                      price * quantity;

                                  return Card(
                                    color: Colors.white,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) => Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                Icons.error,
                                                color: Colors.white,
                                              ),
                                              imageUrl: item['productImage'],
                                              height: 100.0,
                                              width: 100.0,
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
                                                width: 120.w,
                                                height: 40.h,
                                                child: Text(
                                                  "item['description']  cjkcnd cnalnc cnalncas nvlakdn",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                ),
                                              ),
                                              SizedBox(height: 10.0),
                                              incDecWidget(
                                                cartController: cartController,
                                                quantity: quantity,
                                                index: index,
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
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
                                                    .removeFromCart(
                                                        cartController
                                                            .cartItems[index]
                                                            .id),
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
                            buildColumn(),
                            cartScreenBorderContainer(
                                cartController: cartController,
                                selectedRadio: _selectedRadio,
                                displayText: displayText,
                                locationController: locationController)
                          ],
                        ),
                      ),
                    ),
                  ),
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
                        onPressed: () async {
                          if (locationController.text.trim().isEmpty) {
                            Get.snackbar(
                              "Validation Error",
                              "Please fill in the delivery address.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red.withOpacity(0.8),
                              colorText: Colors.white,
                            );
                            return;
                          }
                          if (cartController.totalPriceGst > 0) {
                            String cost = cartController.totalPrice.toString();
                            String selectedPaymentMethod =
                                _selectedRadio == 0 ? 'card' : 'cash';
                            await PaymentMethod()
                                .processPayment(cost, selectedPaymentMethod);
                          } else {
                            Get.snackbar("Payment Message", "Cart is empty");
                          }
                        },
                        child: Center(
                          child: Text(
                            'Checkout: \$ ${cartController.totalPriceGst.toStringAsFixed(2)}',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }));
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          focusNode: focusNode,
          onChanged: (value) {
            setState(() {});
            cartController.updateShippingAddress(value);
          },
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
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
              ],
            ),
            Row(
              children: [
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
          ],
        ),
      ],
    );
  }
}
