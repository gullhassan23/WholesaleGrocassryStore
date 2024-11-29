import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wholesaleapp/Controllers/AdminController.dart';

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
  TextEditingController phoneController = TextEditingController();

  final Admincontroller adminController = Get.put(Admincontroller());

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
                          child: _selectedImage == null
                              ? SvgPicture.asset(
                                  ImagesResource.PROFILE_ICON,
                                  fit: BoxFit.none,
                                )
                              : Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                  width: 80, // Adjust width/height as needed
                                  height: 80,
                                ),
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
                child: ProfileListItem(text: 'Logout'),
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
          _selectedImage =
              File(xFileResult!.path); // Update the state with the new image
        });
      }
    }
  }
}
