import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback ontap;
  const CustomButton({
    Key? key,
    required this.text,
    required this.ontap,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool changeButton = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(changeButton ? 50 : 8),
        child: InkWell(
          onTap: widget.ontap,
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            width: 250,
            height: 50,
            alignment: Alignment.center,
            child: changeButton
                ? Icon(
                    Icons.done,
                    color: Colors.white,
                  )
                : Text(
                    widget.text,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
          ),
        ));
  }
}
