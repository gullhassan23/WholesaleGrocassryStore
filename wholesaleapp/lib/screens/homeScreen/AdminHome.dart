import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/AdminController.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch Admincontroller
    final Admincontroller adminController = Get.put(Admincontroller());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("ADMIN"),
      ),
      body: Obx(() {
        return Column(
          children: [
            Text(
              "Hello, ${adminController.wholesaler.value.Aname.isNotEmpty ? adminController.wholesaler.value.Aname : 'Loading...'}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () async {
                adminController.logout(context);
              },
              child: const Text("Logout"),
            ),
          ],
        );
      }),
    );
  }
}
