import 'package:flutter/material.dart';
import 'package:wholesaleapp/helper/constant/colors_resource.dart';

class CircularButton extends StatelessWidget {
  final IconData icon; // Icon for the button
  final VoidCallback onPressed; // Callback for the onPress event

  const CircularButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: ColorsResource.PRIMARY_COLOR, // Icon color
          size: 24,
        ),
      ),
    );
  }
}
