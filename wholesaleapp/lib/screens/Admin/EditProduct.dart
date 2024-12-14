import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/ItemController.dart';
import 'package:wholesaleapp/MODELS/ItemModel.dart';
import 'package:wholesaleapp/helper/constant/images_resource.dart';
import 'package:wholesaleapp/widgets/customButton.dart';

import '../../widgets/custom_text_field.dart';

class EditProductScreen extends StatefulWidget {
  final ItemModel product;

  EditProductScreen({required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final ItemController itemController = Get.find<ItemController>();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController weightController;
  late TextEditingController costController;
  late TextEditingController quantityController;
  bool isLoad = false;
  late TextEditingController descriptionController;
  String selectedType = '';
  String selectedWeight = '';
  List<String> productCategories = [
    'Vegetables',
    'Fruits',
    'Beverages',
    'Grocery',
    'Meat',
    'Clean',
    'Frozen',
    'Dry-Fruits'
  ];
  List<String> productWeight = ['kg', 'litre', 'dozen'];
  List<Uint8List> images = [];

  @override
  void initState() {
    super.initState();
    weightController = TextEditingController(text: widget.product.weight);
    nameController = TextEditingController(text: widget.product.itemName);
    costController =
        TextEditingController(text: widget.product.cost.toString());
    quantityController =
        TextEditingController(text: widget.product.quantity.toString());
    descriptionController =
        TextEditingController(text: widget.product.description);
    selectedType = widget.product.type;
    selectedWeight = widget.product.volume; // Initialize selected type
  }

  void selectImage() async {
    try {
      var res = await ImagesResource().pickproducts();
      if (res.isNotEmpty) {
        setState(() {
          images = res;
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

  Future<void> saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoad = true;
      });
      int? parsedQuantity = int.tryParse(quantityController.text);

      if (quantityController.text.isEmpty) {
        // If the quantity is invalid (i.e., not a valid number and not empty), show an error
        Get.snackbar('Error', 'Please enter a valid quantity.');
        return;
      }
      String status = await itemController.updateProductToFirestore(
        weight: weightController.text,
        uid: widget.product.uid,
        productName: nameController.text,
        type: selectedType,
        volume: selectedWeight,
        rawCost: costController.text,
        quantity: parsedQuantity.toString(),
        description: descriptionController.text,
        images: images.isEmpty ? null : images,
      );

      if (status == "success") {
        Get.back();
        setState(() {
          isLoad = false; // Hide the loading indicator
        });
        Get.snackbar(
          "Success", // Title
          "Item updated successfully", // Message
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Error',
          status,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        setState(() {
          isLoad = false; // Hide the loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                CustomTextFormField(
                  controller: nameController,
                  text: "Product Name",
                  obscureText: false,
                  validator: (value) =>
                      value!.isEmpty ? 'Product Name cannot be empty' : null,
                ),
                SizedBox(
                  height: 10,
                ),
                // TextFormField(
                //   controller: nameController,
                //   decoration: InputDecoration(labelText: 'Product Name'),
                //   validator: (value) =>
                //       value!.isEmpty ? 'Product Name cannot be empty' : null,
                // ),
                CustomTextFormField(
                  controller: weightController,
                  text: "Product weight",
                  obscureText: false,
                  validator: (value) =>
                      value!.isEmpty ? 'Product weight cannot be empty' : null,
                ),
                SizedBox(
                  height: 10,
                ),
                // TextFormField(
                //   controller: weightController,
                //   decoration: InputDecoration(labelText: 'Product weight'),
                //   validator: (value) =>
                //       value!.isEmpty ? 'Product weight cannot be empty' : null,
                // ),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items: productCategories.map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedType = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Type',
                    labelStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 16, // Font size for label
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    // Padding inside the field
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      // Rounded corners
                      borderSide: BorderSide(
                          color: Colors.blueAccent,
                          width: 2), // Border color and width
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2), // Border color when focused
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2), // Border color when not focused
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  controller: costController,
                  text: "Cost ",
                  obscureText: false,
                  textInputType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Cost cannot be empty' : null,
                ),
                // TextFormField(
                //   controller: costController,
                //   decoration: InputDecoration(labelText: 'Cost'),
                //   keyboardType: TextInputType.number,
                //   validator: (value) =>
                //       value!.isEmpty ? 'Cost cannot be empty' : null,
                // ),
                SizedBox(
                  height: 10,
                ),
                // Weight dropdown
                DropdownButtonFormField<String>(
                  value: productWeight
                          .contains(widget.product.volume.toLowerCase())
                      ? widget.product.volume.toLowerCase()
                      : null,
                  items: productWeight.map((String volume) {
                    return DropdownMenuItem(
                      value: volume,
                      child: Text(volume),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedWeight =
                          newValue!; // Update the selectedWeight variable
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Volume',
                    labelStyle: TextStyle(
                      color: Colors.blue, // Custom label color
                      fontSize: 16, // Font size for label
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    // Padding inside the field
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      // Rounded corners
                      borderSide: BorderSide(
                          color: Colors.blueAccent,
                          width: 2), // Border color and width
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2), // Border color when focused
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2), // Border color when not focused
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  controller: quantityController,
                  text: "Quantity ",
                  obscureText: false,
                  textInputType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Quantity cannot be empty' : null,
                ),
                // TextFormField(
                //   controller: quantityController,
                //   decoration: InputDecoration(labelText: 'Quantity'),
                //   keyboardType: TextInputType.number,
                //   validator: (value) =>
                //       value!.isEmpty ? 'Quantity cannot be empty' : null,
                // ),
                SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  controller: descriptionController,
                  text: "Description ",
                  obscureText: false,
                  lines: 7,
                  validator: (value) =>
                      value!.isEmpty ? 'Quantity cannot be empty' : null,
                ),
                // TextFormField(
                //   controller: descriptionController,
                //   decoration: InputDecoration(labelText: 'Description'),
                //   maxLines: 3,
                //   validator: (value) =>
                //       value!.isEmpty ? 'description cannot be empty' : null,
                // ),
                SizedBox(height: 20),
                images.isNotEmpty
                    ? Wrap(
                        spacing: 8,
                        children: images.map((img) {
                          return Image.memory(
                            img,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          );
                        }).toList(),
                      )
                    : SizedBox(),
                TextButton.icon(
                  onPressed: selectImage,
                  icon: Icon(Icons.add_photo_alternate),
                  label: Text('Pick Images'),
                ),
                SizedBox(height: 20),
                isLoad
                    ? CircularProgressIndicator()
                    : CustomButton(text: "Save Changes", ontap: saveChanges)
                // ElevatedButton(
                //   onPressed: saveChanges,
                //   child: Text('Save Changes'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
