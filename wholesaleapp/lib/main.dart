import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wholesaleapp/screens/splashScreen/splash_screen.dart';

import 'package:wholesaleapp/screens/homeScreen/all_products_screen.dart';
import 'package:wholesaleapp/screens/homeScreen/categories_screen.dart';
import 'package:wholesaleapp/screens/homeScreen/home_screen.dart';
import 'package:wholesaleapp/screens/homeScreen/user_profile_screen.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/screens/splashScreen/splash_screen.dart';


import 'helper/constant/colors_resource.dart';
import 'helper/utils/svg_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.pink[50],
        body: _child,
        bottomNavigationBar: FlashyTabBar(
          animationDuration: Duration(milliseconds: 800),
          animationCurve: Curves.linear,
          selectedIndex: _selectedIndex,
          showElevation: true,
          onItemSelected: (index) => setState(() {
            _selectedIndex = index;
            _handleNavigationChange(_selectedIndex);
          }),
          items: [
            FlashyTabBarItem(
              activeColor: ColorsResource.PRIMARY_COLOR,
              inactiveColor: Colors.blueGrey,
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            FlashyTabBarItem(
              activeColor: ColorsResource.PRIMARY_COLOR,
              inactiveColor: Colors.blueGrey,
              icon: Icon(Icons.category_rounded),
              title: Text('Categories'),
            ),
            FlashyTabBarItem(
              activeColor: ColorsResource.PRIMARY_COLOR,
              inactiveColor: Colors.blueGrey,
              icon: Icon(Icons.fastfood_rounded),
              title: Text('Products'),
            ),
            FlashyTabBarItem(
              activeColor: ColorsResource.PRIMARY_COLOR,
              inactiveColor: Colors.blueGrey,
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
          ],
        ),
      ),

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
          home: const SplashScreen(),
        );
      },

    );
  }
}
