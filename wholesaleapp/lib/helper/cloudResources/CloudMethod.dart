import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wholesaleapp/MODELS/PicModel.dart';




class cloud {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User currentUser = FirebaseAuth.instance.currentUser!;
  // CommonFunctions cMethod = CommonFunctions();
  Future<String> uploadProfileToStorage(
      Uint8List file, bool isPost, String uid) async {
    Reference storageRef =
        FirebaseStorage.instance.ref().child("users").child(uid);
    UploadTask uploadToask = storageRef.putData(file);
    TaskSnapshot task = await uploadToask;

    return task.ref.getDownloadURL();
  }

  
  Future<String> uploadImageToDatabase(
      {required Uint8List image, required String uid}) async {
    Reference storageRef =
        FirebaseStorage.instance.ref().child("products").child(uid);
    UploadTask uploadToask = storageRef.putData(image);
    TaskSnapshot task = await uploadToask;
    return task.ref.getDownloadURL();
  }

// profilePic
  Future<String> ProfilePic({
    required Uint8List file,
    required String uid,
  }) async {
    User currentUser = firebaseAuth.currentUser!;

    String url = await uploadProfileToStorage(file, false, currentUser.uid);
    Pic pic = Pic(id: currentUser.uid, photoUrl: url);
    await firebaseFirestore
        .collection("users")
        .doc(currentUser.uid)
        .update(pic.toJson());
    print(url);
    return url;
  }



  
  
  
}