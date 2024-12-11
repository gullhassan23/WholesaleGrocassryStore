import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/ItemController.dart';

import 'package:wholesaleapp/helper/constant/images_resource.dart';

import 'package:wholesaleapp/widgets/all_product_text.dart';
import 'package:wholesaleapp/widgets/all_products_card.dart';
import 'package:wholesaleapp/widgets/categories_icon.dart';
import 'package:wholesaleapp/widgets/categories_text.dart';
import 'package:wholesaleapp/widgets/courasal_Widget.dart';
import 'package:wholesaleapp/widgets/header_widget.dart';

import 'all_products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ItemController itemController = Get.put(ItemController());
  final search = TextEditingController();
  final List<Map<String, dynamic>> imageList = [
    {"id": 1, "image_path": 'assets/images/image1.png'},
    {"id": 2, "image_path": 'assets/images/1.png'},
    {"id": 3, "image_path": 'assets/images/3.jpg'},
  ];

  List categories = [
    ImagesResource.VEGE,
    ImagesResource.FRUITS,
    ImagesResource.BEVERAGE,
    ImagesResource.GROCERY,
    ImagesResource.Meat,
    ImagesResource.cl,
    ImagesResource.frozen,
    ImagesResource.nuts,
  ];

  List categoryName = [
    'Vegetables',
    'Fruits',
    'Beverages',
    'Grocery',
    'Meat',
    'Clean',
    'Frozen',
    'Dry-Fruits'
  ];

  final CarouselSliderController carouselController =
      CarouselSliderController();
  int currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Width animation
    _widthAnimation = Tween<double>(begin: 200, end: 230).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _colorAnimation =
        ColorTween(begin: Colors.white, end: Colors.grey.shade200).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
    itemController.fetchProductData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    itemController.resetItems();
  }

  // void searchProductsss(String value) {
  //   itemController.searchProduct(value.obs);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                    SizedBox(
                      height: 10,
                    ),
                    CategoriesText(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      height: 100.h,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, index) {
                            return Row(
                              children: [
                                HorizontalIconList(
                                  image: categories[index],
                                  cat: categoryName[index],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AllProductText(),
                  ],
                ),
              ),
            ),
            Obx(() {
              if (itemController.allItems.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text("Product is empty",
                        style: TextStyle(fontSize: 16)),
                  ),
                );
              } else {
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 7 / 9,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = itemController.allItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 8),
                        child: AllProductsCard(itemModel: product),
                      );
                    },
                    childCount: 4,
                  ),
                );
              }
            }),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllProductScreen()),
                        );
                      },
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Container(
                            width: _widthAnimation.value,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: _colorAnimation.value,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Show more',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
