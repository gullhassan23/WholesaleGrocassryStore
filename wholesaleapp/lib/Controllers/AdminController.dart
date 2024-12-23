
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/MODELS/AdminModel.dart';
import 'package:wholesaleapp/MODELS/ItemModel.dart';
import 'package:wholesaleapp/screens/Auth/sign_in.dart';

class Admincontroller extends GetxController {
  var wholesaler = Admin(
    AlastActive: DateTime.now(),
    Aemail: '',
    Apassword: '',
    Aname: '',
    photoUrl: '',
  ).obs;

  String? token;
  Admin? _wholesaler;

  var isLoading = false.obs;

  Admin? get wholeModel => _wholesaler;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchWholeSaleData();
      fetchWholeSalerProfile();
    });
    // Listen to FirebaseAuth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
      if (currentUser != null) {
        // saveUserToken(); // Save FCM token after user is authenticated
      }
    });
  }

  Future<void> fetchWholeSaleData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print("No Wholesaler is currently signed in.");
        return;
      }

      String uid = currentUser.uid;
      print("Fetching data for Wholesaler with UID: $uid");

      DocumentSnapshot userSnap = await FirebaseFirestore.instance
          .collection('WholeSaler')
          .doc(uid)
          .get();

      if (userSnap.exists) {
        print("Document data: ${userSnap.data()}");
        wholesaler.value =
            Admin.fromMap(userSnap.data() as Map<String, dynamic>);
        print("Wholesaler data fetched: ${wholesaler.value.Aname}");
      } else {
        print("No wholesaler data found for UID: $uid");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print("Error fetching wholesaler data: $e");
    }
  }

  Future<void> addItemToFirestore(ItemModel item) async {
    try {
      await FirebaseFirestore.instance.collection('items').add(item.toMap());
      Get.snackbar('Success', 'Item added successfully!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add item: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

// Fetch the current FCM token and save it to Firestore
  

  Future<void> fetchWholeSalerProfile() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print("No wholesaler is currently signed in.");
        return;
      }

      String uid = currentUser.uid;
      print("Fetching profile for wholesaler with UID: $uid");

      DocumentSnapshot userSnap = await FirebaseFirestore.instance
          .collection('WholeSaler')
          .doc(uid)
          .get();

      if (userSnap.exists) {
        wholesaler.value =
            Admin.fromMap(userSnap.data() as Map<String, dynamic>);
        print("Distributor profile data found: ${wholesaler.value.Aname}");
      } else {
        print("No wholesaler profile data found for UID: $uid");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print("Error fetching wholesaler profile: $e");
    }
  }

  Future<void> updateAdminName(String newName) async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('WholeSaler')
        .doc(currentUser.uid)
        .update({'Aname': newName});
    wholesaler.update((val) {
      val?.Aname = newName;
    });
  }

  Future<void> updateAdminPhone(String newPhone) async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('WholeSaler')
        .doc(currentUser.uid)
        .update({'Aphone': newPhone});
    wholesaler.update((val) {
      val?.Aphone = newPhone;
    });
  }

  // Future<void> updateAdminPass(String newPass) async {
  //   User currentUser = FirebaseAuth.instance.currentUser!;
  //   await FirebaseFirestore.instance
  //       .collection('WholeSaler')
  //       .doc(currentUser.uid)
  //       .update({'Apassword': newPass});
  //   wholesaler.update((val) {
  //     val?.Apassword = newPass;
  //   });
  // }

  Future<void> updateAdminPass(String newPass) async {
    try {
      User currentUser = FirebaseAuth.instance.currentUser!;

      // Update the password in Firebase Auth
      await currentUser.updatePassword(newPass);

      // Update the password in Firestore
      await FirebaseFirestore.instance
          .collection('WholeSaler')
          .doc(currentUser.uid)
          .update({'Apassword': newPass});

      wholesaler.update((val) {
        val?.Apassword = newPass;
      });

      Get.snackbar(
        'Success',
        'Password updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error updating password: $e");
      Get.snackbar(
        'Error',
        'Failed to update password. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // void getToken() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   String? token = await messaging.getToken();
  //   print("Device Token: $token");
  // }

  Future<void> logout(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.signOut().then((value) {
        Get.offAll(() => SignIn());
      });
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', e.toString());
    }
  }

// Future<void> sendMessage(
//     {required String message, required String receiverId}) async {
//   String? senderId = distributer.value.uid;

//   if (senderId.isEmpty || receiverId.isEmpty) {
//     print("Sender ID or Receiver ID is invalid.");
//     return; // Exit if IDs are invalid
//   }

//   // Generate a unique chatId

//   // Save message in Firestore under the unique chatId
//   await FirebaseFirestore.instance
//       .collection('chats')
//       .doc(senderId)
//       .collection('messages')
//       .add({
//     'senderId': senderId,
//     'receiverId': receiverId,
//     'message': message,
//     'timestamp': FieldValue.serverTimestamp(),
//   });

//   // Fetch doctor's FCM token from Firestore
//   DocumentSnapshot doc = await FirebaseFirestore.instance
//       .collection('doctors')
//       .doc(receiverId)
//       .get();

//   String doctorToken = doc['fcmToken'];
//   print("doctorToken ${doctorToken}");
//   // Send notification
//   sendnotificationUsingApi(
//     token: doctorToken,
//     title: "Message",
//     body: message,
//     data: {"type": "new-type"},
//   );
// }

// // Fetching messages using chatId
// Stream<QuerySnapshot> getMessages(String receiverId) {
//   String senderId = user.value.uid;
//   // String chatId = getChatId(senderId, receiverId);

//   return FirebaseFirestore.instance
//       .collection('chats')
//       .doc(senderId)
//       .collection('messages')
//       .orderBy('timestamp', descending: true)
//       .snapshots();
// }

// Generate a unique chatId combining sender and receiver IDs
// String getChatId(String userId, String doctorId) {
//   return userId.hashCode <= doctorId.hashCode
//       ? '$userId-$doctorId'
//       : '$doctorId-$userId';
// }
}
