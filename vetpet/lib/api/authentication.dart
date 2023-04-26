import 'dart:convert';

// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class Authentication {
  static String baseUrl = "http://localhost:8080/api";
  static String emailSave = "";
  static String roleSave = "";

  static Future<Map<String, dynamic>> signupUser(
      String email, String role) async {
    String message = 'Unknown error';
    try {
      http.Response response = await http.post(
        Uri.parse('$baseUrl/signup/add_user/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "email": email,
          "role": role,
        }),
      );
      debugPrint("${response.statusCode} ${response.body}");
      message = response.body;
      if (response.statusCode == 200) {
        return {"sent": true, 'response': message};
      }
    } catch (_) {}
    return {"sent": false, 'response': message};
  }

  static Future<Map<String, dynamic>> verifyOtp(
      String email, String otp) async {
    String message = 'Unknown error';
    try {
      http.Response response = await http.post(
        Uri.parse('$baseUrl/login/verifyotp/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "email": email,
          "otp": otp,
        }),
      );
      debugPrint("${response.statusCode} ${response.body}");
      message = response.body;
      if (response.statusCode == 200) {
        emailSave = email;
        return {"verified": true, 'response': message};
      }
    } catch (_) {}
    return {"verified": false, 'response': message};
  }

  static Future<Map<String, dynamic>> addVet(
      String name, String phone, String working, String state) async {
    String message = 'unknown error';
    try {
      http.Response response = await http.post(
        Uri.parse('$baseUrl/signup/vet/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "name": name,
          "email": emailSave,
          "phone": phone,
          "working_time": working,
          "state": state
        }),
      );
      debugPrint("${response.statusCode} ${response.body}");
      message = response.body;

      if (response.statusCode == 200) {
        return {"added": true, 'response': message};
      }
    } catch (_) {}
    return {"added": false, 'response': message};
  }

  static Future<Map<String, dynamic>> addOwner(
      String name, String phone, String state) async {
    String message = 'unknown error';
    try {
      http.Response response = await http.post(
        Uri.parse('$baseUrl/signup/owner/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "name": name,
          "email": emailSave,
          "phone": phone,
          "state": state
        }),
      );
      debugPrint("${response.statusCode} ${response.body}");
      message = response.body;

      if (response.statusCode == 200) {
        return {"added": true, 'response': message};
      }
    } catch (_) {}
    return {"added": false, 'response': message};
  }
}
