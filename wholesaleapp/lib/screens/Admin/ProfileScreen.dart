import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wholesaleapp/Controllers/AdminController.dart';
import 'package:wholesaleapp/helper/cloudResources/CloudMethod.dart';
import 'package:wholesaleapp/helper/constant/images_resource.dart';
import 'package:wholesaleapp/helper/utils/dialog_utils.dart';

import '../../widgets/profile_list_items.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Admincontroller adminController = Get.put(Admincontroller());

  @override
  void initState() {
    super.initState();
    adminController.fetchWholeSaleData();
  }

  Uint8List? image;

  void selectImage() async {
    User currentUser = _auth.currentUser!;
    Uint8List im = await ImagesResource().pickImage(ImageSource.gallery);

    setState(() {
      image = im;
    });

    String output =
        await cloud().ProfilePic(file: image!, uid: currentUser.uid);
    if (output == "success") {
      Get.snackbar(
        "Posted Profile Picture", // Title
        output, // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        "Profile picture not posted", // Title
        output, // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
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
                    image != null
                        ? CircleAvatar(
                            radius: 64, backgroundImage: MemoryImage(image!))
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage:
                                AssetImage("assets/images/image1.png")),
                    Positioned(
                      top: 93,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    )
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
