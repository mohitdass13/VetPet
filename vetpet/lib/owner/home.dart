import 'package:flutter/material.dart';
import 'package:vetpet/api/user.dart';
import 'package:vetpet/types.dart';

class OwnerHome extends StatefulWidget {
  const OwnerHome({super.key});

  @override
  State<OwnerHome> createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  List<Pet> pets = (CurrentUser.user! as Owner).pets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          ElevatedButton(onPressed: () {
            Navigator.pushNamed(context, '/owner/search_vet');
          }, child: const Text('Search Vetenarian')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Pets",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: pets
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
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
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
