import 'package:flutter/material.dart';

class OwnerHome extends StatelessWidget {
  const OwnerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            color: Colors.blue,
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/owner/addpet');
            },
          ),
        ],
      ),
    );
  }
}