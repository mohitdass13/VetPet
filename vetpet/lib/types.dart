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
  List<Pet> pets = [Pet(0, "Pet1"), Pet(1, "Pet2"), Pet(2, "Pet3")];

  Owner(super.email, super.name, super.state, super.phone);
}

List<String> breed = ["Labrador", "Pug", "German Shepherd", "Golden Retriever"];

class Pet {
  String name;
  int id;
  Pet(this.id, this.name);
}

class Message {
  String text;
  bool byCurrent;
  Message(this.text, this.byCurrent);
}
