import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../helper/constant/images_resource.dart';
import '../screens/homeScreen/cart_screen.dart';

class cartScreenBorderContainer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 10,
      ),
      child: Container(
        width: double.infinity,
        height: 340.h,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
                    '\$ ${cartController.getsubAmount().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
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
              height: 10,
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
                    '\$ ${cartController.getTotalAmount().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey.shade400,
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                _selectedRadio == 0
                    ? SvgPicture.asset(
                        ImagesResource.BEVERAGE,
                        height: 20,
                        width: 20,
                      )
                    : SvgPicture.asset(
                        ImagesResource.VEGE,
                        height: 20,
                        width: 20,
                      ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  displayText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Shipping Address',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Faizan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(Icons.call),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '03244985570',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(Icons.person),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  height: 50,
                  width: 210,
                  child: Text(
                    locationController.text,
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
    );
  }
}
