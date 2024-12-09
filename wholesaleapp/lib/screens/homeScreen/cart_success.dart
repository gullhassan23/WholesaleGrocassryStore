import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Text(
                'Payment Successful',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Lottie.asset(
                ImagesResource.success,
                height: 300,
                width: 300,
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  fixedSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
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
