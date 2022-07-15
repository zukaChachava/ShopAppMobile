import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import '../models/product_model.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context,
        listen: false); // Not listening to changes here
    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, favProduct, _) => IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: Icon(favProduct.isFavourite
                  ? Icons.favorite
                  : Icons.favorite_outline_outlined),
              onPressed: () {
                favProduct.toggleFavourite();
              },
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              cartProvider.addItem(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Added item to cart'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cartProvider.removeSingleItem(product.id);
                    }),
              ));
            },
          ),
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailsScreen.route, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
