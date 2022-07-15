import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart_item_model.dart';
import 'package:shop_app/providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final CartItemModel cartItemModel;

  const CartItem({required this.cartItemModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData qyeryData = MediaQuery.of(context);

    return Dismissible(
      key: ValueKey(cartItemModel.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false)
            .removeItem(cartItemModel.id);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('Are you sure ?'),
                content: const Text(
                    'Do you want to remove the item from the cart ?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Yes'),
                  )
                ],
              );
            });
      },
      child: Card(
        margin: EdgeInsets.all(qyeryData.size.width * 0.01),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: FittedBox(child: Text(cartItemModel.price.toString())),
            ),
          ),
          title: Text(cartItemModel.title),
          subtitle:
              Text('Total: ${cartItemModel.price * cartItemModel.quantity}'),
          trailing: Text('${cartItemModel.quantity}x'),
        ),
      ),
    );
  }
}
