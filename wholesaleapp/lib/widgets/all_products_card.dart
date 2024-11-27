import 'package:flutter/material.dart';
import 'package:wholesaleapp/helper/constant/colors_resource.dart';

import '../MODELS/product_model.dart';
import '../screens/homeScreen/product_screen.dart';

class AllProductsCard extends StatelessWidget {
  AllProductsCard({
    super.key,
  });

  List<ProductModel> demoPopularProducts = [
    ProductModel(
        image: "https://i.imgur.com/CGCyp1d.png",
        price: 650.62,
        productName: 'Orange',
        qty: '10 pieces'),
    ProductModel(
        image: "https://i.imgur.com/AkzWQuJ.png",
        price: 1264,
        productName: 'Chicken',
        qty: '25 pieces'),
    ProductModel(
        image: "https://i.imgur.com/J7mGZ12.png",
        price: 650.62,
        productName: 'Orange',
        qty: '11 pieces'),
    ProductModel(
        image: "https://i.imgur.com/q9oF9Yq.png",
        price: 1264,
        productName: 'Chicken',
        qty: '5 pieces'),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 7.0 / 9.0,
          crossAxisSpacing: 8,
          mainAxisSpacing: 15,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            ProductModel product = demoPopularProducts[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductScreen(product: product)),
                );
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
                        product.image,
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
                            '\$ ${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: ColorsResource.PRIMARY_COLOR,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text('${demoPopularProducts[index].productName}'),
                          const SizedBox(height: 8.0),
                          Text(product.qty),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: demoPopularProducts.length,
        ),
      ),
    );
  }
}
