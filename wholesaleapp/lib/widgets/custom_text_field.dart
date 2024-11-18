import 'package:flutter/material.dart';

import '../helper/constant/colors_resource.dart';

class CustomTextFormField extends StatelessWidget {
  final String text;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final bool? obscureText;

  const CustomTextFormField(
      {super.key,
      required this.text,
      this.controller,
      this.validator,
      this.suffixIcon,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorsResource.LIGHT_WHITE,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.greenAccent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorsResource.LIGHT_WHITE,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        border: InputBorder.none,
        labelText: text,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
