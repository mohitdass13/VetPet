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
}
