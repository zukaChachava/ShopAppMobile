import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  static const route = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(children: [
        Card(
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
                ]),
          ),
        )
      ]),
    );
  }
}
