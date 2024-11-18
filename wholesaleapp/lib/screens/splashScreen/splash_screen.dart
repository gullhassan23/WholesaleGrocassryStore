import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
      body: Container(
        width: double.infinity,
        color: ColorsResource.PRIMARY_COLOR,
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: height * 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child: SvgPicture.asset(ImagesResource.SPLASH),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: height * 1,
              child: const Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Text(
                      'WholeSale Grocery Store',
                      style: TextStyle(
                        fontSize: 34,
                        color: ColorsResource.WHITE,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
