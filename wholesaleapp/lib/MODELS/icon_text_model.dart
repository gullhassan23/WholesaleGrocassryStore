import 'package:flutter/material.dart';

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
