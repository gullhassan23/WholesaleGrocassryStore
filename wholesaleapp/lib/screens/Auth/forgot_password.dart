import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/screens/Auth/sign_in.dart';

import '../../helper/constant/colors_resource.dart';
import '../../helper/constant/images_resource.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<bool> checkEmailExists(String email) async {
    try {
      // Check in Firebase Authentication
      final List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) return true;

      // Check in multiple Firestore collections
      final collections = ['Distributors', 'WholeSaler']; // Add more if needed
      for (final collection in collections) {
        final snapshot = await FirebaseFirestore.instance
            .collection(collection)
            .where('email', isEqualTo: email)
            .get();
        if (snapshot.docs.isNotEmpty) return true;
      }
    } catch (e) {
      debugPrint("Error checking email: $e");
    }
    return false;
  }

  /// Sends a password reset email using Firebase Auth
  Future<void> sendResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar(
        "Success",
        "Password recovery email sent. Please check your inbox.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      Navigator.pushReplacementNamed(context, '/sign_in'); // Adjust as needed
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
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
          child: Form(
            key: _formKey,
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
                    'Forgot password',
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
                    'Enter your email to reset your password',
                    textAlign: TextAlign.center,
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
                  controller: emailController,
                  text: 'Email',
                  textInputType: TextInputType.emailAddress,
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
                    onPressed: () async {
                      // showDialog(
                      //   barrierDismissible: true,
                      //   context: context,
                      //   builder: (ctx) => AlertDialog(
                      //     backgroundColor: ColorsResource.WHITE,
                      //     content: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         SvgPicture.asset(ImagesResource.ALERT_ICON),
                      //         const SizedBox(
                      //           height: 20,
                      //         ),
                      //         const Text(
                      //           'Check your phone',
                      //           style: TextStyle(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.w900,
                      //             color: ColorsResource.BLACK,
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           height: 8,
                      //         ),
                      //         const Text(
                      //           'We have send password recovery OTP to your mobile',
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.w400,
                      //             color: ColorsResource.GREY,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ).then((_) {
                      //   Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const OtpScreen()),
                      //   );
                      // });

                      if (_formKey.currentState!.validate()) {
                        final email = emailController.text.trim();
                        bool emailExists = await checkEmailExists(email);

                        if (emailExists) {
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email)
                              .then((val) {
                            Get.snackbar(
                              "Success", // Title
                              "We have sent you email to recover password, please check your email",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              duration: Duration(seconds: 3),
                            );
                          }).onError((err, stackTrace) {
                            Get.snackbar(
                              "Forgot password Error", // Title
                              err.toString(),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              duration: Duration(seconds: 3),
                            );
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignIn(),
                            ),
                          );
                        } else {
                          Get.snackbar(
                            "Not Available", // Title
                            "your account does not exist",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            duration: Duration(seconds: 3),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorsResource.WHITE,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:wholesaleapp/helper/constant/colors_resource.dart';
// import 'package:wholesaleapp/screens/Auth/otp_screen.dart';
//
// class ForgotPassword extends StatefulWidget {
//   const ForgotPassword({Key? key}) : super(key: key);
//
//   @override
//   State<ForgotPassword> createState() => _ForgotPasswordState();
// }
//
// class _ForgotPasswordState extends State<ForgotPassword> {
//   final TextEditingController phoneNumberController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   Future<bool> checkPhoneNumber(String phoneNumber) async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('Distributors') // Replace with your collection name
//         .where('phone', isEqualTo: phoneNumber)
//         .get();
//     return snapshot.docs.isNotEmpty;
//   }
//
//   Future<void> sendOTP(String phoneNumber) async {
//     await FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) {
//         // Automatically verifies in some cases
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(e.message ?? 'Verification failed')),
//         );
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         // Navigate to OTP screen with the verificationId
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => OtpScreen()),
//         );
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {},
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           centerTitle: true,
//           title: const Text(
//             'Forgot Password',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           )),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // const Align(
//               //   alignment: Alignment.center,
//               //   child: Text(
//               //     'Forgot password',
//               //     style: TextStyle(
//               //       fontSize: 26,
//               //       fontWeight: FontWeight.w600,
//               //       color: ColorsResource.BLACK_SHADE,
//               //     ),
//               //   ),
//               // ),
//               const SizedBox(
//                 height: 12,
//               ),
//               const Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   'Enter your phone number to reset your password',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                     color: ColorsResource.GREY,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 40,
//               ),
//               TextFormField(
//                 controller: phoneNumberController,
//                 keyboardType: TextInputType.phone,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone Number',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your phone number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     String phoneNumber = phoneNumberController.text;
//                     bool exists = await checkPhoneNumber(phoneNumber);
//                     if (exists) {
//                       await sendOTP(phoneNumber);
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('This phone number is not registered'),
//                         ),
//                       );
//                     }
//                   }
//                 },
//                 child: const Text('Send OTP'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
