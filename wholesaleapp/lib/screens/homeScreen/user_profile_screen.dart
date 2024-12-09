import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wholesaleapp/Controllers/AdminController.dart';
import 'package:wholesaleapp/helper/cloudResources/CloudMethod.dart';

import '../../Controllers/distribController.dart';
import '../../helper/constant/colors_resource.dart';
import '../../helper/constant/images_resource.dart';
import '../../helper/utils/dialog_utils.dart';
import '../../helper/utils/permission_utils.dart';
import '../../widgets/profile_list_items.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserController userController = Get.put(UserController());
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _firebaseImageUrl;
  bool _isUploading = false;
  TextEditingController phoneController = TextEditingController();

  final Admincontroller adminController = Get.put(Admincontroller());

  @override
  void initState() {
    super.initState();
    _fetchProfileImageFromFirebase();
  }

  Future<void> _fetchProfileImageFromFirebase() async {
    try {
      // Fetch the profile image URL from Firebase
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("Distributors")
          .doc(uid)
          .get();

      setState(() {
        _firebaseImageUrl = userDoc[
            'photoUrl']; // Assuming `photoUrl` is the field in your Firestore document
      });
    } catch (e) {
      print("Error fetching profile image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          backgroundColor: Colors.white,
          toolbarHeight: 40,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
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
                          child: _isUploading
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
                          _pickProfileImage();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ProfileListItem(text: userController.distributer.value.name),
              ProfileListItem(text: userController.distributer.value.email),
              ProfileListItem(
                text: userController.distributer.value.phone,
                icondata: Icons.arrow_forward_ios,
                onPressed: () {
                  DialogUtils.showEditPhoneDialog(context, () async {
                    if (phoneController.text.isNotEmpty) {
                      await userController
                          .updateUserPhone(phoneController.text);
                      Get.back();
                    }
                  });
                },
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

  Future<void> _pickProfileImage() async {
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

          _isUploading = true; // Update the state with the new image
        });

        // Convert to Uint8List
        Uint8List imageBytes = await xFileResult.readAsBytes();
        // Upload to Firebase
        String output = await cloud().ProfilePic(
          collectionName: "Distributors",
          file: imageBytes,
          uid: FirebaseAuth.instance.currentUser!.uid,
        );
        setState(() {
          _isUploading = false; // Reset uploading state
        });
        if (output == "success") {
          await _fetchProfileImageFromFirebase();
          Get.snackbar(
            "Success",
            "Profile picture has successfully been updated",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        } else {
          Get.snackbar(
            "Error",
            "Failed to update profile picture.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        }
      }
    }
  }
}
