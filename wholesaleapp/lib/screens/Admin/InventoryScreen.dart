import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import "package:dotted_border/dotted_border.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/AdminController.dart';
import 'package:wholesaleapp/Controllers/ItemController.dart';
import 'package:wholesaleapp/helper/constant/images_resource.dart';
import 'package:wholesaleapp/widgets/customButton.dart';
import 'package:wholesaleapp/widgets/custom_text_field.dart';

class InventoryScreen extends StatefulWidget {
  static const String routeName = "/add-product";
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final ItemController itemController = ItemController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final Admincontroller adminController = Get.put(Admincontroller());

  // Change to store a single image
  List<Uint8List> image = [];

  String category = 'Fruits';
  List<String> productCategories = [
    'Fruits',
    'Vegitables',
    'MEAT',
    'Grocessary',
    'Beverages',
    'Cleaner',
    'Dry-Fruits',
    'Frozen'
  ];

  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void selectImage() async {
    try {
      var res = await ImagesResource().pickproducts();
      if (res.isNotEmpty) {
        setState(() {
          image = res; // Store only the first image
        });
      } else {
        Get.snackbar('No Image Selected', 'Please select an image to proceed.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {},
          child: Text("Inventory Screen", style: TextStyle(fontSize: 20.sp)),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                // Display the single image if picked

                image.isNotEmpty
                    ? CarouselSlider(
                        items: image.map(
                          (i) {
                            return Builder(
                              builder: (BuildContext context) => Image.memory(
                                i,
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImage,
                        child: DottedBorder(
                            color: Colors.brown,
                            borderType: BorderType.RRect,
                            radius: Radius.circular(10),
                            dashPattern: [10, 4],
                            strokeCap: StrokeCap.round,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.folder_open,
                                    color: Colors.brown,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Select Product Images",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.brown,
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                SizedBox(height: 30.h),
                CustomTextFormField(
                  controller: productNameController,
                  text: "Item Name",
                  obscureText: false,
                ),
                SizedBox(height: 10.h),
                CustomTextFormField(
                  controller: descriptionController,
                  text: "Description",
                  lines: 7,
                  obscureText: false,
                ),
                SizedBox(height: 10.h),
                CustomTextFormField(
                  controller: priceController,
                  text: "Price",
                  obscureText: false,
                ),
                SizedBox(height: 10.h),
                CustomTextFormField(
                  controller: quantityController,
                  text: "Quantity",
                  obscureText: false,
                ),
                SizedBox(height: 10.h),
                SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                      isExpanded: true,
                      dropdownColor: Color(0xfff2f2f2),
                      value: category,
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: productCategories.map((String item) {
                        return DropdownMenuItem(
                          child: Text(
                            item,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (String? newVal) {
                        if (newVal != null) {
                          setState(() {
                            category = newVal;
                          });
                        }
                      },
                    )),
                SizedBox(height: 20.h),
                CustomButton(
                    text: "Add to stock",
                    ontap: () async {
                      String output = await itemController.productToFirestore(
                        type: category,
                        quantity: quantityController.text,
                        productName: productNameController.text,
                        rawCost: priceController.text,
                        description: descriptionController.text,
                        images: image, // Pass single image in list
                      );
                      if (output == "success") {
                        Get.snackbar(
                          "Posted Item", // Title
                          output, // Message
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          duration: Duration(seconds: 3),
                        );
                      } else {
                        Get.snackbar(
                          "Error", // Title
                          output, // Message
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          duration: Duration(seconds: 3),
                        );
                      }
                    }),
                SizedBox(
                  height: 10.h,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
