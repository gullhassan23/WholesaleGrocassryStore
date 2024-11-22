import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/constant/colors_resource.dart';
import '../Auth/sign_in.dart';
import 'intro_widget.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({super.key});

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  final PageController _pageController = PageController();
  final List<Map<String, dynamic>> _pages = [
    {
      'color': '#ffe24e',
      'title': 'Premium Food At Your Doorstep',
      'image': 'assets/images/image1.png',
      'description':
          "Enjoy premium-quality food delivered to your doorstep. Fresh ingredients, exquisite flavors, and exceptional service for a delightful dining experience.",
      'skip': true
    },
    {
      'color': '#a3e4f1',
      'title': 'Buy Premium Quality Fruits',
      'image': 'assets/images/image2.png',
      'description':
          'Discover premium quality fruits, handpicked for freshness and taste. Perfect for healthy snacking, cooking, or gifting. Freshness guaranteed!',
      'skip': true
    },
    {
      'color': '#31b77a',
      'title': 'Buy Quality Dairy Products',
      'image': 'assets/images/image3.png',
      'description':
          'Discover fresh, high-quality dairy products crafted for rich taste and nutrition. From milk to cheese, enjoy premium goodness daily',
      'skip': false
    },
  ];
  int _activePage = 0;

  void onNextPage() {
    if (_activePage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignIn(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              scrollBehavior: AppScrollBehavior(),
              onPageChanged: (int page) {
                setState(() {
                  _activePage = page;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return IntroWidget(
                  index: index,
                  color: _pages[index]['color'],
                  title: _pages[index]['title'],
                  description: _pages[index]['description'],
                  image: _pages[index]['image'],
                  skip: _pages[index]['skip'],
                  onTab: onNextPage,
                );
              }),
          Positioned(
            top: MediaQuery.of(context).size.height * .86,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildIndicator())
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildIndicator() {
    final indicators = <Widget>[];

    for (var i = 0; i < _pages.length; i++) {
      if (_activePage == i) {
        indicators.add(_indicatorsTrue());
      } else if (_activePage == 0 && i == 1) {
        indicators.add(_indicatorsFalsee());
      } else if (_activePage > 0 && i == 0) {
        indicators.add(_indicatorsFalsee());
      } else {
        indicators.add(_indicatorsFalse());
      }
    }

    return indicators;
  }

  Widget _indicatorsTrue() {
    final String color;
    if (_activePage == 0) {
      color = '#ffe24e';
    } else if (_activePage == 1) {
      color = '#a3e4f1';
    } else {
      color = '#31b77a';
    }

    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 6,
      width: 42,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: ColorsResource.PRIMARY_COLOR,
      ),
    );
  }

  Widget _indicatorsFalse() {
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 8,
      width: 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey.shade100,
      ),
    );
  }

  Widget _indicatorsFalsee() {
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 8,
      width: 15,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey.shade100,
      ),
    );
  }
}
