import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/helper/utils/dialog_utils.dart';
import 'package:wholesaleapp/screens/splashScreen/splash_screen.dart';

import 'helper/constant/colors_resource.dart';
import 'helper/utils/svg_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = DialogUtils().stID;
  await Firebase.initializeApp();
  SvgUtils.preCacheSVGs();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Wholesale Grocery Store',
            theme: ThemeData(
              scaffoldBackgroundColor: ColorsResource.WHITE,
              colorScheme:
                  ColorScheme.fromSeed(seedColor: ColorsResource.PRIMARY_COLOR),
              useMaterial3: true,
            ),
            home: SplashScreen());
      },
    );
  }
}
