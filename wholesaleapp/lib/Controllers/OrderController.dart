import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/CartController.dart';
import 'package:wholesaleapp/Controllers/distribController.dart';
import 'package:wholesaleapp/MODELS/OrderModel.dart';

class OrderController extends GetxController {
  var orders = <OrderModel>[].obs;
  RxList<OrderModel> specificorder = <OrderModel>[].obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CartController cartController = Get.put(CartController());
  UserController distributerController = Get.put(UserController());

  var isAdmin = false.obs;

  get isLoading => null;

  @override
  void onInit() {
    fetchOrdersData();
    adminfetchOrdersData();
    checkAdminStatus();
    super.onInit();
  }

  Future<void> checkAdminStatus() async {
    try {
      User? currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        print('No user is currently signed in');
        return;
      }

      DocumentSnapshot userDoc =
          await firestore.collection('WholeSaler').doc(currentUser.uid).get();

      if (userDoc.exists) {
        isAdmin.value = userDoc['isAdmin'] ?? false;
        print('Admin status: ${isAdmin.value}');
      } else {
        isAdmin.value = false;
      }

      if (isAdmin.value) {
        fetchOrdersData();
      }
    } catch (e) {
      print('Failed to check admin status: $e');
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> ordertoFirestore({required String paymentMethod}) async {
    try {
      User? currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        CollectionReference orderCollection = firestore.collection('orders');

        for (var cartItem in cartController.cartItems) {
          final itemData = cartItem.data() as Map<String, dynamic>;

          final String productUID = itemData['productId'] ?? '';
          final String cartID = itemData['cid'] ?? '';
          OrderModel orderModel = OrderModel(
            shippingAddress: cartController.shippingAddress.value,
            productImage: itemData['productImage'],
            productName: itemData['productName'],
            price: itemData['cost'],
            quantity: itemData['quantity'],
            cartIID: cartID,
            status: paymentMethod == 'card'
                ? "payment_with_card"
                : "cash_on_delivery",
            pid: productUID,
            dispatchstatus: "processing",
            totalBIll: cartController.totalPrice.value,
            userid: currentUser.uid,
            userName: distributerController.distributer.value.name,
            orderDate: DateTime.now(),
          );

          print('Saving order: ${orderModel.toMap()}');

          await orderCollection
              .doc(orderModel.userid)
              .collection("productx")
              .doc(orderModel.cartIID)
              .set(orderModel.toMap());
          print(orderModel);
        }

        print('Order added successfully');
      } else {
        print('No user is currently signed in');
      }
    } catch (e) {
      print('Failed to add order: $e');
    }
  }

  Future<void> updateOrderStatus(
      String userId, String cartId, String status) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(userId)
        .collection("productx")
        .doc(cartId)
        .update({'dispatchstatus': status});
  }

  Future<bool> dispatchOrder(OrderModel order) async {
    try {
      final productRef =
          FirebaseFirestore.instance.collection('Items').doc(order.pid);
      final productSnapshot = await productRef.get();

      if (productSnapshot.exists) {
        final currentQuantity = productSnapshot['quantity'];
        final newQuantity = currentQuantity - order.quantity;

        if (newQuantity < 0) {
          Get.snackbar("Error", "Not enough stock available to dispatch.");
          return false;
        }

        await productRef.update({'quantity': newQuantity});
        await updateOrderStatus(
            order.userid, order.cartIID, " DISPATCH_STATUS_DISPATCHED");
        return true;
      } else {
        Get.snackbar("Error", "Product not found.");
        return false;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> adminfetchOrdersData() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collectionGroup('productx')
          .orderBy('orderDate', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          OrderModel order = OrderModel.fromMap(data);

          if (!orders.any((o) => o.cartIID == order.cartIID)) {
            orders.add(order);
          }

          print("Order added: ${order}");
        }
        print("Orders fetched successfully: ${orders.length}");
      } else {
        print("No orders found in the database.");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print("Error fetching orders data: $e");
    }
  }

  Future<void> fetchOrdersData() async {
    try {
      specificorder.clear();
      User? currentUser = firebaseAuth.currentUser;

      if (currentUser != null) {
        CollectionReference userOrdersCollection = firestore
            .collection('orders')
            .doc(currentUser.uid)
            .collection('productx');

        QuerySnapshot snapshot = await userOrdersCollection
            .orderBy('orderDate', descending: true)
            .get();

        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            OrderModel order = OrderModel.fromMap(data);

            if (!specificorder.any((o) => o.cartIID == order.cartIID)) {
              specificorder.add(order);
            }

            print("Order added: ${order}");
          }
          print("Orders fetched successfully: ${orders.length}");
        } else {
          print("No orders found in the database.");
        }
      } else {
        print('No user is currently signed in');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print("Error fetching orders data: $e");
    }
  }

  // Future<void> sendOrderDispatchNotification(
  //     String userId, String orderId) async {
  //   try {
  //     // Fetch user data from Firestore
  //     DocumentSnapshot userSnap = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .get();

  //     // Check if user document exists
  //     if (userSnap.exists) {
  //       // Get device token from user document
  //       String deviceToken = userSnap['token'];
  //       print("Device token: $deviceToken");

  //       // Set the receiver token in the NotificationSService instance
  //       NotificationSService notificationService = NotificationSService();
  //       notificationService.receiverToken = deviceToken;

  //       // Send notification
  //       await notificationService.sEnDNotIfication(
  //           "Your order is ready to dispatch and will be delivered in 4 days.",
  //           userId);

  //       // Update order status in Firestore
  //       await firestore
  //           .collection('orders')
  //           .doc(orderId)
  //           .update({'status': 'On the way'});
  //       fetchOrdersData(); // Refresh the orders list
  //     } else {
  //       print("User data not found for UID: $userId");
  //     }
  //   } catch (e) {
  //     print("Error sending notification: $e");
  //     Get.snackbar('Error', e.toString());
  //   }
  // }

  // Future<void> deleteOrder(String uid) async {
  //   try {
  //     // Get the document reference
  //     DocumentReference docRef = firestore.collection('orders').doc(uid);

  //     // Check if the document exists
  //     DocumentSnapshot docSnapshot = await docRef.get();
  //     if (docSnapshot.exists) {
  //       // Delete the document from Firestore
  //       await docRef.delete();

  //       // Remove the order from local state
  //       orders.removeWhere((order) => order.userid == uid);
  //       print(
  //           "Order with uid $uid deleted successfully from Firestore and app state.");
  //     } else {
  //       print("Order with uid $uid does not exist in Firestore.");
  //       Get.snackbar('Error', 'Order does not exist in Firestore.');
  //     }
  //   } catch (e) {
  //     print("Error deleting order: ${e.toString()}");
  //     Get.snackbar('Error', 'Error deleting order: ${e.toString()}');
  //   }
  // }

  Future<void> deleteOrder(String userId, String productId) async {
    try {
      // Get the document reference
      DocumentReference docRef = firestore
          .collection('orders')
          .doc(userId)
          .collection('items')
          .doc(productId);

      // Check if the document exists
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        // Delete the document from Firestore
        await docRef.delete();

        // Remove the order from local state
        orders.removeWhere(
            (order) => order.userid == userId && order.pid == productId);
        print(
            "Order with userId $userId and productId $productId deleted successfully from Firestore and app state.");
      } else {
        print(
            "Order with userId $userId and productId $productId does not exist in Firestore.");
        Get.snackbar('Error', 'Order does not exist in Firestore.');
      }
    } catch (e) {
      print("Error deleting order: ${e.toString()}");
      Get.snackbar('Error', 'Error deleting order: ${e.toString()}');
    }
  }
}
