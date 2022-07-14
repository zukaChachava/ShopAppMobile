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
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItemModel.amount}'),
            subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(widget.orderItemModel.date),
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
          if (_expanded)
            Container(
              height:
                  min(widget.orderItemModel.products.length * 20 + 100, 180),
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
    );
  }
}
