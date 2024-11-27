import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Controllers/distribController.dart';
import '../../helper/constant/colors_resource.dart';
import '../../helper/constant/images_resource.dart';
import '../../helper/utils/dialog_utils.dart';
import '../../helper/utils/permission_utils.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserController userController = Get.put(UserController());
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
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
      body: Column(
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
                        color: ColorsResource.PROFILE_AND_COVER_PIC_BG_COLOR,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            20,
                          ),
                        ),
                      ),
                      child: SvgPicture.asset(
                        ImagesResource.PROFILE_ICON,
                        fit: BoxFit.none,
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
          ProfileListItem(text: 'Sheikh Faizan'),
          ProfileListItem(text: 'Fazanmuzamal89@gmail.com'),
          ProfileListItem(text: '03244985570'),
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () async {
              bool? logoutResult =
                  await DialogUtils.showLogoutDialog(context: context);
              if (logoutResult == true && context.mounted) {
                logoutUser();
              }
            },
            child: ProfileListItem(text: 'Logout'),
          ),
        ],
      ),
    );
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
    }
  }

  Future<void> logoutUser() async {
    if (context.mounted) {
      userController.logout(context);
    }
    // if (networkStatusService.networkStatus == NetworkStatus.ONLINE) {
    //   if (context.mounted) {
    //     userController.logout(context);
    //   }
    // } else {
    //   if (context.mounted) {
    //     //DialogUtils.showNoInternetDialog(context: context, onRetry: logoutUser);
    //   }
    // }
  }
}

class ProfileListItem extends StatelessWidget {
  final String text;
  final bool hasNavigation;

  const ProfileListItem({
    required this.text,
    this.hasNavigation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          margin: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Color(0xFFdcf3ff),
          ),
          child: Row(
            children: <Widget>[
              Text(
                this.text,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              Spacer(),
              if (this.hasNavigation)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.blueGrey,
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
