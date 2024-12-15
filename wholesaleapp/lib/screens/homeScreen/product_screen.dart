import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/CartController.dart';
import 'package:wholesaleapp/Controllers/ItemController.dart';
import 'package:wholesaleapp/MODELS/ItemModel.dart';
import 'package:wholesaleapp/helper/constant/colors_resource.dart';

class ProductScreen extends StatefulWidget {
  final ItemModel itemModel;

  const ProductScreen({
    Key? key,
    required this.itemModel,
  }) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  CartController cartController = Get.put(CartController());
  ItemController itemController = Get.put(ItemController());
  int quantity = 0;
  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    // ProductModel product = widget.product;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Image.network(
                widget.itemModel.imageUrls[0],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  widget.itemModel.itemName,
                  style:
                      TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                ),
                // Spacer(),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 40.h,
                width: 200.w,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      widget.itemModel.quantity > 0 ? Colors.blue : Colors.red,
                ),
                child: Center(
                  child: Text(
                    widget.itemModel.quantity > 0
                        ? 'Available in stock'
                        : 'Out of stock',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'QR ${widget.itemModel.cost.toString()}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.itemModel.weight} ${widget.itemModel.volume}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${widget.itemModel.description}',
              // product.description ?? '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            // SizedBox(
            //   height: 150.h,
            // ),
            Spacer(),
            Container(
              // color: Colors.blueGrey,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.itemModel.quantity == 0
                        ? Colors.grey
                        : Colors.blue,
                    fixedSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: BorderSide(color: ColorsResource.PRIMARY_COLOR),
                    ),
                  ),
                  onPressed: widget.itemModel.quantity == 0
                      ? () {
                          SizedBox();
                        }
                      : () async {
                          setState(() {
                            isLoad = true; // Show the loading indicator
                          });
                          await cartController.addToCart(widget.itemModel);
                          setState(() {
                            isLoad = false; // Hide the loading indicator
                          });
                          if (cartController.addTocartStatus.value ==
                              "success") {
                            Get.snackbar(
                              "Sucess",
                              "Your item added to cart",
                              backgroundColor: Colors.green,
                              snackPosition: SnackPosition.BOTTOM,
                              colorText: Colors.white,
                              duration: Duration(seconds: 3),
                            );

                            // Get.to(() => CartScreen());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text(cartController.addTocartStatus.value),
                              ),
                            );
                          }
                        },
                  child: isLoad
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Add to cart',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ), // Optional content
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
