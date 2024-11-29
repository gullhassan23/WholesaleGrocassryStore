import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/ItemController.dart';
import 'package:wholesaleapp/MODELS/ItemModel.dart';
import 'package:wholesaleapp/helper/constant/images_resource.dart';

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
  late TextEditingController costController;
  late TextEditingController quantityController;
  late TextEditingController descriptionController;
  String selectedType = ''; // For dropdown
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
  List<Uint8List> images = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.itemName);
    costController =
        TextEditingController(text: widget.product.cost.toString());
    quantityController =
        TextEditingController(text: widget.product.quantity.toString());
    descriptionController =
        TextEditingController(text: widget.product.description);
    selectedType = widget.product.type; // Initialize selected type
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
      String status = await itemController.updateProductToFirestore(
        uid: widget.product.uid,
        productName: nameController.text,
        type: selectedType, // Use dropdown value
        rawCost: costController.text,
        quantity: quantityController.text,
        description: descriptionController.text,
        images: images.isEmpty ? null : images,
      );

      if (status == "success") {
        Get.back();
        Get.snackbar('Success', 'Product updated successfully');
      } else {
        Get.snackbar('Error', status);
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Product Name cannot be empty' : null,
              ),
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
                decoration: InputDecoration(labelText: 'Type'),
              ),
              TextFormField(
                controller: costController,
                decoration: InputDecoration(labelText: 'Cost'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Cost cannot be empty' : null,
              ),
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Quantity cannot be empty' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
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
              ElevatedButton(
                onPressed: saveChanges,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
