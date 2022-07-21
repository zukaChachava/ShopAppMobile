import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shop_app/http/clients/firebase_client.dart';
import 'package:shop_app/models/order_item_model.dart';
import 'package:http/http.dart' as http;

import '../models/cart_item_model.dart';
import '../widgets/order_item.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderItemModel> _orders = [];
  final FirebaseClient _client;

  OrdersProvider() : _client = FirebaseClient();

  List<OrderItemModel> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url =
        'https://flutterapp-6e0db-default-rtdb.europe-west1.firebasedatabase.app/orders.json';
    final response = await _client.client.get(Uri.parse(url));
    final List<OrderItemModel> loadedOrders = [];

    if (json.decode(response.body) == null) return;

    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItemModel(
          date: DateTime.parse(orderData['date']),
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItemModel(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItemModel> cartProducts) async {
    const url =
        'https://flutterapp-6e0db-default-rtdb.europe-west1.firebasedatabase.app/orders.json';
    final timestamp = DateTime.now();
    double total = 0;

    for (var item in cartProducts) {
      total += item.price * item.quantity;
    }

    await _client.client.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'date': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );

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
