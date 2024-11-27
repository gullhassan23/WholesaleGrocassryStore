import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wholesaleapp/MODELS/ItemModel.dart';
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

  // Future<String> uploadImageToDatabase(
  //     {required Uint8List image, required String uid}) async {
  //   Reference storageRef =
  //       FirebaseStorage.instance.ref().child("Items").child(uid);
  //   UploadTask uploadTask = storageRef.putData(image);
  //   TaskSnapshot task = await uploadTask;
  //   return task.ref.getDownloadURL();
  // }

// profilePic
  Future<String> ProfilePic({
    required Uint8List file,
    required String uid,
  }) async {
    User currentUser = firebaseAuth.currentUser!;

    String url = await uploadProfileToStorage(file, false, currentUser.uid);
    Pic pic = Pic(id: currentUser.uid, photoUrl: url);
    await firebaseFirestore
        .collection("Distributor")
        .doc(currentUser.uid)
        .update(pic.toJson());
    print(url);
    return url;
  }

  Future<String> uploadProductToDatabase({
    required String type,
    required List<Uint8List> imageFiles, // List of Uint8List images
    required String productName,
    required String rawCost,
    required description,
    required String quantity,
  }) async {
    description = description.trim();
    productName = productName.trim();
    rawCost = rawCost.trim();
    String output = "Something went wrong";

    if (imageFiles.isNotEmpty &&
        quantity.isNotEmpty &&
        type.isNotEmpty &&
        productName.isNotEmpty &&
        rawCost.isNotEmpty) {
      try {
        // Create a new document ID
        String docid = firebaseFirestore.collection("Items").doc().id;

        // Convert images to Base64 strings
        List<String> base64Images = imageFiles.map((image) {
          return base64Encode(image);
        }).toList();

        // Parse the raw cost to a double
        double cost = double.parse(rawCost);

        // Create the item model
        ItemModel item = ItemModel(
          type: type,
          quantity: quantity,
          createdAT: DateTime.now(),
          uid: docid,
          imageUrls: base64Images, // Store Base64 strings
          itemName: productName,
          cost: cost,
          description: description,
        );

        // Save the item to Firestore
        await firebaseFirestore
            .collection("Items")
            .doc(docid)
            .set(item.toMap());

        output = "success";
      } catch (e) {
        output = e.toString();
      }
    } else {
      output = "Please make sure all the fields are not empty";
    }

    return output;
  }

//  Future<String> uploadProductToDatabase({
//   required String type,
//   required List<Uint8List> imageUrls, // Image URLs directly passed
//   required String productName,
//   required String rawCost,
//   required description,
//   required String quantity,
// }) async {
//   description = description.trim();
//   productName = productName.trim();
//   rawCost = rawCost.trim();
//   String output = "Something went wrong";

//   if (imageUrls.isNotEmpty &&
//       quantity.isNotEmpty &&
//       type.isNotEmpty &&
//       productName.isNotEmpty &&
//       rawCost.isNotEmpty) {
//     try {
//       String docid = firebaseFirestore.collection("Items").doc().id;
//       double cost = double.parse(rawCost);

//       ItemModel item = ItemModel(
//           type: type,
//           quantity: quantity,
//           createdAT: DateTime.now(),
//           uid: docid,
//           imageUrls: imageUrls,
//           itemName: productName,
//           cost: cost,
//           description: description);

//       await firebaseFirestore
//           .collection("Items")
//           .doc(docid)
//           .set(item.toMap());
//       output = "success";
//     } catch (e) {
//       output = e.toString();
//     }
//   } else {
//     output = "Please make sure all the fields are not empty";
//   }

//   return output;
// }
}
