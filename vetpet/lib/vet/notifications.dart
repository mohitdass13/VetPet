import 'package:flutter/material.dart';
import 'package:vetpet/api/owner_api.dart';
import 'package:vetpet/api/user.dart';
import 'package:vetpet/api/vet_api.dart';
import 'package:vetpet/types.dart';

class VetNotifications extends StatelessWidget {
  const VetNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Flexible(child: ConnectionList()),
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
  late Future<List<Owner>> requests;

  Future<List<Owner>> refresh() async {
    bool success = await VetApi.refreshConnections();
    if (success) {
      return CurrentUser.vet!.requests;
    } else {
      return Future.error(Exception('Error getting data!'));
    }
  }

  @override
  void initState() {
    requests = refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              requests = refresh();
            });
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh'),
        ),
        FutureBuilder(
          future: requests,
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
                  children: snapshot.data!
                      .map((e) => ListTile(
                            title: Text(e.name),
                            subtitle: Text(e.email),
                            trailing: ElevatedButton(
                              child: const Text('Accept'),
                              onPressed: () {
                                
                                setState(() {
                                  requests = refresh();
                                });
                              },
                            ),
                          ))
                      .toList(),
                );
              } else {
                return const SizedBox(
                  height: 70,
                  child: Center(child: Text("No clients")),
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
