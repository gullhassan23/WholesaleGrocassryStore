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
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: GestureDetector(
              onTap: () {
                adminController.logout(context);
              },
              child: Text("ADMIN DASHBOARD")),
          actions: [
            Icon(Icons.notifications, size: 30),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: GridView.count(
                  shrinkWrap: true,
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
                        // Define this route in your GetX routing
                      },
                    ),
                    _buildDashboardTile(
                      context: context,
                      title: "Inventory",
                      icon: Icons.inventory,
                      onTap: () {
                        // Navigate to Inventory Screen
                      },
                    ),
                    _buildDashboardTile(
                      context: context,
                      title: "Stock",
                      icon: Icons.storage,
                      onTap: () {
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
                    Text("logout")
                  ],
                ),
              ),
            ],
          ),
        ));
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
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
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


// mport 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:wholesaleapp/Controllers/AdminController.dart';

// class AdminHome extends StatelessWidget {
//   const AdminHome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Fetch Admincontroller
//     final Admincontroller adminController = Get.put(Admincontroller());

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         title: const Text("ADMIN DASHBOARD"),
//         actions: [
//           Icon(Icons.notifications, size: 30),
//           SizedBox(
//             width: 10,
//           )
//         ],
//       ),
//       body: Obx(() {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Text(
//                 //   "Hello, ${adminController.wholesaler.value.Aname.isNotEmpty ? adminController.wholesaler.value.Aname : 'Loading...'}",
//                 //   style:
//                 //       const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 // ),
//                 // const SizedBox(height: 20),
//                 Expanded(
//                   child: GridView.count(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 16,
//                     mainAxisSpacing: 16,
//                     children: [
//                       _buildDashboardTile(
//                         context: context,
//                         title: "Edit Profile",
//                         icon: Icons.person,
//                         onTap: () {
//                           // Navigate to Edit Profile Screen
//                           // Define this route in your GetX routing
//                         },
//                       ),
//                       _buildDashboardTile(
//                         context: context,
//                         title: "Inventory",
//                         icon: Icons.inventory,
//                         onTap: () {
//                           // Navigate to Inventory Screen
//                         },
//                       ),
//                       _buildDashboardTile(
//                         context: context,
//                         title: "Stock",
//                         icon: Icons.storage,
//                         onTap: () {
//                           // Navigate to Stock Screen
//                         },
//                       ),
//                       _buildDashboardTile(
//                         context: context,
//                         title: "Handle Orders",
//                         icon: Icons.shopping_cart,
//                         onTap: () {
//                           // Navigate to Handle Orders Screen
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () async {
//                     adminController.logout(context);
//                   },
//                   child: const Text(
//                     "Logout",
//                     style: TextStyle(
//                       color: Colors.red,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildDashboardTile({
//     required BuildContext context,
//     required String title,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.blue,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 6,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: Colors.white, size: 40),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }