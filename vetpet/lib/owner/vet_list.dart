import 'package:flutter/material.dart';
import 'package:vetpet/api/user.dart';

import '../types.dart';

class VetList extends StatefulWidget {
  const VetList({super.key});

  @override
  State<VetList> createState() => _VetListState();
}

class _VetListState extends State<VetList> {
  Owner owner = CurrentUser.user as Owner;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vet List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: owner.vets
              .map((e) => VetCard(
                    vet: e,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class VetCard extends StatelessWidget {
  const VetCard({
    super.key,
    required this.vet,
  });
  // final PetHistory history;
  final VetClass vet;

  @override
  Widget build(BuildContext context) {
    // String date = DateFormat('dd/mm/yyyy').format(history.date);

    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text(
                vet.name,
                style: const TextStyle(fontSize: 20),
              )),
              const SizedBox(
                height: 10,
              ),
              Text('State: ${vet.state}', style: const TextStyle(fontSize: 17)),
              const SizedBox(
                height: 10,
              ),
              // Text('Date: ${date}', style: const TextStyle(fontSize: 17)),
              const SizedBox(
                height: 10,
              ),
              Text('Working Time: ${vet.wTime}',
                  style: const TextStyle(fontSize: 17)),
            ],
          ),
        ),
      ),
    );
  }
}
