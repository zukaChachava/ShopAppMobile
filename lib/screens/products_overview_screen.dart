import 'package:flutter/material.dart';
import 'package:shop_app/widgets/product_item.dart';
import '../models/prodact_model.dart';
import '../widgets/products_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static const route = '/';

  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
      ),
      body: const ProductsGrid(),
    );
  }
}
