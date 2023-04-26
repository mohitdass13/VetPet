import 'dart:convert';

import 'package:vetpet/api/requests.dart';
import 'package:vetpet/api/storage.dart';
import 'package:vetpet/api/user.dart';
import 'package:vetpet/types.dart';

class Authentication {
  static String baseUrl = "http://localhost:8080/api";
  static String emailSave = "";
  static String roleSave = "";

  static Future<Map<String, dynamic>> signupUser(
      String email, String role) async {
    return Requests.postJson('$baseUrl/signup/add_user/', {
      "email": email,
      "role": role,
    });
  }

  static Future<Map<String, dynamic>> requestOtp(String email) async {
    return await Requests.postJson('$baseUrl/login/requestotp/', {
      "email": email,
    });
  }

  static Future<Map<String, dynamic>> verifyOtp(
      String email, String otp) async {
    final response = await Requests.postJson('$baseUrl/login/verifyotp/', {
      "email": email,
      "otp": otp,
    });
    if (response["success"]) {
      var data = jsonDecode(response["response"]);
      String role = data["user_type"];
      String api = data["api_key"];
      await Storage.saveCredentials(email, api, role);
      if (await fetchInfo()) {
        return {'success': true, 'role': role};
      }
      return {'success': false, 'response': 'failed to fetch info'};
    }
    return response;
  }

  static Future<bool> fetchInfo() async {
    final response = await Requests.getJson(
        '$baseUrl/${CurrentUser.role}/details',
        authorization: true);
    if (response['success']) {
      final data = jsonDecode(response['response']);
      if (CurrentUser.role == 'vet') {
        Storage.saveUserData(Vet(
          data['emailid'],
          data['name'],
          data['state'],
          data['phone_number'],
          data['working_time'],
        ));
      } else {
        Storage.saveUserData(Owner(
          data['emailid'],
          data['name'],
          data['state'],
          data['phone_number'],
        ));
      }
      return true;
    }
    return false;
  }

  static Future<Map<String, dynamic>> addVet(
      String name, String phone, String working, String state) async {
    return Requests.postJson('$baseUrl/signup/vet/', {
      "name": name,
      "email": emailSave,
      "phone": phone,
      "working_time": working,
      "state": state,
    });
  }

  static Future<Map<String, dynamic>> addOwner(
      String name, String phone, String state) async {
    return Requests.postJson('$baseUrl/signup/owner/', {
      "name": name,
      "email": emailSave,
      "phone": phone,
      "state": state,
    });
  }
}
