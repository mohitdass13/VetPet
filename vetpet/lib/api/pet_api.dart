import 'dart:convert';

import 'package:vetpet/api/requests.dart';
import 'package:vetpet/api/user.dart';
import 'package:vetpet/types.dart';

class PetApi {
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

    final req = await Requests.postJson('/owner/request', {
      'pet_ids': petIds,
      'vet_id': vetId,
    }, authorization: true);
    return req['success'];
  }
}
