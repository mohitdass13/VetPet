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
}

class Owner extends User {
  List<Pet> pets = [];
  // List<VetClass> vets = [
  //   VetClass("Vet1", "Punjab", "Mon-Fri 9:00-17:00"),
  //   VetClass("Vet2", "Punjab", "Mon-Fri 9:00-17:00"),
  // ];
  // List<Pet> pets = PetApi.getPets() as List<Pet>;

  Owner(super.email, super.name, super.state, super.phone);
}

List<String> breed = ["Labrador", "Pug", "German Shepherd", "Golden Retriever"];

class Pet {
  String name;
  int id;
  int age;
  String breed;
  double weight;

  List<PetHistory> history = [
    PetHistory(
        0, "Pain medication", "Description", DateTime.now(), "Vaccination"),
    PetHistory(1, "Heartworm medication", "Description", DateTime.now(),
        "Vaccination"),
    PetHistory(
        2, "Deworming medication", "Description", DateTime.now(), "Vaccination")
  ];

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
  int id;
  String name;
  String description;
  DateTime date;
  String type;
  PetHistory(this.id, this.name, this.description, this.date, this.type);
}
