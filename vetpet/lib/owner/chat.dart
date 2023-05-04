import 'package:flutter/material.dart';
import 'package:vetpet/types.dart';

class OwnerChat extends StatelessWidget {
  const OwnerChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veterinarians'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/owner/search_vet');
              },
              child: const Text('Search Vetenarian')),
        ],
      ),
      body: ElevatedButton(
        child: const Text("chat"),
        onPressed: () => Navigator.pushNamed(context, '/chat',
            arguments: User('v@a.s', 'name', 'state', 'phone')),
      ),
    );
  }
}
