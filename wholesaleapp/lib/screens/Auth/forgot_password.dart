import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wholesaleapp/helper/constant/colors_resource.dart';
import 'package:wholesaleapp/screens/Auth/otp_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Distributors') // Replace with your collection name
        .where('phone', isEqualTo: phoneNumber)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> sendOTP(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // Automatically verifies in some cases
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Verification failed')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        // Navigate to OTP screen with the verificationId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(verificationId: verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Forgot Password',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // const Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //     'Forgot password',
              //     style: TextStyle(
              //       fontSize: 26,
              //       fontWeight: FontWeight.w600,
              //       color: ColorsResource.BLACK_SHADE,
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 12,
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Enter your phone number to reset your password',
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
              TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String phoneNumber = phoneNumberController.text;
                    bool exists = await checkPhoneNumber(phoneNumber);
                    if (exists) {
                      await sendOTP(phoneNumber);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('This phone number is not registered'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
