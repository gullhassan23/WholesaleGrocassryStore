import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/CartController.dart';

import '../Controllers/distribController.dart';

class cartScreenBorderContainer extends StatefulWidget {
  const cartScreenBorderContainer({
    super.key,
    required this.cartController,
    required int selectedRadio,
    required this.displayText,
    required this.locationController,
  }) : _selectedRadio = selectedRadio;

  final CartController cartController;
  final int _selectedRadio;
  final String displayText;
  final TextEditingController locationController;

  @override
  State<cartScreenBorderContainer> createState() =>
      _cartScreenBorderContainerState();
}

class _cartScreenBorderContainerState extends State<cartScreenBorderContainer> {
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 30.w,
        vertical: 10.h,
      ),
      child: Container(
        width: double.infinity,
        height: 340.h,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Colors.grey.shade400, // Border color
            width: 2,
          ),
          // Rounded corners
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.5), // Shadow color
          //     spreadRadius: 2,
          //     blurRadius: 5,
          //     offset: Offset(0, 3), // Shadow position
          //   ),
          // ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SubTotal',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Obx(
                    () => Text(
                      '\$ ${widget.cartController.totalPrice.value.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shipping Fee',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$10',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Total',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Obx(
                        () => Text(
                      '\$ ${widget.cartController.totalPriceGst.value.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(
                color: Colors.grey.shade400,
                thickness: 1,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  widget._selectedRadio == 0
                      ? Icon(Icons.credit_card)
                      : Icon(Icons.attach_money_sharp),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    widget.displayText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Shipping Address',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                userController.distributer.value.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Icon(Icons.call),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    userController.distributer.value.phone,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(
                    width: 5.w,
                  ),
                  SizedBox(
                    // height: 40.h,
                    width: 210.w,
                    child: Text(
                      widget.locationController.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
