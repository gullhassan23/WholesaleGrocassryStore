import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:intl/intl.dart';
import 'package:wholesaleapp/helper/constant/colors_resource.dart';

import '../constant/images_resource.dart';

class DialogUtils {
  String formatDate(dynamic date) {
    try {
      DateTime parsedDate;

      if (date is String) {
        // Adjust the input format as per your date string
        parsedDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
      } else if (date is Timestamp) {
        // If it's a Firebase Timestamp
        parsedDate = date.toDate();
      } else if (date is DateTime) {
        // If it's already a DateTime object
        parsedDate = date;
      } else {
        throw 'Invalid date type';
      }

      // Format the date to the desired output
      return DateFormat('d MMMM yyyy').format(parsedDate);
    } catch (e) {
      // Handle errors if the date format is invalid
      return 'Invalid date';
    }
  }

  String stID =
      "pk_test_51LYvOaG5oJVKdCdohaq2PoZRQfiMsxnFxdMXEKRRejxqi3J47f9ayTmrPHIWEelgADGiL9ZrysBM5TsMeUJg4LPS00urKX4NBZ";
  static Future<bool?> showLogoutDialog(
      {required BuildContext context,
      Function()? onRetry,
      bool hideRetry = false}) async {
    return await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 22),
                  width: width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(18))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Logout',
                        style:
                            TextStyle(fontWeight: FontWeight.w800, height: 1),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Are you sure you want to exit the app?',
                        style:
                            TextStyle(fontWeight: FontWeight.w300, height: 1),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Container(
                              padding: EdgeInsets.all(16) -
                                  EdgeInsets.only(bottom: 16),
                              child: Text(
                                'No',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, height: 1),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Container(
                              padding: EdgeInsets.all(16) -
                                  EdgeInsets.only(bottom: 16),
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                  color: ColorsResource.PRIMARY_COLOR,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }

  // static Future<dynamic> showEditPhoneDialog(
  //   BuildContext context,
  //   VoidCallback? onPressed,
  // ) {
  //   TextEditingController phoneController = TextEditingController();

  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Edit Phone number"),
  //         content: TextField(
  //           controller: phoneController,
  //           keyboardType: TextInputType.phone,
  //           decoration: InputDecoration(hintText: "Enter new Phone"),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Get.back();
  //             },
  //             child: Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: onPressed,
  //             child: Text("Save"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

 

  static Future<dynamic> showImageOptionsBottomSheet({
    required BuildContext context,
    required VoidCallback chooseFromGalleryCallback,
    required VoidCallback takeAPictureCallback,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorsResource.WHITE,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (BuildContext bottomSheetContext) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.20,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 12.h,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 4.h,
                    width: 47.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.r),
                      color: ColorsResource.LIGHT_GREY_2,
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                CustomImageSelection(
                  icon: ImagesResource.GALLERY_ICON,
                  text: 'Choose from Gallery',
                  callback: chooseFromGalleryCallback,
                ),
                SizedBox(height: 25.h),
                CustomImageSelection(
                  icon: ImagesResource.CAMERA_ICON,
                  text: 'Take a Picture',
                  callback: takeAPictureCallback,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomImageSelection extends StatelessWidget {
  const CustomImageSelection({
    super.key,
    required this.icon,
    required this.text,
    required this.callback,
  });

  final String icon;
  final String text;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback, // Invoke the callback when tapped
      child: Row(
        children: [
          SizedBox(
            height: 24.h,
            width: 24.w,
            child: SvgPicture.asset(icon),
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(height: 1, color: ColorsResource.COLOR_GREY),
          ),
        ],
      ),
    );
  }
}
