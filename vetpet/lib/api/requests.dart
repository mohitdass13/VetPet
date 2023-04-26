import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class Requests {
  static Future<Map<String, dynamic>> postJson(
      String route, Map<String, dynamic> data) async {
    String message = 'Unknown error';
    try {
      http.Response response = await http.post(
        Uri.parse(route),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      message = response.body;
      if (response.statusCode == 200) {
        return {"success": true, 'response': message};
      }
    } catch (_) {}
    return {"success": false, 'response': message};
  }
}
