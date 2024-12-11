import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wholesaleapp/Controllers/AdminController.dart';
import 'package:wholesaleapp/MODELS/AdminModel.dart';
import 'package:wholesaleapp/helper/cloudResources/CloudMethod.dart';
import 'package:wholesaleapp/helper/constant/colors_resource.dart';
import 'package:wholesaleapp/helper/constant/images_resource.dart';
import 'package:wholesaleapp/helper/utils/dialog_utils.dart';
import 'package:wholesaleapp/helper/utils/permission_utils.dart';

import '../../widgets/profile_list_items.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _firebaseImageUrl;
  final Admincontroller adminController = Get.put(Admincontroller());

  @override
  void initState() {
    super.initState();
    adminController.fetchWholeSaleData();
    _fetchProfileImageFromFirebase();
  }

  Future<void> pickProfileImage() async {
    DialogUtils.showImageOptionsBottomSheet(
      context: context,
      chooseFromGalleryCallback: () async {
        pick(type: 'GALLERY');
        Navigator.pop(context);
      },
      takeAPictureCallback: () async {
        pick(type: 'CAMERA');
        Navigator.pop(context);
      },
    );
  }

  Future<void> _fetchProfileImageFromFirebase() async {
    try {
      // Fetch the profile image URL from Firebase
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("WholeSaler")
          .doc(uid)
          .get();

      if (userDoc.exists) {
        // Parse the Firestore document into an Admin model
        Admin admin = Admin.fromMap(userDoc.data() as Map<String, dynamic>);

        setState(() {
          _firebaseImageUrl =
              admin.photoUrl; // Use the `photoUrl` from the model
        });
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error fetching profile image: $e");
    }
  }

  // Future<void> _fetchProfileImageFromFirebase() async {
  //   try {
  //     // Fetch the profile image URL from Firebase
  //     String uid = FirebaseAuth.instance.currentUser!.uid;

  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection("WholeSaler")
  //         .doc(uid)
  //         .get();

  //     setState(() {
  //       _firebaseImageUrl = userDoc[
  //           'photoUrl']; // Assuming `photoUrl` is the field in your Firestore document
  //     });
  //   } catch (e) {
  //     print("Error fetching profile image: $e");
  //   }
  // }

  Future<void> pick({required String type}) async {
    AndroidDeviceInfo? androidDeviceInfo;
    if (Platform.isAndroid) {
      androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    }
    PermissionStatus permissionStatus = await PermissionUtil().checkPermission(
        permission: type == 'GALLERY'
            ? (androidDeviceInfo != null &&
                        androidDeviceInfo.version.sdkInt >= 33) ||
                    Platform.isIOS
                ? Permission.photos
                : Permission.storage
            : Permission.camera);
    if (permissionStatus.isGranted) {
      XFile? xFileResult;
      if (type == 'CAMERA') {
        xFileResult = await _picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
        );
      } else if (type == 'GALLERY') {
        xFileResult = await _picker.pickImage(
          source: ImageSource.gallery,
        );
      }
      if (xFileResult != null) {
        setState(() {
          _selectedImage = File(xFileResult!.path);

          isLoading = true; // Update the state with the new image
        });

        // Convert to Uint8List
        Uint8List imageBytes = await xFileResult.readAsBytes();
        // Upload to Firebase
        String output = await cloud().ProfilePic(
          collectionName: "WholeSaler",
          file: imageBytes,
          uid: FirebaseAuth.instance.currentUser!.uid,
        );
        setState(() {
          isLoading = false; // Reset uploading state
        });
        if (output == "success") {
          await _fetchProfileImageFromFirebase();
          Get.snackbar(
            "Success",
            "Profile Picture updated to firebase",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        } else {
          Get.snackbar(
            "Error",
            "Failed to update profile picture to Firebase",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        }
      }
    }
  }

  void showEditNameDialog() {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit name"),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  await adminController.updateAdminName(nameController.text);
                  Get.back();
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void showEditPhoneDialog() {
    TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Phone number"),
          content: TextField(
            controller: phoneController,
            decoration: InputDecoration(hintText: "Enter new Phone"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (phoneController.text.isNotEmpty) {
                  await adminController.updateAdminPhone(phoneController.text);
                  Get.back();
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void showEditPassDialog() {
    TextEditingController passController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Password"),
          content: TextField(
            controller: passController,
            decoration: InputDecoration(hintText: "Enter new Password"),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (passController.text.isNotEmpty) {
                  try {
                    await adminController.updateAdminPass(passController.text);
                    Get.snackbar(
                      'Success',
                      'Password change successfully',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                    Get.back();
                  } catch (e) {
                    print("Error updating password: $e");
                    Get.snackbar(
                      'Error',
                      'Failed to update password. Please try again.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xfff2f2f2),
          title: Text(
            "Profile",
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorsResource.PROFILE_AND_COVER_PIC_BG_COLOR,
                        border: Border.all(
                          color: ColorsResource.WHITE,
                          width: 4,
                        ),
                      ),
                      child: ClipOval(
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                ColorsResource.PROFILE_AND_COVER_PIC_BG_COLOR,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                20,
                              ),
                            ),
                          ),
                          child: isLoading
                              ? Center(
                                  child:
                                      CircularProgressIndicator()) // Show spinner during upload
                              : _selectedImage != null
                                  ? Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                      width: 110,
                                      height: 110,
                                    )
                                  : (_firebaseImageUrl != null
                                      ? Image.network(
                                          _firebaseImageUrl!,
                                          fit: BoxFit.cover,
                                          width: 110,
                                          height: 110,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  SvgPicture.asset(
                                            ImagesResource.PROFILE_ICON,
                                            fit: BoxFit.none,
                                          ),
                                        )
                                      : SvgPicture.asset(
                                          ImagesResource.PROFILE_ICON,
                                          fit: BoxFit.none,
                                        )),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 80,
                      top: 80,
                      child: GestureDetector(
                        child: SvgPicture.asset(
                          ImagesResource.EDIT_IMAGE_ICON,
                          height: 24,
                          width: 24,
                        ),
                        onTap: () {
                          pickProfileImage();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              buildInfoRow(
                "Name",
                adminController.wholesaler.value.Aname,
                showEditNameDialog,
              ),
              buildInfoRow(
                "Phone",
                adminController.wholesaler.value.Aphone,
                showEditPhoneDialog,
              ),
              buildInfoRow(
                "Password",
                adminController.wholesaler.value.Apassword,
                showEditPassDialog,
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () async {
                  bool? logoutResult =
                      await DialogUtils.showLogoutDialog(context: context);
                  if (logoutResult == true && context.mounted) {
                    adminController.logout(context);
                  }
                },
                child: ProfileListItem(
                  text: 'Logout',
                  icondata: Icons.logout,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildInfoRow(
    String title,
    String value,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        Container(
          height: 50,
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blueGrey.shade100,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Row(
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: Colors.blueGrey,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
