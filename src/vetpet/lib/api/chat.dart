import 'dart:convert';

import 'package:vetpet/api/requests.dart';
import 'package:vetpet/api/user.dart';
import 'package:vetpet/types.dart';

class ChatApi extends Requests {
  ChatApi(this.other);
  User other;
  DateTime lastRefresh = DateTime(2000);

  Future<Map<String, dynamic>> sendMessage(String message) async {
    final response = await Requests.postJson(
        '/chat/send',
        {
          'to': other.email,
          'message': message,
        },
        authorization: true);
    return response;
  }

  Future<List<Message>?> messageRequest() async {
    final response = await Requests.getJson('/chat/retrieve',
        parameters: {
          'other': other.email,
          'time': lastRefresh.toIso8601String()
        },
        authorization: true);
    if (response['success']) {
      final data = jsonDecode(response['response']) as List<dynamic>;
      var messages = data
          .map((e) => Message(e['text'], e['from_id'] == CurrentUser.userEmail,
              DateTime.parse(e['time'])))
          .toList();
      messages = messages.reversed.toList();
      if (messages.isNotEmpty) {
        lastRefresh = messages.first.time;
      }
      return messages;
    }
    return null;
  }
}
