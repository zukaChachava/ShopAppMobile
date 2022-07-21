import 'dart:convert';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("TOKEN");
    if (token != null) {
      data.params['auth'] = token;
    }
    print(data.params);
    return Future.value(data);
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) {
    print(json.decode(data.body!).toString());
    return Future.value(data);
  }
}
