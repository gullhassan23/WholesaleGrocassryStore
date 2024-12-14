
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/MODELS/distributModel.dart';
import 'package:wholesaleapp/screens/Auth/sign_in.dart';

class UserController extends GetxController {
  var distributer = Distributor(
    lastActive: DateTime.now(),
    name: '',
    email: '',
    password: '',
    photoUrl: '',
    phone: '',
  ).obs;

  var isLoading = false.obs;
  String? token;
  @override
  void onInit() {
    super.onInit();
    fetchDistributorData();
    listenAuthChanges();
  }

  /// Listen for FirebaseAuth state changes.
  void listenAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        fetchDistributorData(); // Fetch data whenever user logs in/out
      }
    });
  }

  

  /// Fetch user data from Firestore based on FirebaseAuth UID
  Future<void> fetchDistributorData() async {
    isLoading.value = true;

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print("No user is signed in.");
        return;
      }

      String uid = currentUser.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Distributors')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        distributer.value =
            Distributor.fromMap(userDoc.data() as Map<String, dynamic>);
        print("Distributor fetched: ${distributer.value.name}");
      } else {
        print("No data found for UID: $uid");
      }
    } catch (e) {
      Get.snackbar('Error', "Failed to fetch distributor data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout and navigate to the SignIn screen
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => SignIn());
    } catch (e) {
      Get.snackbar('Error', "Failed to logout: $e");
    }
  }

  Future<void> updateUserPhone(String newPhone) async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('Distributors')
        .doc(currentUser.uid)
        .update({'phone': newPhone});
    distributer.update((val) {
      val?.phone = newPhone;
    });
  }
}
