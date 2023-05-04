// ignore: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';

import '../types.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class PetDetails extends StatefulWidget {
  const PetDetails({super.key, required this.pet});
  final Pet pet;

  @override
  State<PetDetails> createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.name),
      ),
      body: Padding(
        // padding: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(Icons.pets),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Breed: ${widget.pet.breed}',
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Icon(Icons.scale_sharp),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Weight: ${widget.pet.weight}',
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Icon(Icons.calendar_month),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Age: ${widget.pet.age}',
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                const Divider(
                  color: Colors.black,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.history),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'History',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ...widget.pet.history.map((e) => HistoryCard(history: e)).toList()
          ],
        ),
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.history});
  final PetHistory history;

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('dd/mm/yyyy').format(history.date);

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
                history.name,
                style: const TextStyle(fontSize: 20),
              )),
              const SizedBox(
                height: 10,
              ),
              Text('Type: ${history.type}',
                  style: const TextStyle(fontSize: 17)),
              const SizedBox(
                height: 10,
              ),
              Text('Date: $date', style: const TextStyle(fontSize: 17)),
              const SizedBox(
                height: 10,
              ),
              Text('Description: ${history.description}',
                  style: const TextStyle(fontSize: 17)),
            ],
          ),
        ),
      ),
    );
  }
}
