import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shop_app/http/interceptors/token_interceptor.dart';

class FirebaseClient {
  static final FirebaseClient _firebaseClient = FirebaseClient._internal();
  late Client client;

  factory FirebaseClient() {
    // singleton pattern
    return _firebaseClient;
  }

  FirebaseClient get _client {
    return _firebaseClient;
  }

  FirebaseClient._internal() {
    client = InterceptedClient.build(interceptors: [TokenInterceptor()]);
  }
}
