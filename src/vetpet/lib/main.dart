// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:vetpet/api/storage.dart';
import 'package:vetpet/api/user.dart';
import 'package:vetpet/common/chat.dart';
import 'package:vetpet/login/login.dart';
import 'package:vetpet/login/signup.dart';
import 'package:vetpet/owner/add_pet.dart';
import 'package:vetpet/owner/pet_details.dart';
import 'package:vetpet/owner/tabs.dart';
import 'package:vetpet/types.dart';
import 'package:vetpet/vet/add_history.dart';
import 'package:vetpet/vet/client_details.dart';
import 'package:vetpet/vet/tabs.dart';

import 'owner/vet_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Storage.getFirstRoute(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: Colors.blue,
              ),
              initialRoute: '/chat',
              routes: {
                "/login": (context) => const LoginPage(),
                "/signup": (context) => const SignupPage(),
                "/vet/home": (context) => const VetTabs(),
                "/owner/home": (context) => const OwnerTabs(),
                "/owner/addpet": (context) => const AddPet(),
                "/owner/search_vet":(context) => const VetList(),
              },
              onGenerateRoute: (settings) {
                if (settings.name == '/vet/client') {
                  final client = settings.arguments as Owner;
                  return MaterialPageRoute(
                    builder: (context) {
                      return ClientDetails(
                        client: client,
                      );
                    },
                  );
                } else if (settings.name == '/chat') {
                  // final user = settings.arguments as User;
                  return MaterialPageRoute(
                    builder: (context) {
                      return ChatLayout(
                        current: CurrentUser.user!,
                        other: User('v@a.s', 'Vet 1', '',''),
                      );
                    },
                  );
                } else if (settings.name == '/owner/pet_details') {
                  final pet = settings.arguments as Pet;
                  return MaterialPageRoute(
                    builder: (context) {
                      return PetDetails(
                        pet: pet,
                        isVet: false,
                      );
                    },
                  );
                }
                else if (settings.name == '/vet/client/pet') {
                  final pet = settings.arguments as Pet;
                  return MaterialPageRoute(
                    builder: (context) {
                      return PetDetails(
                        pet: pet,
                        isVet: true,
                      );
                    },
                  );
                }
                else if (settings.name == '/vet/client/pet/add_history') {
                  final pet = settings.arguments as Pet;
                  return MaterialPageRoute(
                    builder: (context) {
                      return AddHistory(
                        pet: pet,
                      );
                    },
                  );
                }
                return null;
              },
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
