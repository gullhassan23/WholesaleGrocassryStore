import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/MODELS/AdminModel.dart';
import 'package:wholesaleapp/screens/Auth/sign_in.dart';

class Admincontroller extends GetxController {
  var wholesaler = Admin(
    AlastActive: DateTime.now(),
    Aemail: '',
    Apassword: '',
    Aname: '',
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

// Fetch the current FCM token and save it to Firestore
  // Future<void> saveUserToken() async {
  //   try {
  //     // Get FCM token
  //     String? token = await FirebaseMessaging.instance.getToken();

  //     // Get the currently logged-in user
  //     User? currentUser = FirebaseAuth.instance.currentUser;

  //     if (currentUser != null && token != null) {
  //       // Update the user's Firestore document with the FCM token
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(currentUser.uid)
  //           .update({
  //         'FcmToken': token, // Save token to 'FcmToken' field
  //       });
  //       print('FCM token saved successfully for user: ${currentUser.uid}');
  //     } else {
  //       print('User not logged in or FCM token is null');
  //     }
  //   } catch (e) {
  //     print('Error saving FCM token: $e');
  //   }
  // }

  // Future<void> sendnotificationUsingApi({
  //   required String? token,
  //   required String? title,
  //   required String? body,
  //   required Map<String, dynamic>? data,
  // }) async {
  //   String serverkey = await GetServiceKey().getServerKeyToken();
  //   print("notification server key =======> ${serverkey}");
  //   String url =
  //       "https://fcm.googleapis.com/v1/projects/medvisit-41b08/messages:send";
  //   var headers = <String, String>{
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $serverkey',
  //   };

  //   Map<String, dynamic> message = {
  //     "message": {
  //       "token": token,
  //       "notification": {
  //         "body": body,
  //         "title": title,
  //       },
  //       "data": data,
  //     }
  //   };

  //   // http api
  //   final http.Response response = await http.post(Uri.parse(url),
  //       headers: headers, body: jsonEncode(message));

  //   if (response.statusCode == 200) {
  //     print("Notification send Successfully");
  //   } else {
  //     print("Notification not send");
  //   }
  // }

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

  // Future<void> updateUserAddress(String newAddress) async {
  //   User currentUser = FirebaseAuth.instance.currentUser!;
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(currentUser.uid)
  //       .update({'address': newAddress});
  //   user.update((val) {
  //     val?.address = newAddress;
  //   });
  // }

  // Future<void> updateUserPhone(String newPhone) async {
  //   User currentUser = FirebaseAuth.instance.currentUser!;
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(currentUser.uid)
  //       .update({'phone': newPhone});
  //   user.update((val) {
  //     val?.phone = newPhone;
  //   });
  // }

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
