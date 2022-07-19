import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/custom_drawer.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { favourites, all }

class ProductsOverviewScreen extends StatefulWidget {
  static const route = '/';

  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavourites = false;
  bool _isLoading = false;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProducts();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions options) {
              setState(() {
                if (options == FilterOptions.favourites) {
                  _showOnlyFavourites = true;
                  return;
                }
                _showOnlyFavourites = false;
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favourites,
                child: Text('Only Favourites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show All'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<CartProvider>(
            builder: (_, cartData, child) {
              return Badge(
                value: cartData.itemCount.toString(),
                color: Theme.of(context).colorScheme.secondary,
                child: child!,
              );
            },
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.route);
              },
            ),
          )
        ],
      ),
      drawer: const CustomDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductsGrid(showOnlyFavourites: _showOnlyFavourites),
    );
  }
}
