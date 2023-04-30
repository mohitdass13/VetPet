import 'dart:convert';

import '../database/chat.dart';
import 'user.dart';

class ChatAPI {
  static Future<bool> sendMessage(
      String from, String to, String message) async {
    if (await UserApi.userExist(to)) {
      return ChatDB.sendMessage(from, to, message);
    } else {
      return false;
    }
  }

  static Future<String> retrieveMessagesJSON(
      String user1, String user2, DateTime time) async {
    final result = await ChatDB.retrieveMessages(user1, user2, time);
    final data = result.map((e) => e['message']).toList();
    final json = jsonEncode(
      data,
      toEncodable: (obj) {
        if (obj is DateTime) {
          return obj.toIso8601String();
        }
        return obj;
      },
    );
    return json;
  }
}
