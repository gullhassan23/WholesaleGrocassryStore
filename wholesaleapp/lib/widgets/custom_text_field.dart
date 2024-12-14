import 'package:flutter/material.dart';

import '../helper/constant/colors_resource.dart';

class CustomTextFormField extends StatelessWidget {
  final String text;
  final String hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final bool? obscureText;
  final int lines;
  final TextInputType textInputType;

  const CustomTextFormField(
      {super.key,
      required this.text,
      this.controller,
      this.hint = "",
      this.validator,
      this.lines = 1,
      this.textInputType = TextInputType.text,
      this.suffixIcon,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: lines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: textInputType,
      controller: controller,
      obscureText: obscureText ?? false,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorsResource.LIGHT_WHITE,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorsResource.PRIMARY_COLOR,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
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
