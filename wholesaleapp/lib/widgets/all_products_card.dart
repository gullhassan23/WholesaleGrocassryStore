// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wholesaleapp/Controllers/ItemController.dart';
import 'package:wholesaleapp/MODELS/ItemModel.dart';
import 'package:wholesaleapp/helper/constant/colors_resource.dart';
import 'package:wholesaleapp/screens/homeScreen/product_screen.dart';

class AllProductsCard extends StatelessWidget {
  final ItemController itemController = Get.put(ItemController());

  final ItemModel itemModel;
  AllProductsCard({
    Key? key,
    required this.itemModel,
  }) : super(key: key);

  // List<ProductModel> demoPopularProducts = [
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        itemController.fetchProductData();
        Get.to(() => ProductScreen(
              itemModel: itemModel,
            ));
      },
      child: Card(
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Image.network(
                itemModel.imageUrls[0],
                // 'https://i.imgur.com/CGCyp1d.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '\$ ${itemModel.cost.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: ColorsResource.PRIMARY_COLOR,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text('${itemModel.itemName}'),
                  const SizedBox(height: 8.0),
                  Text('${itemModel.weight} ${itemModel.volume}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
