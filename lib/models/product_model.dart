import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/http/clients/firebase_client.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  final FirebaseClient _client;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavourite = false})
      : _client = FirebaseClient();

  Future<void> toggleFavourite() async {
    final url =
        'https://flutterapp-6e0db-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json';

    await _client.client.patch(Uri.parse(url),
        body: json.encode({'isFavourite': !isFavourite}));
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
