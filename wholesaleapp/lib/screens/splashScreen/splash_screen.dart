import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/constant/colors_resource.dart';
import '../../helper/constant/images_resource.dart';
import '../Admin/AdminHome.dart';
import '../Auth/sign_in.dart';
import '../boardingScreen/boarding_screen.dart';
import '../homeScreen/navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late FirebaseAuth auth;
  User? user;
  var size, height, width;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    user = auth.currentUser;
    // navigateBasedOnRole();
    navigateBasedOnState();
  }

  Future<void> navigateBasedOnState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      await Future.delayed(const Duration(seconds: 3));

      await prefs.setBool('isFirstTime', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BoardingScreen()),
      );
    } else {
      navigateBasedOnRole();
    }
  }

  Future<void> navigateBasedOnRole() async {
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userRole = prefs.getString("userRole");

      Future.delayed(const Duration(seconds: 3), () {
        if (userRole == "admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHome()),
          );
        } else if (userRole == "distributor") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeContentScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignIn()),
          );
        }
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      });
    }
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
