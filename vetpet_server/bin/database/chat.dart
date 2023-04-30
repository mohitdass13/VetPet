import 'database.dart';

class ChatDB {
  static Future<bool> sendMessage(
      String from, String to, String message) async {
    final result = await Database.connection.execute(
        "INSERT INTO message (text, from_id, to_id) VALUES (@message, @from, @to)",
        substitutionValues: {
          'to': to,
          'from': from,
          'message': message,
        });
    return result > 0;
  }

  static Future<List<Map<String, Map<String, dynamic>>>> retrieveMessages(
      String user1, String user2, DateTime time) async {
    final result = await Database.connection.mappedResultsQuery(
      """
        SELECT * FROM message 
        WHERE ((from_id = @user1 AND to_id = @user2) 
          OR (from_id = @user2 AND to_id = @user1)) 
          AND time > @time
        ORDER BY time
      """,
      substitutionValues: {
        'user1': user1,
        'user2': user2,
        'time': time,
      },
    );
    return result;
  }
}
