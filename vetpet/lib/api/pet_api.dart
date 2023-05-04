import 'package:vetpet/api/requests.dart';
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

  static Future<List<Pet>> getPets() async {
    final req = await Requests.getJson('/owner/pets', authorization: true);
    final pets = req['data'] as List<Map<String, dynamic>>;
    return pets
        .map((e) =>
            Pet(e['pet_id'], e['name'], e['age'], e['breed'], e['weight']))
        .toList();
  }
}
