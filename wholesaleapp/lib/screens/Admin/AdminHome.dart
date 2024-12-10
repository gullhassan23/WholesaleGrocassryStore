
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/AdminController.dart';
import 'package:wholesaleapp/helper/utils/dialog_utils.dart';
import 'package:wholesaleapp/screens/Admin/InventoryScreen.dart';
import 'package:wholesaleapp/screens/Admin/ProfileScreen.dart';
import 'package:wholesaleapp/screens/Admin/StockScreen.dart';

import 'manage_orders.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final Admincontroller adminController = Get.put(Admincontroller());
    var height, width;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.blue,
        height: height,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header Section
            Container(
              height: height * 0.25,
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.blue, // Match the background color
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'https://picsum.photos/250?image=8',
                        ),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: () async {
                            bool? logoutResult =
                                await DialogUtils.showLogoutDialog(
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
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Admin Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Last Update Text
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: height * 0.75,
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildDashboardTile(
                        context: context,
                        title: "Edit Profile",
                        icon: Icons.person,
                        onTap: () {
                          // Navigate to Edit Profile Screen
                          Get.to(() => Profile());
                        },
                      ),
                      _buildDashboardTile(
                        context: context,
                        title: "Inventory",
                        icon: Icons.inventory,
                        onTap: () {
                          // Navigate to Inventory Screen
                          Get.to(() => InventoryScreen());
                        },
                      ),
                      _buildDashboardTile(
                        context: context,
                        title: "Stock",
                        icon: Icons.storage,
                        onTap: () {
                          Get.to(() => StockScreen());
                        },
                      ),
                      _buildDashboardTile(
                        context: context,
                        title: "Manage Orders",
                        icon: Icons.shopping_cart,
                        onTap: () {
                          Get.to(() => ManageOrders());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Grid Section
          ],
        ),
      ),
    );
  }
  Widget _buildDashboardTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6.r,
              offset: Offset(0, 3.h),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blueGrey, size: 40.sp),
            SizedBox(height: 10.h),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}