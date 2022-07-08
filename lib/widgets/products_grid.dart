import 'package:flutter/material.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../models/prodact_model.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final List<Product> loadedProducts =
        Provider.of<ProductsProvider>(context).products;

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: mediaQuery.size.width * 0.02,
        vertical: mediaQuery.size.height * 0.02,
      ),
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, i) => ProductItem(product: loadedProducts[i]),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: mediaQuery.size.width < 381 ? 1 : 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: mediaQuery.size.width * 0.05,
          mainAxisSpacing: mediaQuery.size.height * 0.05),
    );
  }
}
