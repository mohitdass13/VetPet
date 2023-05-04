import 'database.dart';

class UserDB {
  static Future<Map<String, dynamic>?> getInfo(
      String email, String role) async {
    final result = await Database.connection.mappedResultsQuery(
      'SELECT * FROM users NATURAL JOIN $role WHERE emailid = @email',
      substitutionValues: {'email': email},
    );
    if (result.isNotEmpty) {
      return result[0]['users']?..addAll(result[0][role]!);
    }
    return null;
  }

  static Future<String> userType(String email) async {
    final result = await Database.connection.mappedResultsQuery(
      'SELECT * FROM users WHERE emailid = @email',
      substitutionValues: {'email': email},
    );
    return result.first['users']?['role'] ?? 'Invalid';
  }

  static Future<bool> addPet(String name, int age, double weight, String breed,
      String owneremailid) async {
    final result = await Database.connection.execute(
      'INSERT INTO pet(name,age,weight,breed,owner_emailid) VALUES(@name,@age,@weight,@breed,@owner_emailid)',
      substitutionValues: {
        'name': name,
        'age': age,
        'weight': weight,
        'breed': breed,
        'owner_emailid': owneremailid,
      },
    );
    return result > 0;
  }

  static Future<bool> removePet(int petid, String ownerid) async {
    final result = await Database.connection.execute(
      'DELETE FROM pet WHERE pet_id=@id AND owner_emailid=@owner_emailid',
      substitutionValues: {
        'owner_emailid': ownerid,
        'id': petid,
      },
    );
    return result > 0;
  }

  static Future<List<Map<String, Map<String, dynamic>>>> getPets(
      String email) async {
    final result = await Database.connection.mappedResultsQuery(
      'SELECT * FROM pet WHERE owner_emailid = @email',
      substitutionValues: {'email': email},
    );
    return result;
  }

  static Future<List<Map<String, Map<String, dynamic>>>> getVets() async {
    final result = await Database.connection.mappedResultsQuery(
      'SELECT * FROM vet',
    );
    return result;
  }

  static Future<bool> verifyPetIds(String email, List<int> petIds) async {
    final result = await Database.connection.mappedResultsQuery(
        'SELECT COUNT(*) FROM pet WHERE owner_emailid=@email AND pet_id = ANY (@pet_ids)',
        substitutionValues: {'email': email, 'pet_ids': petIds});
    return result.first.values.first['count'] == petIds.length;
  }

  static Future<bool> addRequest(String vetEmail, List<int> petIds) async {
    List<String> values = List.generate(
        petIds.length, (index) => "(${petIds[index]}, '$vetEmail', false)");

    final result = await Database.connection.execute(
      'INSERT INTO connections VALUES ${values.join(',')} ON CONFLICT DO NOTHING',
    );
    print(result);
    return result > 0;
  }
}
