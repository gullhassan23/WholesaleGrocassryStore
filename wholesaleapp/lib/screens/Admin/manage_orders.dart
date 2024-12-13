import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/OrderController.dart';

import '../../helper/constant/colors_resource.dart';

class ManageOrders extends StatefulWidget {
  const ManageOrders({super.key});

  @override
  State<ManageOrders> createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  final OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    orderController.checkAdminStatus().then((_) {
      if (orderController.isAdmin.value) {
        orderController.adminfetchOrdersData();
      }
    });
    orderController.checkAdminStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Manage Orders',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          backgroundColor: Colors.white,
          toolbarHeight: 40,
          centerTitle: true,
        ),
        body: Obx(() {
          if (orderController.orders.isEmpty) {
            return Center(
              child: Text(
                'No orders found',
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
              ),
            );
          } else {
            return RefreshIndicator(
                onRefresh: () async {
                  await orderController.adminfetchOrdersData();
                },
                child: ListView.builder(
                  itemCount: orderController.orders.length,
                  itemBuilder: (context, index) {
                    final order = orderController.orders[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(order.productImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.productName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        order.userName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        order.shippingAddress,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Qty: ${order.quantity}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Icon(order.status == "cash_on_delivery"
                                          ? Icons.payment
                                          : Icons.money_outlined)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            order.dispatchstatus != 'Dispatched' &&
                                    order.dispatchstatus != 'cancel'
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(order.userid)
                                              .collection("productx")
                                              .doc(order.cartIID)
                                              .update(
                                                  {'dispatchstatus': 'cancel'});
                                          await orderController
                                              .adminfetchOrdersData();
                                          setState(() {
                                            order.dispatchstatus = 'cancel';
                                          });
                                          Get.snackbar(
                                              "Success", "Order is canceled");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.blueGrey.shade200,
                                        ),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(order.userid)
                                              .collection("productx")
                                              .doc(order.cartIID)
                                              .update({
                                            'dispatchstatus': 'Dispatched'
                                          });
                                          setState(() {
                                            order.dispatchstatus = 'Dispatched';
                                          });
                                          await orderController
                                              .adminfetchOrdersData();

                                          Get.snackbar("Success",
                                              "Your product is dispatched");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ColorsResource.PRIMARY_COLOR,
                                        ),
                                        child: Text(
                                          'Dispatch order',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Text(
                                      order.dispatchstatus == 'Dispatched'
                                          ? "Product is dispatched"
                                          : order.dispatchstatus == 'cancel'
                                              ? "Order canceled"
                                              : "",
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 17.sp),
                                    ),
                                  ),
                            // order.dispatchstatus != 'Dispatched'
                            //     ? Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceEvenly,
                            //         children: [
                            //           ElevatedButton(
                            //             onPressed: () async {
                            //               await FirebaseFirestore.instance
                            //                   .collection('orders')
                            //                   .doc(order.userid)
                            //                   .collection("productx")
                            //                   .doc(order.pid)
                            //                   .update({'dispatchstatus': 'cancel'});
                            //             },
                            //             style: ElevatedButton.styleFrom(
                            //               backgroundColor: Colors.blueGrey.shade200,
                            //             ),
                            //             child: Text(
                            //               'Cancel',
                            //               style: TextStyle(color: Colors.white),
                            //             ),
                            //           ),
                            //           ElevatedButton(
                            //             onPressed: () async {
                            //               await FirebaseFirestore.instance
                            //                   .collection('orders')
                            //                   .doc(order.userid)
                            //                   .collection("productx")
                            //                   .doc(order.pid)
                            //                   .update(
                            //                       {'dispatchstatus': 'Dispatched'});
                            //               Get.snackbar("Success",
                            //                   "Your product is dispatched");
                            //               print(
                            //                   "product dispatched  ${order.productName}");
                            //               orderController.adminfetchOrdersData();
                            //             },
                            //             style: ElevatedButton.styleFrom(
                            //               backgroundColor:
                            //                   ColorsResource.PRIMARY_COLOR,
                            //             ),
                            //             child: Text(
                            //               'Dispatch order',
                            //               style: TextStyle(color: Colors.white),
                            //             ),
                            //           ),
                            //         ],
                            //       )
                            //     : Center(
                            //         child: Text(
                            //           order.dispatchstatus == 'Dispatched'
                            //               ? "Product is dispatched"
                            //               : "Order canceled",
                            //           style: TextStyle(
                            //               color: Colors.blue, fontSize: 17.sp),
                            //         ),
                            //       ),
                            // order.dispatchstatus != 'Dispatched'
                            //     ? Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceEvenly,
                            //         children: [
                            //           ElevatedButton(
                            //             onPressed: () async {
                            //               await FirebaseFirestore.instance
                            //                   .collection('orders')
                            //                   .doc(order.userid)
                            //                   .collection("productx")
                            //                   .doc(order.pid)
                            //                   .update({
                            //                 'dispatchstatus': 'Cancelled',
                            //               });
                            //               Get.snackbar("Order Cancelled",
                            //                   "Product is cancelled");
                            //               orderController.adminfetchOrdersData();
                            //             },
                            //             style: ElevatedButton.styleFrom(
                            //               backgroundColor: Colors.blueGrey.shade200,
                            //             ),
                            //             child: Text(
                            //               'Cancel',
                            //               style: TextStyle(color: Colors.white),
                            //             ),
                            //           ),
                            //           // : SizedBox(),

                            //           ElevatedButton(
                            //               onPressed: () async {
                            //                 await FirebaseFirestore.instance
                            //                     .collection('orders')
                            //                     .doc(order.userid)
                            //                     .collection("productx")
                            //                     .doc(order.pid)
                            //                     .update({
                            //                   'dispatchstatus': 'Dispatched'
                            //                 });
                            //                 Get.snackbar("Success",
                            //                     "Your product is dispatched");
                            //                 print(
                            //                     "product dispatched  ${order.productName}");
                            //                 orderController.adminfetchOrdersData();
                            //               },
                            //               style: ElevatedButton.styleFrom(
                            //                 backgroundColor:
                            //                     ColorsResource.PRIMARY_COLOR,
                            //               ),
                            //               child: Text(
                            //                 'Dispatch order',
                            //                 style: TextStyle(color: Colors.white),
                            //               ))
                            //         ],
                            //       )
                            //     : Center(
                            //         child: Text(
                            //           "Product is dispatched",
                            //           style: TextStyle(
                            //               color: Colors.blue, fontSize: 17.sp),
                            //         ),
                            //       ),
                          ],
                        ),
                      ),
                    );
                  },
                ));
          }
        }));
  }
}
