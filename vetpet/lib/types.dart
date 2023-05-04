import 'dart:typed_data';

class User {
  String name;
  String email;
  String state;
  String phone;
  User(this.email, this.name, this.state, this.phone);
}

class Vet extends User {
  Vet(super.email, super.name, super.state, super.phone, this.wTime);
  String wTime;

  List<Owner> clients = [];
  List<Owner> requests = [];

  void clearLists() {
    clients = [];
    requests = [];
  }

  void addConnections(Owner owner, bool approved) {
    if (approved) {
      clients.add(owner);
    } else {
      requests.add(owner);
    }
  }
}

class Owner extends User {
  List<Pet> pets = [];
  List<int> petIds = [];

  Map<String, List<int>> connections = {};
  Map<Vet, bool> approvals = {};

  Pet getPet(int id) {
    return pets.firstWhere((e) => e.id == id);
  }

  String petNameList(String vetId) {
    return connections[vetId]!.map((e) => getPet(e).name).join(', ');
  }

  void addConnection(Vet vet, int petId, bool approved) {
    if (connections.containsKey(vet.email)) {
      if (!connections[vet.email]!.contains(petId)) {
        connections[vet.email]!.add(petId);
      }
    } else {
      connections[vet.email] = [petId];
      approvals[vet] = approved;
    }
  }

  bool getApproved(String vetId) {
    return approvals[getVet(vetId)]!;
  }

  Vet getVet(String vetId) {
    return approvals.keys.firstWhere((e) => e.email == vetId);
  }

  Owner(super.email, super.name, super.state, super.phone);
}

List<String> breed = ["Labrador", "Pug", "German Shepherd", "Golden Retriever"];

class Pet {
  String name;
  int id;
  int age;
  String breed;
  double weight;

  List<PetHistory> history = [];

  Pet(this.id, this.name, this.age, this.breed, this.weight);
}

class Message {
  String text;
  bool byCurrent;
  DateTime time;
  Future<Map<String, dynamic>>? sendResponse;
  Message(this.text, this.byCurrent, this.time, {this.sendResponse});
}

class PetHistory {
  int? id;
  int? petId;
  String name;
  String? description;
  DateTime date;
  String type;
  String? fileName;
  Uint8List? fileData;

  PetHistory(this.petId, this.name, this.description, this.date, this.type,
      this.fileName, this.fileData);

  PetHistory.withId(this.id, this.petId, this.name, this.description, this.date,
      this.type, this.fileName, this.fileData);
  PetHistory.withoutFile(
      this.id, this.name, this.description, this.date, this.type);
}
