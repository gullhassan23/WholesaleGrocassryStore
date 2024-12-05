// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/ItemController.dart';
import 'package:wholesaleapp/screens/homeScreen/product_by_cat.dart';

class HorizontalIconList extends StatelessWidget {
  final ItemController itemController = Get.put(ItemController());
  final String image;
  final String dataCat;
  final String cat;

  HorizontalIconList({
    Key? key,
    this.image = '',
    this.dataCat = '',
    this.cat = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        itemController.fetchProductsByCategory(cat);
        Get.to(() => ProductsByCategory(category: cat));
      },
      child: CircularContainerWithIconAndText(
        text: cat,
        assetIconPath: image,
        textStyle: TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}

class CircularContainerWithIconAndText extends StatelessWidget {
  final String text;
  final String assetIconPath;
  final TextStyle textStyle;

  const CircularContainerWithIconAndText({
    Key? key,
    required this.text,
    required this.assetIconPath,
    this.textStyle = const TextStyle(fontSize: 16, color: Colors.black),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 55,
          width: 70,
          decoration: BoxDecoration(
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
        //const SizedBox(height: 8),
        Text(
          text,
          style: textStyle,
        ),
      ],
    );
  }
}
