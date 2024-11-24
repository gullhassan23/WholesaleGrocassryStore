import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../helper/constant/colors_resource.dart';
import '../../helper/constant/images_resource.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //final UserController userController = Get.put(UserController());
  List imageList = [
    {"id": 1, "image_path": 'assets/images/image1.png'},
    {"id": 2, "image_path": 'assets/images/image2.png'},
    {"id": 3, "image_path": 'assets/images/image3.png'}
  ];

  final CarouselSliderController carouselController =
      CarouselSliderController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<IconTextModel> items = [
      IconTextModel(
        text: 'Vegetables',
        assetIconPath: ImagesResource.VEGE,
        backgroundColor: ColorsResource.VEG_SHADE,
        textStyle: TextStyle(fontSize: 12, color: Colors.grey),
        onTap: () {},
      ),
      IconTextModel(
        text: 'Fruits',
        assetIconPath: ImagesResource.FRUITS,
        backgroundColor: ColorsResource.FRUIT_SHADE,
        textStyle: TextStyle(fontSize: 12, color: Colors.grey),
        onTap: () {},
      ),
      IconTextModel(
        text: 'Beverages',
        assetIconPath: ImagesResource.BEVERAGE,
        backgroundColor: ColorsResource.DRINK_SHADE,
        textStyle: TextStyle(fontSize: 12, color: Colors.grey),
        onTap: () {},
      ),
      IconTextModel(
        text: 'Grocery',
        assetIconPath: ImagesResource.GROCERY,
        backgroundColor: ColorsResource.GROCERY_SHADE,
        textStyle: TextStyle(fontSize: 12, color: Colors.grey),
        onTap: () {},
      ),
      IconTextModel(
        text: 'Edible oil',
        assetIconPath: ImagesResource.OIL,
        backgroundColor: ColorsResource.OIL_SHADE,
        textStyle: TextStyle(fontSize: 12, color: Colors.grey),
        onTap: () {},
      ),
      IconTextModel(
        text: 'Baby care',
        assetIconPath: ImagesResource.BABY,
        backgroundColor: ColorsResource.BABY_SHADE,
        textStyle: TextStyle(fontSize: 12, color: Colors.grey),
        onTap: () {},
      ),
    ];

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 8,
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .80,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Product',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          prefixIcon: Icon(
                            Icons.search,
                            color: ColorsResource.PRIMARY_COLOR,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorsResource.PRIMARY_COLOR,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorsResource.PRIMARY_COLOR,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartScreen()),
                        );
                      },
                      icon: Icon(Icons.shopping_cart),
                    )
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CarouselSlider(
                        items: imageList
                            .map(
                              (item) => Image.asset(
                                item['image_path'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                            .toList(),
                        carouselController: carouselController,
                        options: CarouselOptions(
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlay: true,
                          aspectRatio: 2,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imageList.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () =>
                                carouselController.animateToPage(entry.key),
                            child: Container(
                              width: currentIndex == entry.key ? 17 : 7,
                              height: 7.0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 3.0,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: currentIndex == entry.key
                                      ? ColorsResource.PRIMARY_COLOR
                                      : Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Row(
                        children: [
                          CircularContainerWithIconAndText(
                            text: item.text,
                            assetIconPath: item.assetIconPath,
                            backgroundColor: item.backgroundColor,
                            textStyle: item.textStyle,
                            onTap: item.onTap,
                          ),
                          SizedBox(
                            width: 8,
                          )
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Products',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 7.0 / 9.0,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 15,
                      children: [
                        Card(
                          elevation: 10,
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 18.0 / 11.0,
                                child: Image.asset('assets/images/image1.png'),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 12.0, 16.0, 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Title'),
                                    const SizedBox(height: 8.0),
                                    Text('Secondary Text'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 10,
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 18.0 / 11.0,
                                child: Image.asset('assets/images/image1.png'),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 12.0, 16.0, 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Title'),
                                    const SizedBox(height: 8.0),
                                    Text('Secondary Text'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 10,
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 18.0 / 11.0,
                                child: Image.asset('assets/images/image1.png'),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 12.0, 16.0, 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Title'),
                                    const SizedBox(height: 8.0),
                                    Text('Secondary Text'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 10,
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 18.0 / 11.0,
                                child: Image.asset('assets/images/image1.png'),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 12.0, 16.0, 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Title'),
                                    const SizedBox(height: 8.0),
                                    Text('Secondary Text'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] // Replace
                      ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class CircularContainerWithIconAndText extends StatelessWidget {
  final String text;
  final String assetIconPath;
  final Color backgroundColor;
  final TextStyle textStyle;
  final VoidCallback onTap;

  const CircularContainerWithIconAndText({
    Key? key,
    required this.text,
    required this.assetIconPath,
    required this.onTap,
    this.backgroundColor = Colors.blue,
    this.textStyle = const TextStyle(fontSize: 16, color: Colors.black),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                assetIconPath,
                height: 32,
                width: 32,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: textStyle,
        ),
      ],
    );
  }
}

class IconTextModel {
  final String text;
  final String assetIconPath;
  final Color backgroundColor;
  final TextStyle textStyle;
  final VoidCallback onTap;

  IconTextModel({
    required this.text,
    required this.assetIconPath,
    required this.backgroundColor,
    required this.textStyle,
    required this.onTap,
  });
}
// SizedBox(
//   height: 10,
// ),
// Row(
//   children: [
//     CircularContainerWithIconAndText(
//       text: 'Name',
//       assetIconPath: 'assets/icons/profile_icon.png',
//       backgroundColor: Colors.green,
//       textStyle: TextStyle(fontSize: 14, color: Colors.grey),
//       onTap: () {
//         print('Profile tapped!');
//       },
//     ),
//     SizedBox(
//       width: 5,
//     ),
//     CircularContainerWithIconAndText(
//       text: 'Profile',
//       assetIconPath: 'assets/icons/profile_icon.png',
//       backgroundColor: Colors.blue,
//       textStyle: TextStyle(fontSize: 14, color: Colors.white),
//       onTap: () {
//         print('Profile tapped!');
//       },
//     ),
//     SizedBox(
//       width: 5,
//     ),
//     CircularContainerWithIconAndText(
//       text: 'Profile',
//       assetIconPath: 'assets/icons/profile_icon.png',
//       backgroundColor: Colors.green,
//       textStyle: TextStyle(fontSize: 14, color: Colors.white),
//       onTap: () {
//         print('Profile tapped!');
//       },
//     ),
//     SizedBox(
//       width: 5,
//     ),
//     CircularContainerWithIconAndText(
//       text: 'Profile',
//       assetIconPath: 'assets/icons/profile_icon.png',
//       backgroundColor: Colors.green,
//       textStyle: TextStyle(fontSize: 14, color: Colors.white),
//       onTap: () {
//         print('Profile tapped!');
//       },
//     ),
//     SizedBox(
//       width: 5,
//     ),
//     CircularContainerWithIconAndText(
//       text: 'Profile',
//       assetIconPath: 'assets/icons/profile_icon.png',
//       backgroundColor: Colors.green,
//       textStyle: TextStyle(fontSize: 14, color: Colors.white),
//       onTap: () {
//         print('Profile tapped!');
//       },
//     ),
//     SizedBox(
//       width: 5,
//     ),
//     CircularContainerWithIconAndText(
//       text: 'Profile',
//       assetIconPath: 'assets/icons/profile_icon.png',
//       backgroundColor: Colors.green,
//       textStyle: TextStyle(fontSize: 14, color: Colors.white),
//       onTap: () {
//         print('Profile tapped!');
//       },
//     ),
//   ],
// ),
// SizedBox(
//   height: 80,
//   child: ListView.builder(
//     shrinkWrap: true,
//     itemCount: 6,
//     scrollDirection: Axis.horizontal,
//     itemBuilder: (_, index) {
//       return Column(
//         children: [
//           Container(
//             width: 56,
//             height: 56,
//             decoration: BoxDecoration(
//               color: Colors.brown,
//               borderRadius: BorderRadius.circular(100),
//             ),
//           )
//         ],
//       );
//     },
//   ),
// ),
// body: Obx(() {
//   if (userController.isLoading.value) {
//     return const Center(child: CircularProgressIndicator());
//   }
//
//   return Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text("Welcome to the App!"),
//         const SizedBox(height: 20),
//         Text(
//           "Hello, ${userController.distributer.value.name}",
//           style:
//               const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: () => userController.logout(context),
//           child: const Text("Logout"),
//         ),
//       ],
//     ),
//   );
// }),
