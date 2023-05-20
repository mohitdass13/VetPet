import 'package:flutter/material.dart';
import 'package:vetpet/api/authentication.dart';
import 'package:vetpet/types.dart';

class VetHome extends StatefulWidget {
  const VetHome({super.key});

  @override
  State<VetHome> createState() => _VetHomeState();
}

class _VetHomeState extends State<VetHome> {
  List<Owner> clients = [
    Owner("o@a.s", "Client 1", '', ''),
    Owner("test2@gmial.com", "Client 2", '', ''),
    Owner("test3@gmial.com", "Client 3", '', ''),
    Owner("test4@gmial.com", "Client 4", '', ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: InkWell(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('New notificaton (if any)'),
                ),
                onTap: () async {
                  await Authentication.fetchInfo();
                },
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Clients",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: clients
                            .map((e) => ListTile(
                                  title: Text(e.name),
                                  subtitle: Text(e.email),
                                  trailing: const Icon(Icons.navigate_next),
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    '/vet/client',
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
          ],
        ),
      ),
    );
  }
}
