import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/http/clients/firebase_client.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseClient _firebaseClient;
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTime;

  AuthProvider() : _firebaseClient = FirebaseClient();

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> signUp(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyApkikiAiGVxsbq1LgS-lXGHhrBFEGRo70';

    final response = await _firebaseClient.client.post(Uri.parse(url),
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));

    print(json.decode(response.body));
  }

  Future<void> signIn(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyApkikiAiGVxsbq1LgS-lXGHhrBFEGRo70';

    final response = await _firebaseClient.client.post(Uri.parse(url),
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));

    final responseBody = json.decode(response.body);

    _token = responseBody['idToken'];
    _userId = responseBody['localId'];
    _expiryDate = DateTime.now()
        .add(Duration(seconds: int.parse(responseBody['expiresIn'])));

    _autoLogout();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("TOKEN", _token!);
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTime != null) {
      _authTime!.cancel();
      _authTime = null;
    }
    notifyListeners();
    SharedPreferences.getInstance().then((value) => value.remove("TOKEN"));
  }

  void _autoLogout() {
    if (_authTime != null) {
      _authTime!.cancel();
    }

    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTime = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
