import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProfileListItem extends StatelessWidget {
  final String text;
  IconData? icondata;
  VoidCallback? onPressed;

  ProfileListItem({required this.text, this.icondata, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 50,
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.blueGrey.shade100,
            ),
            child: Row(
              children: <Widget>[
                Text(
                  this.text,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                Icon(icondata),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
