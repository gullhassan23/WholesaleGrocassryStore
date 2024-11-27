import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../MODELS/icon_text_model.dart';

class HorizontalIconList extends StatelessWidget {
  final List<IconTextModel> items;

  const HorizontalIconList({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
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
