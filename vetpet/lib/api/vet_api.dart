import 'dart:convert';

import 'package:vetpet/api/requests.dart';
import 'package:vetpet/api/user.dart';
import 'package:vetpet/types.dart';

class VetApi {
  static Future<bool> refreshConnections() async {
    final req = await Requests.getJson('/vet/connections', authorization: true);
    if (req['success']) {
      final connections = jsonDecode(req['response']) as List<dynamic>;
      CurrentUser.vet!.clearLists();
      for (var conn in connections) {
        CurrentUser.vet!.addConnections(
            Owner(conn['owner_email'], conn['owner_name'], '', ''),
            conn['approved']);
      }
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> acceptRequest(String ownerId) async {
    final req = await Requests.postJson(
        '/vet/accept',
        {
          'owner_id': ownerId,
        },
        authorization: true);
    return true;
  }
}
