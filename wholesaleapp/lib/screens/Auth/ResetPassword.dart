import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/screens/Auth/sign_in.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Future<void> updatePassword(String newPassword) async {
  //   try {
  //     final hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
  //     User user = FirebaseAuth.instance.currentUser!;

  //     // Reauthenticate the user using email
  //     AuthCredential credential = EmailAuthProvider.credential(
  //       email: widget.email,
  //       password: newPassword,
  //     );

  //     await user.reauthenticateWithCredential(credential);

  //     // Update password in Firebase Auth
  //     await user.updatePassword(newPassword);
  //     print("userId========> ${user.uid}");
  //     // Update password in Firestore (optional if storing password hashes)
  //     await FirebaseFirestore.instance
  //         .collection('Distributors') // Replace with your collection name
  //         .doc(user.uid)
  //         .update({'password': hashedPassword});

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Password updated successfully')),
  //     );

  //     // Navigate to Login Screen
  //     Navigator.pushReplacementNamed(context, '/login');
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to update password: $e')),
  //     );
  //     print(e);
  //   }
  // }
  Future<void> updatePassword(String newPassword) async {
    try {
      final hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

      // Fetch the user based on email
      final snapshot = await FirebaseFirestore.instance
          .collection('Distributors')
          .where('email', isEqualTo: widget.email)
          .get();

      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found in Firestore.')),
        );
        return;
      }

      final documentId = snapshot.docs.first.id;

      // Optionally reauthenticate (if needed for sensitive actions)
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: widget.email,
          password: 'current_password', // Prompt the user for this
        );

        await user.reauthenticateWithCredential(credential);

        // Update password in Firebase Auth
        await user.updatePassword(newPassword);
      }

      // Update password in Firestore
      await FirebaseFirestore.instance
          .collection('Distributors')
          .doc(documentId)
          .update({'password': hashedPassword});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );

      Get.to(() => SignIn());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update password: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updatePassword(passwordController.text);
                  }
                },
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
