import 'package:flutter/material.dart';
import 'package:vetpet/api/owner_api.dart';
import 'package:vetpet/api/user.dart';
import 'package:vetpet/types.dart';

class OwnerHome extends StatefulWidget {
  const OwnerHome({super.key});

  @override
  State<OwnerHome> createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Flexible(child: PetsList()),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  Navigator.pushNamed(
                    context,
                    '/owner/addpet',
                  );
                },
                child: const Text('Add New Pet')),
          ],
        ),
      ),
    );
  }
}

class PetsList extends StatefulWidget {
  const PetsList({
    super.key,
  });

  @override
  State<PetsList> createState() => _PetsListState();
}

class _PetsListState extends State<PetsList> {
  late Future<List<Pet>> pets;

  Future<List<Pet>> refresh() async {
    bool success = await OwnerApi.refreshPets();
    if (success) {
      return CurrentUser.owner!.pets;
    } else {
      return Future.error(Exception('Error getting data!'));
    }
  }

  @override
  void initState() {
    pets = refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Pets",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        pets = refresh();
                      });
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
            const Divider(),
            FutureBuilder(
              future: pets,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 70,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: snapshot.data!
                            .map((e) => ListTile(
                                  title: Text(e.name),
                                  subtitle: Text(e.breed),
                                  trailing: const Icon(Icons.navigate_next),
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    '/owner/pet_details',
                                    arguments: e,
                                  ),
                                ))
                            .toList(),
                      ),
                    );
                  } else {
                    return const SizedBox(
                      height: 70,
                      child: Center(child: Text("No pets added yet")),
                    );
                  }
                } else {
                  return const SizedBox(
                    height: 70,
                    child: Center(child: Text("Error getting pets!")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
