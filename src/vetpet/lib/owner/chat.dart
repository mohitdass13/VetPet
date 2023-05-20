import 'package:flutter/material.dart';
import 'package:vetpet/api/owner_api.dart';
import 'package:vetpet/api/user.dart';

class OwnerChat extends StatelessWidget {
  const OwnerChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veterinarians'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, '/owner/search_vet');
              },
              label: const Text('Search Vetenarian'),
            ),
            const Flexible(child: ConnectionList()),
          ],
        ),
      ),
    );
  }
}

class ConnectionList extends StatefulWidget {
  const ConnectionList({
    super.key,
  });

  @override
  State<ConnectionList> createState() => _ConnectionListState();
}

class _ConnectionListState extends State<ConnectionList> {
  late Future<Map<String, List<int>>> connections;

  Future<Map<String, List<int>>> refresh() async {
    bool success = await OwnerApi.refreshConnections();
    if (success) {
      return CurrentUser.owner!.connections;
    } else {
      return Future.error(Exception('Error getting data!'));
    }
  }

  @override
  void initState() {
    connections = refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              connections = refresh();
            });
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh'),
        ),
        FutureBuilder(
          future: connections,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 70,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.keys
                      .map((e) => ListTile(
                            title: Text(e),
                            subtitle: Text(CurrentUser.owner!.petNameList(e)),
                            trailing: CurrentUser.owner!.getApproved(e)
                                ? const Icon(Icons.chat)
                                : const Text('Pending'),
                            onTap: CurrentUser.owner!.getApproved(e)
                                ? () => Navigator.pushNamed(
                                      context,
                                      '/chat',
                                      arguments: CurrentUser.owner!.getVet(e),
                                    )
                                : null,
                          ))
                      .toList(),
                );
              } else {
                return const SizedBox(
                  height: 70,
                  child: Center(child: Text("No vets")),
                );
              }
            } else {
              return const SizedBox(
                height: 70,
                child: Center(child: Text("Error getting data!")),
              );
            }
          },
        ),
      ],
    );
  }
}
