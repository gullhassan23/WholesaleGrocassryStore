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
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Payment Successful',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 20.h), // Adds spacing
              Lottie.asset(
                ImagesResource.success,
                height: 250.h,
                width: 250.w,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 30.h), // Adds spacing
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 32.w),
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
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
