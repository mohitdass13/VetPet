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

  static Future<bool> addPet(String name, int age, double weight, String breed,
      String owneremailid) async {
    return UserDB.addPet(name, age, weight, breed, owneremailid);
  }

  static Future<bool> removePet(int petid, String ownerid) async {
    return UserDB.removePet(petid, ownerid);
  }

  static Future<List<Map<String, dynamic>?>> getPets(String email) async {
    final result = await UserDB.getPets(email);
    final data = result.map((e) => e['pet']).toList();
    return data;
  }

  static Future<List<Map<String, dynamic>?>> getVets() async {
    final result = await UserDB.getVets();
    final data = result.map((e) => e['vet']?..remove('phone_number')).toList();
    return data;
  }

  static Future<bool> requestVet(
      List<int> petIds, String vetEmail, String ownerEmail) async {
    if (await UserDB.verifyPetIds(ownerEmail, petIds)) {
      return UserDB.addRequest(vetEmail, petIds);
    } else {
      return false;
    }
  }
}
