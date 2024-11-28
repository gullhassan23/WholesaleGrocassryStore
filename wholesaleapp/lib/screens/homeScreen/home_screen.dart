import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../MODELS/icon_text_model.dart';
import '../../helper/constant/colors_resource.dart';
import '../../helper/constant/images_resource.dart';
import '../../widgets/all_product_text.dart';
import '../../widgets/all_products_card.dart';
import '../../widgets/categories_icon.dart';
import '../../widgets/categories_text.dart';
import '../../widgets/courasal_Widget.dart';
import '../../widgets/header_widget.dart';

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
  late Widget child;

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(),
                    CarouselStack(
                      currentIndex: currentIndex,
                      imageList: imageList,
                      carouselController: carouselController,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                    CategoriesText(),
                    HorizontalIconList(items: items),
                    AllProductText(),
                  ],
                ),
              ),
            ),
            AllProductsCard(),
          ],
        ),
      ),
    );
  }
}

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
