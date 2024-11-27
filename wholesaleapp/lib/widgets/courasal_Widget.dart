import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../helper/constant/colors_resource.dart';

class CarouselStack extends StatelessWidget {
  final int currentIndex;
  final List imageList;
  final CarouselSliderController carouselController;
  final Function(int) onPageChanged;

  const CarouselStack({
    Key? key,
    required this.currentIndex,
    required this.imageList,
    required this.carouselController,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  onPageChanged: (index, reason) => onPageChanged(index),
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
                    onTap: () => carouselController.animateToPage(entry.key),
                    child: Container(
                      width: currentIndex == entry.key ? 17 : 7,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentIndex == entry.key
                            ? ColorsResource.PRIMARY_COLOR
                            : Colors.white,
                      ),
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
      ],
    );
  }
}
