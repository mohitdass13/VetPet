import 'package:flutter/material.dart';
import 'package:vetpet/owner/pet_details.dart';
import '../types.dart';

class PetDetailsVet extends StatefulWidget {
  const PetDetailsVet({Key? key, required this.pet}) : super(key: key);
  final Pet pet;

  @override
  State<PetDetailsVet> createState() => _PetDetailsVetState();
}

class _PetDetailsVetState extends State<PetDetailsVet> {
  @override
  Widget build(BuildContext context) {
    return PetDetails(pet: widget.pet, isVet: true);
  }
}
