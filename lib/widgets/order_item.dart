import 'package:flutter/material.dart';
import 'package:shop_app/models/order_item_model.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final OrderItemModel orderItemModel;

  const OrderItem({required this.orderItemModel, Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded
          ? min(widget.orderItemModel.products.length * 40 + 120, 200)
          : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.orderItemModel.amount}'),
              subtitle: Text(
                DateFormat('dd MM yyyy hh:mm')
                    .format(widget.orderItemModel.date),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _expanded ? 20 : 0,
              child: ListView(
                  children: widget.orderItemModel.products
                      .map((product) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(product.title),
                              Text('${product.quantity}x'),
                              Text('\$${product.price}'),
                            ],
                          ))
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
