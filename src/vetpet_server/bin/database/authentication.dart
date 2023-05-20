import 'database.dart';

class AuthDB {
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

  static Future<bool> verifyKey(String email, String key) async {
    var result = await Database.connection.mappedResultsQuery(
      'SELECT verify_key(@email, @key)',
      substitutionValues: {'email': email, 'key': key},
    );
    return result.first.values.first['verify_key'];
  }

  static Future<bool> addUser(String email, String role) async {
    try {
      var result = await Database.connection.execute(
        'INSERT INTO users VALUES (@email, @role) ON CONFLICT DO NOTHING',
        substitutionValues: {'email': email, 'role': role},
      );
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addVet(String email, String name, String phone,
      String wTime, String state) async {
    var result = await Database.connection.execute(
      'INSERT INTO vet VALUES (@name, @email, @phone, @w_time, @state)',
      substitutionValues: {
        'email': email,
        'name': name,
        'phone': phone,
        'w_time': wTime,
        'state': state,
      },
    );
    return result > 0;
  }

  static Future<bool> addOwner(
      String email, String name, String phone, String state) async {
    var result = await Database.connection.execute(
      'INSERT INTO owner VALUES (@name, @email, @phone, @state)',
      substitutionValues: {
        'email': email,
        'name': name,
        'phone': phone,
        'state': state,
      },
    );
    return result > 0;
  }
}
