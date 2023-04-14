import 'database.dart';

class AuthDB {
  static Future<bool> userExist(String email) async {
    final result = await Database.connection.mappedResultsQuery(
      'SELECT * FROM users WHERE emailid = @email',
      substitutionValues: {'email': email},
    );
    return result.isNotEmpty;
  }

  static Future<bool> saveOtp(String email, int otp) async {
    final result = await Database.connection.execute(
        "CALL store_otp(@email, @otp)",
        substitutionValues: {'email': email, 'otp': otp});
    return result > 0;
  }

  static Future<bool> verifyOtp(String email, int otp) async {
    final result = await Database.connection.mappedResultsQuery(
      'SELECT verify_otp(@email, @otp)',
      substitutionValues: {'email': email, 'otp': otp},
    );
    return result.first.values.first['verify_otp'];
  }

  static Future<void> storeLoggedIn(String email, String apiKey) async {
    await Database.connection.execute("CALL store_logged_in(@email, @api_key)",
        substitutionValues: {'email': email, 'api_key': apiKey});
  }

  static Future<String> userType(String email) async {
    final result = await Database.connection.mappedResultsQuery(
      'SELECT * FROM users WHERE emailid = @email',
      substitutionValues: {'email': email},
    );
    return result.first['users']?['role'] ?? 'Invalid';
  }

  static Future<bool> verifyKey(String email, String key) async {
    var result = await Database.connection.mappedResultsQuery(
      'SELECT verify_key(@email, @key)',
      substitutionValues: {'email': email, 'key': key},
    );
    print(result.first.values.first['verify_key']);
    return true;
    //result.rows.first.typedColAt<int>(0) == 1;
  }
}
