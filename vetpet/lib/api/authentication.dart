import 'dart:convert';

import 'package:vetpet/api/requests.dart';
import 'package:vetpet/api/storage.dart';
import 'package:vetpet/api/user.dart';
import 'package:vetpet/types.dart';

class Authentication {
  static Future<Map<String, dynamic>> signupUser(
      String email, String role) async {
    return Requests.postJson('/signup/add_user/', {
      "email": email,
      "role": role,
    });
  }

  static Future<Map<String, dynamic>> requestOtp(String email) async {
    return await Requests.postJson('/login/requestotp/', {
      "email": email,
    });
  }

  static Future<Map<String, dynamic>> verifyOtp(String email, String otp,
      {bool signup = false}) async {
    final response = await Requests.postJson('/login/verifyotp/', {
      "email": email,
      "otp": otp,
    });
    if (response["success"]) {
      var data = jsonDecode(response["response"]);
      String role = data["user_type"];
      String api = data["api_key"];
      await Storage.saveCredentials(email, api, role);
      if (!signup) {
        if (await fetchInfo()) {
          return {'success': true, 'role': role};
        }
        return {'success': false, 'response': 'failed to fetch info'};
      }
    }
    return response;
  }

  static Future<bool> fetchInfo() async {
    final response = await Requests.getJson(
        '/${CurrentUser.role}/details',
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
    final req = await Requests.postJson('/signup/vet/', {
      "name": name,
      "email": CurrentUser.userEmail,
      "phone": phone,
      "working_time": working,
      "state": state,
    });
    if (req['success']) {
      Storage.saveUserData(Vet(
          CurrentUser.userEmail!,
          name,
          state,
          phone,
          working,
        ));
    }
    return req;
  }

  static Future<Map<String, dynamic>> addOwner(
      String name, String phone, String state) async {
    final req = await Requests.postJson('/signup/owner/', {
      "name": name,
      "email": CurrentUser.userEmail,
      "phone": phone,
      "state": state,
    });
    if (req['success']) {
      Storage.saveUserData(Owner(
          CurrentUser.userEmail!,
          name,
          state,
          phone,
        ));
    }
    return req;
  }

  static Future<void> logout() async {
    await Storage.clearAll();
  }
}
