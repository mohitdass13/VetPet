import '../database/user.dart';

class UserApi {
  static Future<Map<String, dynamic>?> getInfo(
      String email, String role, bool publicOnly) async {
    Map<String, dynamic>? data = await UserDB.getInfo(email, role);
    if (data == null) {
      return null;
    }
    if (publicOnly) {
      data.remove('phone_number');
    }
    return data;
  }

  static Future<String?> userType(String email) async {
    final type = await UserDB.userType(email);
    return type != 'Invalid' ? type : null;
  }

  static Future<bool> userExist(String email) async {
    return await userType(email) != null;
  }
}
