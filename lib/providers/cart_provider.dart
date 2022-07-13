import 'package:flutter/widgets.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/product_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items;

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, value) {
      total += value.price + value.quantity;
    });

    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
          (existingOne) => CartItem(
              id: existingOne.id,
              title: existingOne.title,
              quantity: existingOne.quantity + 1,
              price: existingOne.price));
    } else {
      _items.putIfAbsent(
          product.id,
          () => CartItem(
              id: DateTime.now().toString(),
              title: product.title,
              quantity: 1,
              price: product.price));
    }
    notifyListeners();
  }

  CartProvider() : _items = {};
}
