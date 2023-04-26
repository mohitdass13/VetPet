import 'package:flutter/material.dart';
import 'package:vetpet/api/authentication.dart';
import 'package:vetpet/api/user.dart';
import 'package:vetpet/types.dart';

class VetProfile extends StatelessWidget {
  const VetProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Padding(
          // padding: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Name: ${CurrentUser.user!.name}',
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Phone Number: ${CurrentUser.user!.phone}',
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Icon(Icons.email_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Email: ${CurrentUser.user!.email}',
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Icon(Icons.location_city),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'State: ${CurrentUser.user!.state}',
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Icon(Icons.timer),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Working Time: ${(CurrentUser.user as Vet).wTime}',
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Authentication.logout();
                    if (context.mounted) {
                      Navigator.popAndPushNamed(context, '/login');
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
              )
            ],
          ),
        ));
  }
}
