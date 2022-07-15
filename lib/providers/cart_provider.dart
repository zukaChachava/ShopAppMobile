import 'package:flutter/widgets.dart';
import 'package:shop_app/models/cart_item_model.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/screens/product_details_screen.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItemModel> _items;

  Map<String, CartItemModel> get items {
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
          (existingOne) => CartItemModel(
              id: existingOne.id,
              title: existingOne.title,
              quantity: existingOne.quantity + 1,
              price: existingOne.price));
    } else {
      _items.putIfAbsent(
          product.id,
          () => CartItemModel(
              id: DateTime.now().toString(),
              title: product.title,
              quantity: 1,
              price: product.price));
    }
    notifyListeners();
  }

  void removeItem(String cartId) {
    String? productId;

    _items.forEach((key, value) {
      if (value.id == cartId) {
        productId = key;
        return;
      }
    });

    if (productId != null) {
      _items.remove(productId);
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (old) => CartItemModel(
              id: old.id,
              title: old.title,
              quantity: old.quantity - 1,
              price: old.price));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  CartProvider() : _items = {};
}
