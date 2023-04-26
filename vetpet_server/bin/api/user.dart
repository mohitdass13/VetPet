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
}
