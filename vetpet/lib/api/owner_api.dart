import 'dart:convert';
import 'dart:typed_data';

import 'package:vetpet/api/requests.dart';
import 'package:vetpet/api/user.dart';
import 'package:vetpet/types.dart';

class OwnerApi {
  static Future<bool> addPet(Pet pet) async {
    final req = await Requests.postJson(
        '/pet/add',
        {
          "name": pet.name,
          "age": pet.age,
          "breed": pet.breed,
          "weight": pet.weight,
        },
        authorization: true);
    return req['success'];
  }

  static Future<bool> refreshPets() async {
    final req = await Requests.getJson('/owner/pets', authorization: true);
    if (req['success']) {
      final pets = jsonDecode(req['response']) as List<dynamic>;
      CurrentUser.owner!.pets = pets
          .map((e) =>
              Pet(e['pet_id'], e['name'], e['age'], e['breed'], e['weight']))
          .toList();
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> removePet(Pet pet) async {
    final req = await Requests.postJson(
        '/pet/remove',
        {
          "id": pet.id,
        },
        authorization: true);
    return req['success'];
  }

  static Future<List<Vet>> getVetList() async {
    final req = await Requests.getJson('/vet/list', authorization: true);
    if (req['success']) {
      final vets = jsonDecode(req['response']) as List<dynamic>;
      return vets
          .map((e) =>
              Vet(e['emailid'], e['name'], e['state'], '', e['working_time']))
          .toList();
    } else {
      return Future.error(Exception('Error loading vets'));
    }
  }

  static Future<bool> sendRequest(List<Pet> pets, String vetId) async {
    List<int> petIds = pets.map((e) => e.id).toList();

    final req = await Requests.postJson(
        '/owner/request',
        {
          'pet_ids': petIds,
          'vet_id': vetId,
        },
        authorization: true);
    return req['success'];
  }

  static Future<bool> refreshConnections() async {
    final req =
        await Requests.getJson('/owner/connections', authorization: true);
    if (req['success']) {
      final connections = jsonDecode(req['response']) as List<dynamic>;
      CurrentUser.owner!.approvals = {};
      CurrentUser.owner!.connections = {};
      for (var conn in connections) {
        Vet vet = Vet(conn['vet_id'], conn['vet_name'], '', '', '');
        CurrentUser.owner!.addConnection(vet, conn['pet_id'], conn['approved']);
      }
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> getHistory(Pet pet) async {
    final req = await Requests.getJson('/pet/history',
        parameters: {
          'pet_id': pet.id.toString(),
        },
        authorization: true);
    if (req['success']) {
      final histories = jsonDecode(req['response']) as List<dynamic>;
      pet.history = histories
          .map((e) => PetHistory.withId(
                e['id'],
                e['pet_id'],
                e['name'],
                e['description'],
                DateTime.parse(e['date']),
                e['type'],
                e['file_name'],
                e['file_data'] == null
                    ? null
                    : Uint8List.view(e['file_data'].buffer),
              ))
          .toList();
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  static Future<bool> addHistory(PetHistory history) async {
    final req = await Requests.postJson(
        '/vet/client/pet/add_history/add',
        {
          "pet_id": history.petId,
          "name": history.name,
          "description": history.description,
          "date":
              "${history.date.year}-${history.date.month}-${history.date.day}",
          "type": history.type,
          "file_name": history.fileName,
          "file_data": history.fileData?.join(","),
        },
        authorization: true);
    return req['success'];
  }
}
