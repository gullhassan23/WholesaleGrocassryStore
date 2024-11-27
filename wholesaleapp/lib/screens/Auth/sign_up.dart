import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:wholesaleapp/helper/cloudResources/AuthMethod.dart';
import 'package:wholesaleapp/screens/Auth/sign_in.dart';
import '../../helper/constant/colors_resource.dart';
import '../../widgets/custom_text_field.dart';

class SignUP extends StatefulWidget {
  const SignUP({super.key});

  @override
  State<SignUP> createState() => _SignUpState();
}

class _SignUpState extends State<SignUP> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController passcode = TextEditingController();
  final TextEditingController phone = TextEditingController();
  bool visiblePassword = false;
  final _formKey = GlobalKey<FormState>();

  bool isLoad = false;

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    email.dispose();
    passcode.dispose();
    phone.dispose();
  }

  void SignUp() async {
    setState(() {
      isLoad = true;
    });

    if (email.text == Authenticationclass().adminEmail &&
        passcode.text == Authenticationclass().adminPassword &&
        phone.text == Authenticationclass().adminPhone &&
        name.text == Authenticationclass().adminName) {
      String output = await Authenticationclass().signUpAdmin(
          name: name.text,
          phone: phone.text,
          email: email.text,
          password: passcode.text);
      setState(() {
        isLoad = false;
      });
      if (output == "success") {
        print("All good happening");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SignIn()));
      } else {
        //error
        Get.snackbar(
          "Signup Error", // Title
          output, // Message
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } else {
      String output = await Authenticationclass().signUpDistributor(
        phone: phone.text,
        name: name.text,
        email: email.text,
        password: passcode.text,
      );
      setState(() {
        isLoad = false;
      });
      if (output == "success") {
        print("All good happening");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SignIn()));
      } else {
        //error
        Get.snackbar(
          "Signup Error", // Title
          output, // Message
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                    CustomTextFormField(
                      obscureText: false,
                      controller: name,
                      text: 'Name',
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    CustomTextFormField(
                      controller: email,
                      text: 'Email',
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomTextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter password";
                        }
                        return null;
                      },
                      controller: passcode,
                      text: 'Password',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              visiblePassword = !visiblePassword;
                            });
                          },
                          icon: Icon(
                            visiblePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          )),
                      obscureText: !visiblePassword,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    IntlPhoneField(
                      showCountryFlag: true,
                      dropdownIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                      decoration: InputDecoration(
                          hintText: "Phone Number",
                          filled: true,
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
                          fillColor: ColorsResource.LIGHT_WHITE,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorsResource.LIGHT_WHITE,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          // border: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(10),
                          //     borderSide: Divider.createBorderSide(context)),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xfffd6f3e),
                          )),
                      initialCountryCode: "+92",
                      onChanged: (text) => setState(() {
                        phone.text = text.completeNumber;
                      }),
                    ),
                    // CustomTextFormField(
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return "Enter phone number";
                    //     }
                    //     return null;
                    //   },
                    //   controller: phone,
                    //   text: 'Phone',
                    // ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12.0), // Adjust the radius here
                              ),
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(
                                ColorsResource.PRIMARY_COLOR)),
                        onPressed: SignUp,
                        child: isLoad
                            ? CircularProgressIndicator(
                                color:
                                    ColorsResource.WHITE) // Loading indicator
                            : Text(
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
                              MaterialPageRoute(builder: (context) => SignIn()),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
