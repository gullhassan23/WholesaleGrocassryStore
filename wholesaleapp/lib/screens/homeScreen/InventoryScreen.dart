import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import "package:dotted_border/dotted_border.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/AdminController.dart';
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
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final Admincontroller adminController = Get.put(Admincontroller());

  List<Uint8List> images = [];
  String? selectedCategory;
  String? selectedSubCategory;

  final Map<String, List<String>> categories = {
    'Frozen': ['Fruits', 'Vegetables', 'Meat'],
    'UnFrozen': ['Fruits', 'Vegetables', 'Meat'],
  };

  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void selectImages() async {
    try {
      var res = await ImagesResource().pickproducts();
      if (res.isNotEmpty) {
        setState(() {
          images = res;
        });
      } else {
        Get.snackbar('No Images Selected', 'Please select images to proceed.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
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
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images.map((i) {
                          return Builder(
                            builder: (BuildContext context) => Image.memory(
                              i,
                              fit: BoxFit.cover,
                              height: 200.h,
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200.h,
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          color: Colors.brown,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(10.r),
                          dashPattern: [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_open,
                                    color: Colors.brown, size: 40.sp),
                                SizedBox(height: 15.h),
                                Text(
                                  "Select item Images",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.brown,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
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
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    hint: Text('Select Category',
                        style: TextStyle(fontSize: 14.sp)),
                    items: categories.keys.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child:
                            Text(category, style: TextStyle(fontSize: 14.sp)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                        selectedSubCategory = null;
                      });
                    },
                    icon: Icon(Icons.arrow_drop_down, size: 24.sp),
                    alignment: AlignmentDirectional.centerEnd,
                  ),
                ),
                SizedBox(height: 20.h),
                if (selectedCategory != null &&
                    categories[selectedCategory] != null)
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButton<String>(
                      value: selectedSubCategory,
                      isExpanded: true,
                      hint: Text('Select Subcategory',
                          style: TextStyle(fontSize: 14.sp)),
                      items: categories[selectedCategory]!
                          .map((String subCategory) {
                        return DropdownMenuItem<String>(
                          value: subCategory,
                          child: Text(subCategory,
                              style: TextStyle(fontSize: 14.sp)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSubCategory = value;
                        });
                      },
                      icon: Icon(Icons.arrow_drop_down, size: 24.sp),
                      alignment: AlignmentDirectional.centerEnd,
                    ),
                  ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: "Add to stock",
                  ontap: () async {
                    if (images.isEmpty) {
                      Get.snackbar('Error', 'Please add product images.',
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }
                    Get.snackbar('Success', 'Product posted successfully!',
                        snackPosition: SnackPosition.BOTTOM);
                  },
                ),
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
