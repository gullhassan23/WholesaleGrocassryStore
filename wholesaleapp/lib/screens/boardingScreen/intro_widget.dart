import 'package:flutter/material.dart';

import '../../helper/constant/colors_resource.dart';
import '../Auth/sign_in.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({
    super.key,
    required this.color,
    required this.title,
    required this.description,
    required this.skip,
    required this.image,
    required this.onTab,
    required this.index,
  });

  final String color;
  final String title;
  final String description;
  final bool skip;
  final String image;
  final VoidCallback onTab;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .55,
          decoration: BoxDecoration(
              color: Colors.white,
              image:
                  DecorationImage(image: AssetImage(image), fit: BoxFit.fill),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
        ),
        Positioned(
          top: 30,
          right: 20,
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SignIn(),
                ),
              );
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: ColorsResource.BLACK,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * .45,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      color: ColorsResource.GREY,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 0,
          left: 0,
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 46,
                child: MaterialButton(
                  color: ColorsResource.PRIMARY_COLOR,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onPressed: onTab,
                  child: index == 0
                      ? Text('Get Started',
                          style: TextStyle(color: Colors.white))
                      : Text('Next', style: TextStyle(color: Colors.white)),
                ),
              )),
        )
      ],
    );
  }
}
