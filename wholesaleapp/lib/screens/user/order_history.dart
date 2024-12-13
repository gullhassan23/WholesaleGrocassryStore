import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/OrderController.dart';
import 'package:wholesaleapp/helper/utils/dialog_utils.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    orderController.fetchOrdersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Orders History',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          backgroundColor: Colors.white,
          toolbarHeight: 40,
          centerTitle: true,
        ),
        body: Obx(() {
          if (orderController.specificorder.isEmpty) {
            return Center(
              child: Text("No order"),
            );
          } else {
            return Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await orderController.fetchOrdersData();
                    },
                    child: ListView.builder(
                      itemCount: orderController.specificorder.length,
                      itemBuilder: (context, index) {
                        var order = orderController.specificorder[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 6,
                                spreadRadius: 2,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.local_shipping,
                                      color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${order.dispatchstatus}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    'Qty: ${order.quantity}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Date Below Status
                              Row(
                                children: [
                                  Text(
                                    'Product name: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${order.productName}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Order and Shipping Date Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Order Section
                                  Row(
                                    children: [
                                      Icon(Icons.place, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Order no',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${order.cartIID}', // Dynamic order ID
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Shipping Date Section
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Ordered Date',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            DialogUtils().formatDate(
                                                order.orderDate.toString()),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        }));
  }
}
