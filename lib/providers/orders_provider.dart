import 'package:flutter/widgets.dart';
import 'package:shop_app/models/order_item_model.dart';

import '../models/cart_item_model.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderItemModel> _orders = [];

  List<OrderItemModel> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItemModel> cartProducts) {
    _orders.insert(
        0,
        OrderItemModel(
            id: DateTime.now().toString(),
            amount: _countAmount(cartProducts),
            products: cartProducts,
            date: DateTime.now()));
  }

  double _countAmount(List<CartItemModel> cartProducts) {
    double total = 0;
    cartProducts.forEach((element) {
      total += element.price * element.quantity;
    });
    return total;
  }
}
