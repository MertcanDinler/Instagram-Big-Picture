import 'dart:async';
import 'package:http/http.dart' as http;

class NetworkUtil {
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  Future<String> get(String url) async {
    final response = await http.get(Uri.encodeFull(url),
        headers: {'Content-Type': 'application/json'});
    return response.body;
  }
}
