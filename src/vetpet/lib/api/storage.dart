import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetpet/api/user.dart';
import 'package:vetpet/types.dart';

abstract class Storage {
  static SharedPreferences? _prefs;
  static Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  static Future<void> getCredentials() async {
    final prefs = await _getPrefs();
    CurrentUser.userEmail = prefs.getString('email');
    CurrentUser.userKey = prefs.getString('apiKey');
    CurrentUser.role = prefs.getString('role');
    getUserData();
  }

  static Future<void> saveCredentials(
      String email, String api, String role) async {
    CurrentUser.userEmail = email;
    CurrentUser.userKey = api;
    CurrentUser.role = role;
    final prefs = await _getPrefs();
    prefs.setString('email', email);
    prefs.setString('apiKey', api);
    prefs.setString('role', role);
  }

  static Future<void> getUserData() async {
    final prefs = await _getPrefs();
    if (CurrentUser.role != null) {
      List<String> userData = prefs.getStringList('userData')!;
      if (CurrentUser.role == 'vet') {
        CurrentUser.user = Vet(CurrentUser.userEmail!, userData[0], userData[1],
            userData[2], userData[3]);
      } else {
        CurrentUser.user = Owner(
            CurrentUser.userEmail!, userData[0], userData[1], userData[2]);
      }
    }
  }

  static Future<void> saveUserData(User userData) async {
    CurrentUser.user = userData;
    final prefs = await _getPrefs();
    if (userData.runtimeType == Owner) {
      prefs.setStringList(
          'userData', [userData.name, userData.state, userData.phone]);
    } else {
      Vet vet = userData as Vet;
      prefs.setStringList(
          'userData', [vet.name, vet.state, userData.phone, vet.wTime]);
    }
  }

  static Future<String> getFirstRoute() async {
    try {
      await getCredentials();
    } catch (_) {}
    return CurrentUser.role == null ? '/login' : '/${CurrentUser.role}/home';
  }

  static Future<void> clearAll() async {
    final prefs = await _getPrefs();
    prefs.remove('email');
    prefs.remove('apiKey');
    prefs.remove('role');
    prefs.remove('userData');
    CurrentUser.userEmail = null;
    CurrentUser.role = null;
    CurrentUser.userKey = null;
    CurrentUser.user = null;
  }

  static void savePetData(Pet pet) {}
  
  
}
