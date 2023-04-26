import 'package:vetpet/api/requests.dart';

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

  static Future<Map<String, dynamic>> verifyOtp(
      String email, String otp) async {
    return Requests.postJson('$baseUrl/login/verifyotp/', {
      "email": email,
      "otp": otp,
    });
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
