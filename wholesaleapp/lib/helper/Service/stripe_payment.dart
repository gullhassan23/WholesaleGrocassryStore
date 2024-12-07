import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wholesaleapp/Controllers/CartController.dart';
import 'package:wholesaleapp/Controllers/distribController.dart';
import 'package:wholesaleapp/screens/homeScreen/navigation.dart';

class PaymentMethod {
  final CartController cartController = Get.find();
  // final OrderController orderController = Get.find();
  final UserController userController = Get.put(UserController());
  Map<String, dynamic>? paymentIntent;
  // final Cart cart;

  // PaymentMethod(this.cart);
  Future<void> makePayment2(String amount) async {
    print(amount);
    try {
      // Create the payment intent
      paymentIntent = await createPaymentIntent(amount);
      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "US", currencyCode: "USD", testEnv: true);
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],
        style: ThemeMode.light,
        merchantDisplayName: "HASSAN",
        googlePay: gpay,
      ));

      // Display the payment sheet
      await displayPaymentSheet();

      // Clear the cart after successful payment
      cartController.clearCart();
    } catch (e) {
      print("Error initializing payment sheet: ${e.toString()}");
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // Save order to Firestore
      // await orderController.ordertoFirestore();

      print('Order sent to Firestore');

      // Clear the cart after successful payment
      cartController.clearCart();

      // Navigate to the successful payment screen
      // Get.to(() => SuccessfullPayment());
      Get.to(() => HomeContentScreen());
      print('Payment done');
    } catch (e) {
      // Handle payment failure
      // Get.to(() => UnSuccessfullPayment());
      print("Failed to display payment sheet: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(String amount) async {
    try {
      Map<String, dynamic> body = {
        "amount":
            calculateAmount(amount), // Consider adjusting the amount as needed
        "currency": "USD",
        "payment_method_types[]": "card",
      };

      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51LYvOaG5oJVKdCdoSBgJVQY3FtPewAydxJ7k5uWmr2wUu4l9pRlDExp6SjqSpT2Lcdw26a60CEhzwlPANWymF9E700qG7AlO7L",
            "Content-Type": "application/x-www-form-urlencoded"
          });
      return json.decode(response.body);
    } catch (e) {
      throw Exception("Failed to create payment intent: ${e.toString()}");
    }
  }

  // Future<void> saveOrderToFirestore() async {
  //   User currentUser = FirebaseAuth.instance.currentUser!;
  //   // Implement your Firestore logic here to save order data
  //   // Example:
  //   await FirebaseFirestore.instance.collection('orders').add({
  //     'userId': currentUser.uid,
  //     'totalAmount': cartController.totalPrice.value,
  //     'items': cartController.cartItems.map((item) => item.data()).toList(),
  //     'timestamp': Timestamp.now(),
  //     'userName': userController.user.value.name
  //   });
  // }

  calculateAmount(String amount) {
    try {
      // Ensure the amount is a valid double and multiply by 100 to get cents
      final doubleAmount = double.tryParse(amount);
      if (doubleAmount == null) {
        throw FormatException("Invalid amount format");
      }

      final int amountInCents = (doubleAmount * 100).toInt();
      return amountInCents.toString();
    } catch (e) {
      print("Failed to calculate amount: ${e.toString()}");
      throw Exception("Invalid amount format");
    }
  }
}
