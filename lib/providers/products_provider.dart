import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/http/clients/firebase_client.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  final List<Product> _products = [];
  final FirebaseClient _client;

  ProductsProvider() : _client = FirebaseClient();

  Future<void> fetchAndSetProducts() async {
    const url =
        'https://flutterapp-6e0db-default-rtdb.europe-west1.firebasedatabase.app/products.json';

    var response = json.decode((await _client.client.get(Uri.parse(url))).body);

    if (response == null) return;

    var data = response as Map<String, dynamic>;

    final List<Product> products = [];
    data.forEach((key, value) {
      products.add(Product(
          id: key,
          price: value['price'],
          title: value['title'],
          description: value['description'],
          imageUrl: value['imageUrl'],
          isFavourite: value['isFavourite']));
    });
    _products.clear();
    _products.addAll(products);
    notifyListeners();
  }

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favouriteProducts {
    return _products.where((element) => element.isFavourite).toList();
  }

  Future<void> addProduct(Product product) async {
    const url =
        'https://flutterapp-6e0db-default-rtdb.europe-west1.firebasedatabase.app/products.json';

    await _client.client.post(Uri.parse(url),
        body: json.encode({
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'description': product.description,
          'isFavourite': product.isFavourite
        }));
    Product newProduct = Product(
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        id: DateTime.now().toString());
    _products.add(newProduct);
    notifyListeners();
  }

  Product findById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    int index = _products.indexWhere((element) => element.id == id);

    if (index < 0) return;

    final url =
        'https://flutterapp-6e0db-default-rtdb.europe-west1.firebasedatabase.app/products/${products[index].id}.json';

    await _client.client.patch(Uri.parse(url),
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price
        }));

    _products[index] = newProduct;
    notifyListeners();
  }

  void delete(String id) async {
    int index = _products.indexWhere((element) => element.id == id);
    if (index < 0) return;

    final url =
        'https://flutterapp-6e0db-default-rtdb.europe-west1.firebasedatabase.app/products/${products[index].id}.json';

    await _client.client.delete(Uri.parse(url));
    _products.removeAt(index);
    notifyListeners();
  }
}
