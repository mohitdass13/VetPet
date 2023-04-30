class User {
  String name;
  String email;
  User(this.email, this.name);
}

class Owner extends User {
  Owner(String email, String name) : super(email, name);
  List<Pet> pets = [Pet(0, "Pet1"), Pet(1, "Pet2"), Pet(2, "Pet3")];
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
