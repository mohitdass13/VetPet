import '../types.dart';

class CurrentUser {
  static String? userEmail;
  static String? userKey;
  static String? role;
  static User? _user;
  static Owner? owner;
  static Vet? vet;

  static set user(User? user) {
    _user = user;
    if (user.runtimeType == Owner) {
      owner = user as Owner;
    } else if (user.runtimeType == Vet) {
      vet = user as Vet;
    }
  }

  static User? get user {
    return _user;
  }
}
