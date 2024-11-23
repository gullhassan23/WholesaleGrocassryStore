import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wholesaleapp/screens/Auth/ResetPassword.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();

  Future<void> verifyOTP(String otp) async {
    try {
      final credential = await PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                verifyOTP(otpController.text);
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
