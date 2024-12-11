import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/helper/utils/dialog_utils.dart';
import 'package:wholesaleapp/screens/Admin/InventoryScreen.dart';
import 'package:wholesaleapp/screens/Admin/ProfileScreen.dart';
import 'package:wholesaleapp/screens/Admin/StockScreen.dart';
import 'package:wholesaleapp/screens/Admin/manage_orders.dart';

import '../../Controllers/AdminController.dart';

class AdminHome extends StatefulWidget {
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final Admincontroller adminController = Get.put(Admincontroller());
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue, // Set your preferred background color
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 8.w,
                right: 8.w,
                top: 8.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    return CircleAvatar(
                      radius: 30.r,
                      backgroundImage:
                          adminController.wholesaler.value.photoUrl != null &&
                                  adminController
                                      .wholesaler.value.photoUrl.isNotEmpty
                              ? NetworkImage(
                                  adminController.wholesaler.value.photoUrl)
                              : AssetImage('assets/images/default_avatar.png'),
                      backgroundColor: Colors.grey.shade200,
                    );
                  }),
                  GestureDetector(
                      onTap: () async {
                        bool? logoutResult = await DialogUtils.showLogoutDialog(
                            context: context);
                        if (logoutResult == true && context.mounted) {
                          adminController.logout(context);
                        }
                      },
                      child: Icon(
                        Icons.logout,
                        size: 30.sp,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            // Top Header Section
            Container(
              width: width,
              alignment: Alignment.center,
              child: Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Last Update Text
            Obx(() {
              return Align(
                alignment: Alignment.center,
                child: Text(
                  'Welcome Back ${adminController.wholesaler.value.Aname}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 15,
                  ),
                ),
              );
            }),
            SizedBox(
              height: 70.h,
            ),
            // Main Content Section
            Expanded(
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 32.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildDashboardTile(
                        icon: Icons.people,
                        label: 'Edit Profile',
                        onTap: () {
                          Get.to(() => Profile());
                        },
                      ),
                      _buildDashboardTile(
                        icon: Icons.inventory,
                        label: 'Inventory',
                        onTap: () {
                          Get.to(() => InventoryScreen());
                        },
                      ),
                      _buildDashboardTile(
                        icon: Icons.storage,
                        label: 'Stock',
                        onTap: () {
                          Get.to(() => StockScreen());
                        },
                      ),
                      _buildDashboardTile(
                        icon: Icons.shopping_bag,
                        label: 'Manage Orders',
                        onTap: () {
                          Get.to(() => ManageOrders());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: Offset(0, 3),
                spreadRadius: 2),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.blueGrey,
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
