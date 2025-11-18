import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'http://localhost:8083/api/v1';

  final http.Client _client;
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<http.Response> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final defaultHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };
    return _client.post(uri, headers: defaultHeaders, body: body);
  }

  Future<http.Response> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final defaultHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };
    return _client.get(uri, headers: defaultHeaders);
  }

  static String encode(Map<String, dynamic> data) => jsonEncode(data);
  static Map<String, dynamic> decode(String body) => jsonDecode(body);
}
