import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wholesaleapp/Controllers/CartController.dart';
import 'package:wholesaleapp/Controllers/OrderController.dart';
import 'package:wholesaleapp/Controllers/distribController.dart';

import '../../screens/homeScreen/cart_success.dart';

class PaymentMethod {
  final CartController cartController = Get.find();
  final OrderController orderController = Get.put(OrderController());
  final UserController userController = Get.find<UserController>();
  Map<String, dynamic>? paymentIntent;

  Future<void> processPayment(String amount, String paymentMethod) async {
    if (paymentMethod == 'card') {
      await makePayment2(amount);
    } else if (paymentMethod == 'cash') {
      await processCashOnDelivery();
    } else {
      Get.snackbar('Error', 'Invalid payment method');
    }
  }

  Future<void> makePayment2(String amount) async {
    print(amount);
    try {
      // Create the payment intent
      paymentIntent = await createPaymentIntent(amount);
      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "QA", currencyCode: "QAR", testEnv: true);
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
      // cartController.clearCart();
    } on StripeException catch (e) {
      // Handle cancellation and errors
      if (e.error.localizedMessage != null &&
          e.error.localizedMessage!.toLowerCase().contains('canceled')) {
        print("User canceled the payment sheet.");
      } else {
        print("StripeException occurred: ${e.error.localizedMessage}");
      }
    } catch (e) {
      print("Error initializing payment sheet: ${e.toString()}");
    }
  }

  Future<void> processCashOnDelivery() async {
    try {
      await orderController.ordertoFirestore(paymentMethod: 'cash');
      cartController.clearCart();
      Get.to(() => CartSuccessScreen());
      print('Cash on delivery order placed successfully');
    } catch (e) {
      print("Error processing cash on delivery: ${e.toString()}");
      Get.snackbar('Error', 'Failed to place cash on delivery order');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      // Present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();

      // Save the order to Firestore after successful payment
      await orderController.ordertoFirestore(paymentMethod: 'card');
      print('Order sent to Firestore');

      // Clear the cart after successful payment
      cartController.clearCart();

      // Navigate to the successful payment screen
      Get.to(() => CartSuccessScreen());
      print('Payment done successfully');
    } on StripeException catch (e) {
      // Handle cancellation and errors
      if (e.error.localizedMessage != null &&
          e.error.localizedMessage!.toLowerCase().contains('canceled')) {
        print("User canceled the payment sheet.");
      } else {
        print("StripeException occurred: ${e.error.localizedMessage}");
      }
    } catch (e) {
      // Handle unexpected errors
      print("Failed to display payment sheet: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(String amount) async {
    try {
      Map<String, dynamic> body = {
        "amount":
            calculateAmount(amount), // Consider adjusting the amount as needed
        "currency": "QAR",
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
