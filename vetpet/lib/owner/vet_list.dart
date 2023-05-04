import 'package:flutter/material.dart';
import 'package:vetpet/api/owner_api.dart';
import 'package:vetpet/api/user.dart';
import 'package:vetpet/common/utils.dart';

import '../types.dart';

class VetList extends StatefulWidget {
  const VetList({super.key});

  @override
  State<VetList> createState() => _VetListState();
}

class _VetListState extends State<VetList> {
  late Future<List<Vet>> vets;

  @override
  void initState() {
    vets = OwnerApi.getVetList();
    super.initState();
  }

  Owner owner = CurrentUser.owner!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vet List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: vets,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 70,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.map((e) => VetCard(vet: e)).toList(),
              );
            } else {
              return const SizedBox(
                height: 70,
                child: Center(child: Text("Error getting data!")),
              );
            }
          },
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
  final Vet vet;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: InkWell(
          onTap: () => showDialog(
            context: context,
            builder: (context) => RequestDialog(
              vet: vet,
            ),
          ),
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
                Text('Email: ${vet.email}',
                    style: const TextStyle(fontSize: 17)),
                const SizedBox(
                  height: 10,
                ),
                Text('State: ${vet.state}',
                    style: const TextStyle(fontSize: 17)),
                const SizedBox(
                  height: 5,
                ),
                Text('Working Time: ${vet.wTime}',
                    style: const TextStyle(fontSize: 17)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RequestDialog extends StatefulWidget {
  const RequestDialog({super.key, required this.vet});
  final Vet vet;

  @override
  State<RequestDialog> createState() => _RequestDialogState();
}

class _RequestDialogState extends State<RequestDialog> {
  late List<bool> selected;
  late List<Pet> pets;
  @override
  void initState() {
    pets = CurrentUser.owner!.pets;
    selected = List.generate(pets.length, (index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Request'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select pet(s):',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8 - 200,
            child: ListView(
              shrinkWrap: true,
              children: List.generate(
                pets.length,
                (index) => ListTile(
                  title: Text(pets[index].name),
                  subtitle: Text(pets[index].breed),
                  selected: selected[index],
                  trailing: Icon(selected[index]
                      ? Icons.check_box
                      : Icons.check_box_outline_blank),
                  onTap: () {
                    setState(() {
                      selected[index] = !selected[index];
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: (selected.contains(true))
              ? () async {
                  List<Pet> selectedPets = [];
                  for (var i = 0; i < pets.length; i++) {
                    if (selected[i]) {
                      selectedPets.add(pets[i]);
                    }
                  }
                  bool sent = await OwnerApi.sendRequest(
                      selectedPets, widget.vet.email);
                  if (mounted) {
                    if (sent) {
                      Utils.showSnackbar(context, 'Request sent');
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      Utils.showSnackbar(context, 'Request failed');
                    }
                  }
                }
              : null,
          child: const Text('Send request'),
        ),
      ],
    );
  }
}
