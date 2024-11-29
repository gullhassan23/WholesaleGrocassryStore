import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:wholesaleapp/screens/homeScreen/cart_screen.dart';
import 'package:wholesaleapp/screens/homeScreen/home_screen.dart';
import 'package:wholesaleapp/screens/homeScreen/user_profile_screen.dart';

import 'all_products_screen.dart';
import 'categories_screen.dart';

class HomeContentScreen extends StatefulWidget {
  @override
  _HomeContentScreenState createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  int _selectedIndex = 0;

  late Widget _currentScreen;

  final List<Widget> _screens = [
    HomeScreen(),
    CategoriesScreen(),
    AllProductScreen(),
    CartScreen(),
    UserProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentScreen = _screens[_selectedIndex]; // Initial screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _currentScreen, // Directly use the screen widget here
      bottomNavigationBar: FlashyTabBar(
        animationDuration: Duration(milliseconds: 800),
        animationCurve: Curves.linear,
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
            _currentScreen = _screens[
                _selectedIndex]; // Update screen based on selected index
          });
        },
        items: [
          FlashyTabBarItem(
            activeColor: Colors.blue,
            inactiveColor: Colors.blueGrey,
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          FlashyTabBarItem(
            activeColor: Colors.blue,
            inactiveColor: Colors.blueGrey,
            icon: Icon(Icons.category_rounded),
            title: Text('Categories'),
          ),
          FlashyTabBarItem(
            activeColor: Colors.blue,
            inactiveColor: Colors.blueGrey,
            icon: Icon(Icons.fastfood_rounded),
            title: Text('Products'),
          ),
          FlashyTabBarItem(
            activeColor: Colors.blue,
            inactiveColor: Colors.blueGrey,
            icon: Icon(Icons.shopping_cart),
            title: Text('Cart'),
          ),
          FlashyTabBarItem(
            activeColor: Colors.blue,
            inactiveColor: Colors.blueGrey,
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}
