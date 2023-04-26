import 'package:flutter/material.dart';
import 'package:vetpet/common/chat.dart';
import 'package:vetpet/login/login.dart';
import 'package:vetpet/login/signup.dart';
import 'package:vetpet/owner/tabs.dart';
import 'package:vetpet/types.dart';
import 'package:vetpet/vet/client_details.dart';
import 'package:vetpet/vet/tabs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      // initialRoute: '/vet/home',
      initialRoute: '/login',
      routes: {
        "/login": (context) => const LoginPage(),
        "/signup": (context) => const SignupPage(),
        "/vet/home": (context) => const VetTabs(),
        "/owner/home": (context) => const OwnerTabs(),
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
          final user = settings.arguments as User;
          return MaterialPageRoute(
            builder: (context) {
              return ChatLayout(
                current: User('email', 'name'),
                other: user,
              );
            },
          );
        }
        return null;
      },
    );
  }
}
