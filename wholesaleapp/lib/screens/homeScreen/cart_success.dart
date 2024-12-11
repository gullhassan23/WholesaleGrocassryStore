import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import 'package:wholesaleapp/screens/homeScreen/navigation.dart';

import '../../helper/constant/colors_resource.dart';
import '../../helper/constant/images_resource.dart';

class CartSuccessScreen extends StatefulWidget {
  const CartSuccessScreen({super.key});

  @override
  State<CartSuccessScreen> createState() => _CartSuccessScreenState();
}

class _CartSuccessScreenState extends State<CartSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:
              EdgeInsets.only(top: 8.h, bottom: 8.h, left: 8.w, right: 8.w),
          child: Column(
            children: [
              SizedBox(
                height: 180.h,
              ),
              Text(
                'Payment Successful',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Lottie.asset(
                ImagesResource.success,
                height: 300.h,
                width: 300.w,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  fixedSize: Size(200.w, 20.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    side: BorderSide(color: ColorsResource.PRIMARY_COLOR),
                  ),
                ),
                onPressed: () async {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeContentScreen()),
                    (route) => false,
                  );
                },
                child: Text(
                  'Continue Shopping',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ), // Optional content
              ),
            ],
          ),
        ),
      ),
    );
  }
}
