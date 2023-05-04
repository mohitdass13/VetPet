// ignore: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:vetpet/api/owner_api.dart';
import 'package:vetpet/common/utils.dart';

import '../types.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class PetDetails extends StatefulWidget {
  const PetDetails({super.key, required this.pet, required this.isVet});

  final Pet pet;
  final bool isVet;

  @override
  State<PetDetails> createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails> {
  late Future<List<PetHistory>> history;

  Future<List<PetHistory>> refresh() async {
    bool success = await OwnerApi.getHistory(widget.pet);
    if (success) {
      return widget.pet.history;
    } else {
      return [];
    }
  }

  @override
  void initState() {
    history = refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Details'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Remove pet"),
                    content: const Text(
                        "Are you sure to remove this pet data and delete all its data?"),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.errorContainer,
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () async {
                          if (await OwnerApi.removePet(widget.pet)) {
                            if (mounted) {
                              Utils.showSnackbar(context, "Pet removed!");
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          } else {
                            if (mounted) {
                              Utils.showSnackbar(context, "Error!");
                            }
                          }
                        },
                        child: const Text("Confirm"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
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
                const Icon(Icons.person),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Name: ${widget.pet.name}',
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
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
                  child: Stack(
                    children: [
                      Row(
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
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: widget.isVet
                              ? IconButton(
                                  onPressed: () => Navigator.pushNamed(
                                      context, '/vet/client/pet/add_history',
                                      arguments: widget.pet),
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.blue,
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      )
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
            ...widget.pet.history
                .map((e) => HistoryCard(history: e))
                .toList()
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

    return InkWell(
      onTap:() {
        if (history.fileData != null) SfPdfViewer.memory(history.fileData!);
      },
      child: SizedBox(
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
      ),
    );
  }
}
