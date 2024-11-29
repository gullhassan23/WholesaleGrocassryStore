
import 'package:flutter/material.dart';




class TextForm extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final ValueChanged<String>? onChanged;

  final Icon icon;

  const TextForm({
    this.onChanged,
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final inputborder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: Divider.createBorderSide(context));
    return TextFormField(
      controller: textEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter $hintText";
        }
        return null;
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        suffixIcon: icon,
       
        hintText: hintText,
        fillColor: Colors.white,
        border: inputborder,
        enabledBorder: inputborder,
        filled: true,
        contentPadding: const EdgeInsets.all(18),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}