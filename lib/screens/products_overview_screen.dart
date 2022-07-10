import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_item.dart';
import '../models/product_model.dart';
import '../widgets/products_grid.dart';

enum FilterOptions{
  favourites,
  all
}


class ProductsOverviewScreen extends StatefulWidget {
  static const route = '/';

  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavourites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions options) {
              setState(() {
                if(options == FilterOptions.favourites){
                _showOnlyFavourites = true;
                return;
              }
                _showOnlyFavourites = false;
              });
              
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: FilterOptions.favourites, child:  Text('Only Favourites'),),
              const PopupMenuItem(value: FilterOptions.all, child:  Text('Show All'),),
            ], 
            icon: const Icon(Icons.more_vert),)
        ],
      ),
      body: ProductsGrid(showOnlyFavourites: _showOnlyFavourites),
    );
  }
}
