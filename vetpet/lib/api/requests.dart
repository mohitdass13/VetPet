import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vetpet/api/user.dart';

abstract class Requests {
  static String host = 'localhost:8080';
  static String baseUrl = "/api";

  static Future<Map<String, dynamic>> postJson(
      String route, Map<String, dynamic> data,
      {bool authorization = false}) async {
    String message = 'Unknown error';
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (authorization) {
      headers['email'] = CurrentUser.userEmail!;
      headers['authorization'] = CurrentUser.userKey!;
    }
    try {
      http.Response response = await http.post(
        Uri.http(host, '$baseUrl$route'),
        headers: headers,
        body: jsonEncode(data),
      );
      message = response.body;
      if (response.statusCode == 200) {
        return {"success": true, 'response': message};
      }
    } catch (_) {}
    return {"success": false, 'response': message};
  }

  static Future<Map<String, dynamic>> getJson(String route,
      {Map<String, dynamic>? parameters, bool authorization = false}) async {
    String message = 'Unknown error';
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (authorization) {
      headers['email'] = CurrentUser.userEmail!;
      headers['authorization'] = CurrentUser.userKey!;
    }
    try {
      http.Response response = await http.get(
        Uri.http(host, '$baseUrl$route', parameters),
        headers: headers,
      );
      message = response.body;
      if (response.statusCode == 200) {
        return {"success": true, 'response': message};
      }
    } catch (_) {}
    return {"success": false, 'response': message};
  }
}
