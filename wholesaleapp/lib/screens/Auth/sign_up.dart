import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wholesaleapp/screens/Auth/sign_in.dart';

import '../../helper/constant/colors_resource.dart';
import '../../helper/constant/images_resource.dart';
import '../../widgets/custom_text_field.dart';

class SignUP extends StatefulWidget {
  const SignUP({super.key});

  @override
  State<SignUP> createState() => _SignUpState();
}

class _SignUpState extends State<SignUP> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    );
                  },
                  child: SvgPicture.asset(ImagesResource.ARROW),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Sign up now',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: ColorsResource.BLACK_SHADE,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Please fill the details and create account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorsResource.GREY,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const CustomTextFormField(
                  text: 'Name',
                ),
                const SizedBox(
                  height: 24,
                ),
                const CustomTextFormField(
                  text: 'Email',
                ),
                const SizedBox(
                  height: 24,
                ),
                const CustomTextFormField(
                  text: 'Password',
                  suffixIcon: Icon(Icons.remove_red_eye),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // Adjust the radius here
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all<Color>(
                            ColorsResource.PRIMARY_COLOR)),
                    onPressed: () {
                      /// TODO
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorsResource.WHITE,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 55,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorsResource.LIGHT_GREY,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignIn()),
                        );
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorsResource.ORANGE,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    'Or connect',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ColorsResource.LIGHT_GREY,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(ImagesResource.fb),
                    const SizedBox(
                      width: 20,
                    ),
                    SvgPicture.asset(ImagesResource.insta),
                    const SizedBox(
                      width: 20,
                    ),
                    SvgPicture.asset(ImagesResource.twitter),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
