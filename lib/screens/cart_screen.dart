import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/widgets/cart-item.dart';

class CartScreen extends StatelessWidget {
  static const route = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: double.infinity,
            height: queryData.size.height * 0.2,
            child: Card(
              margin: EdgeInsets.all(queryData.size.width * 0.05),
              child: Container(
                padding: EdgeInsets.all(queryData.size.width * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Consumer<CartProvider>(
                      builder: (context, value, child) {
                        return Chip(label: Text(value.totalAmount.toString()));
                      },
                    ),
                    TextButton(
                        onPressed: () {
                          Provider.of<OrdersProvider>(context, listen: false)
                              .addOrder(cartProvider.items.values.toList());
                          cartProvider.clear();
                        },
                        child: const Text('Order'))
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: queryData.size.height * 0.6,
            child: Consumer<CartProvider>(builder: (context, cart, child) {
              return ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, index) =>
                    CartItem(cartItemModel: cart.items.values.toList()[index]),
              );
            }),
          )
        ],
      ),
    );
  }
}
