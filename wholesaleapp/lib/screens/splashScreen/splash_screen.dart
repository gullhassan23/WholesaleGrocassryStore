import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../helper/constant/colors_resource.dart';
import '../../helper/constant/images_resource.dart';
import '../boardingScreen/boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var size, height, width;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BoardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              ImagesResource.SPLASH,
              height: 300,
              width: 300,
            ),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              child: Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Text(
                  'WholeSale Grocery Store',
                  style: TextStyle(
                    fontSize: 24,
                    color: ColorsResource.BLACK_SHADE,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
