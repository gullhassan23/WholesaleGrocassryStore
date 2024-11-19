import 'dart:typed_data';

import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wholesaleapp/MODELS/PicModel.dart';

import 'package:wholesaleapp/MODELS/distributModel.dart';
import 'package:wholesaleapp/helper/cloudResources/CloudMethod.dart';


class Authenticationclass {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String adminEmail = 'admin@example.com';
  final String adminPassword = 'admin123';
  final String adminName = "HASSAN";
  final String adminPhone = "+923351764911";




  Future<Distributor> getUsersDetails() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return Distributor.fromMap(snap as Map<String, dynamic>);
  }

  Future<String> signUpDistributor(
      {required String name,
      required String email,
      required String address,
      required String password}) async {
    name.trim();

    address.trim();
    email.trim();
    password.trim();
    String output = "Something went wrong";
    if (name != "" && email != "" && address != "" && password != "") {
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
          address: address,
          password: hashedPassword,
          name: name,
          uid: cred.user!.uid,
        );

        await _firestore
            .collection('users')
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

  // Future<String> signUpAdmin(
  //     {required String name,
  //     required String phone,
  //     required String email,
  //     required String password}) async {
  //   name.trim();
  //   phone.trim();
  //   email.trim();
  //   password.trim();
  //   String output = "Something went wrong";
  //   if (name == adminName &&
  //       phone == adminPhone &&
  //       email == adminEmail &&
  //       password == adminPassword) {
  //     try {
  //       UserCredential admincred = await auth.createUserWithEmailAndPassword(
  //           email: email, password: password);

  //       // String salt = BCrypt.gensalt();
  //       // String hashedPassword = BCrypt.hashpw(password, salt);
  //       // print(hashedPassword);
  //       print(admincred.user!.uid);
  //       Admin admin = Admin(
  //           isAdmin: true,
  //           AlastActive: DateTime.now(),
  //           Aemail: email,
  //           Aname: name,
  //           Apassword: password,
  //           Aphone: phone,
  //           Auid: admincred.user!.uid);

  //       await _firestore
  //           .collection('Admin')
  //           .doc(admincred.user!.uid)
  //           .set(admin.toMap());
  //       // await cloud().uploadUserDataToFireStore(user: user);
  //       output = "success";
  //     } on FirebaseAuthException catch (e) {
  //       output = e.message.toString();
  //     }
  //   } else {
  //     output = "Please fill up all the fields.";
  //   }
  //   return output;
  // }

  // Future<String> signInAdminUser(
  //     {required String email, required String password}) async {
  //   email.trim();
  //   password.trim();
  //   String output = "Something went wrong";
  //   if (email == adminEmail && password == adminPassword) {
  //     try {
  //       await auth.signInWithEmailAndPassword(email: email, password: password);
  //       output = "success";
  //     } on FirebaseAuthException catch (e) {
  //       output = e.message.toString();
  //     }
  //   } else {
  //     output = "Please fill up alll the fields.";
  //   }

  //   return output;
  // }
  // Future<void> Logout(BuildContext context) async {
  //   FirebaseAuth _auth = FirebaseAuth.instance;
  //   try {
  //     await _auth.signOut().then((value) {
  //       // Navigator.pushReplacement(
  //       //     context, MaterialPageRoute(builder: (context) => Login()));
  //       Get.offAll(() => Login());
  //     });
  //   } catch (e) {
  //     print("error");
  //   }
  // }

  Future<String> ProfilePic({
    required Uint8List file,
    required String uid,
  }) async {
    User currentUser = auth.currentUser!;
    String url =
        await cloud().uploadProfileToStorage(file, false, currentUser.uid);

    Pic pic = Pic(id: currentUser.uid, photoUrl: url);
    await _firestore
        .collection("users")
        .doc(currentUser.uid)
        .update(pic.toJson());
    print(url);

    return url;
  }

  

  

}