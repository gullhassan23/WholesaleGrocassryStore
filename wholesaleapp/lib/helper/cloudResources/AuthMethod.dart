import 'dart:typed_data';

import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wholesaleapp/MODELS/AdminModel.dart';
import 'package:wholesaleapp/MODELS/PicModel.dart';

import 'package:wholesaleapp/MODELS/distributModel.dart';
import 'package:wholesaleapp/helper/cloudResources/CloudMethod.dart';

class Authenticationclass {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String adminEmail = 'admin@example.com';
  // final String adminPassword = 'admin123';
  // final String adminName = "Wholesaler";
  // final String adminPhone = "+923351764911";

  Future<Distributor> getUsersDetails() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('Distributors').doc(currentUser.uid).get();

    return Distributor.fromMap(snap as Map<String, dynamic>);
  }

  Future<String> signUpDistributor(
      {required String name,
      required String phone,
      required String email,
      required String password}) async {
    name.trim();
    phone.trim();
    email.trim();
    password.trim();
    String output = "Something went wrong";
    if (name != "" && email != "" && phone != "" && password != "") {
      try {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String salt = BCrypt.gensalt();
        String hashedPassword = BCrypt.hashpw(password, salt);
        print(hashedPassword);
        print(cred.user!.uid);
        Distributor users = Distributor(
          lastActive: DateTime.now(),
          email: email,
          phone: phone,
          password: hashedPassword,
          name: name,
          uid: cred.user!.uid,
        );

        await _firestore
            .collection('Distributors')
            .doc(cred.user!.uid)
            .set(users.toMap());
        // await cloud().uploadUserDataToFireStore(user: user);
        output = "success";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = "Please fill up all the fields.";
    }
    return output;
  }

  Future<String> signInDistributor(
      {required String email, required String password}) async {
    email.trim();
    password.trim();
    String output = "Something went wrong";
    if (email != "" && password != "") {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        output = "success";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = "Please fill up alll the fields.";
    }

    return output;
  }

  Future<String> signUpAdmin(
      {required String name,
      required String email,
      required String phone,
      required String password}) async {
    name.trim();
    phone.trim();
    email.trim();
    password.trim();
    String output = "Something went wrong";
    if (name != "" && email == adminEmail && password != "" && phone != "") {
      try {
        UserCredential admincred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // String salt = BCrypt.gensalt();
        // String hashedPassword = BCrypt.hashpw(password, salt);
        // print(hashedPassword);
        print(admincred.user!.uid);
        Admin admin = Admin(
            isAdmin: true,
            Aphone: phone,
            AlastActive: DateTime.now(),
            Aemail: email,
            Aname: name,
            Apassword: password,
            Auid: admincred.user!.uid);

        await _firestore
            .collection('WholeSaler')
            .doc(admincred.user!.uid)
            .set(admin.toMap());
        // await cloud().uploadUserDataToFireStore(user: user);
        output = "success";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = "Please fill up all the fields.";
    }
    return output;
  }

  Future<String> signInAdminUser(
      {required String email, required String password}) async {
    email.trim();
    password.trim();
    String output = "Something went wrong";
    if (email == adminEmail && password != "") {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        output = "success";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = "Please fill up alll the fields.";
    }

    return output;
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException e) onVerificationFailed,
  }) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: onVerificationFailed,
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle auto retrieval timeout
      },
    );
  }

  // Method to verify OTP and reset the password
  Future<void> verifyOtpAndResetPassword({
    required String verificationId,
    required String smsCode,
    required String newPassword,
  }) async {
    try {
      // Verify the OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Sign in using the credential
      UserCredential userCredential =
          await auth.signInWithCredential(credential);

      // Update password for the user
      await userCredential.user?.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Failed to reset password: ${e.toString()}');
    }
  }

  Future<String> ProfilePic({
    required Uint8List file,
    required String uid,
  }) async {
    User currentUser = auth.currentUser!;
    String url =
        await cloud().uploadProfileToStorage(file, false, currentUser.uid);

    Pic pic = Pic(id: currentUser.uid, photoUrl: url);
    await _firestore
        .collection("Distributors")
        .doc(currentUser.uid)
        .update(pic.toJson());
    print(url);

    return url;
  }
}
