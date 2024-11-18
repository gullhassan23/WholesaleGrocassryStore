import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:wholesaleapp/screens/Auth/sign_in.dart';

import '../../helper/constant/colors_resource.dart';
import '../../helper/constant/images_resource.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    otpController.addListener(() {
      _isButtonEnabled.value = otpController.text.length == 5;
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(ImagesResource.ARROW),
              ),
              const SizedBox(
                height: 40,
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Add Verification Code',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: ColorsResource.BLACK_SHADE,
                  ),
                ),
              ),
              const SizedBox(
                height: 34,
              ),
              const Text(
                'We have sent a verification code to your number',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: ColorsResource.GREY,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Pinput(
                controller: otpController,
                length: 5,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                defaultPinTheme: const PinTheme(
                  width: 52,
                  height: 42,
                  textStyle: TextStyle(fontSize: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: ColorsResource.PINPUT_DISABLE_COLOR,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ValueListenableBuilder(
                    valueListenable: _isButtonEnabled,
                    builder: (context, isEnabled, child) {
                      return ElevatedButton(
                        style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12.0), // Adjust the radius here
                              ),
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(
                              isEnabled
                                  ? ColorsResource.PRIMARY_COLOR // Enable color
                                  : Colors.grey,
                            )),
                        onPressed: isEnabled
                            ? () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignIn()),
                                  (route) => false,
                                );
                              }
                            : null,
                        child: const Text(
                          'Verify',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ColorsResource.WHITE,
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
