import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/AdminController.dart';
import 'package:wholesaleapp/screens/Admin/InventoryScreen.dart';
import 'package:wholesaleapp/screens/Admin/StockScreen.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch Admincontroller
    final Admincontroller adminController = Get.put(Admincontroller());

    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: GestureDetector(
            onTap: () {
              adminController.logout(context);
            },
            child: Text(
              "ADMIN DASHBOARD",
              style: TextStyle(fontSize: 20.sp),
            ),
          ),
          actions: [
            Icon(Icons.notifications, size: 30.sp),
            SizedBox(width: 10.w),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  children: [
                    _buildDashboardTile(
                      context: context,
                      title: "Edit Profile",
                      icon: Icons.person,
                      onTap: () {
                        // Navigate to Edit Profile Screen
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
                        // Navigate to Stock Screen
                      },
                    ),
                    _buildDashboardTile(
                      context: context,
                      title: "Handle Orders",
                      icon: Icons.shopping_cart,
                      onTap: () {
                        // Navigate to Handle Orders Screen
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40.sp),
            SizedBox(height: 10.h),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
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
