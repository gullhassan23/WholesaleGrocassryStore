import 'package:flutter/material.dart';
import 'package:wholesaleapp/screens/splashScreen/splash_screen.dart';

import 'helper/constant/colors_resource.dart';
import 'helper/utils/svg_utils.dart';

void main() {
  SvgUtils.preCacheSVGs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demmm',
      theme: ThemeData(
        scaffoldBackgroundColor: ColorsResource.WHITE,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

