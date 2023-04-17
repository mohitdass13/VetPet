import 'package:flutter/material.dart';
import 'package:vetpet/owner/tabs.dart';
import 'package:vetpet/signup.dart';
import 'package:vetpet/vet/tabs.dart';

import 'login.dart';

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
        primarySwatch: Colors.red,
      ),
      initialRoute: '/signup',
      routes: {
        "/login": (context) => const LoginPage(),
        "/signup": (context) => const SignupPage(),
        "/vet/home": (context) => const VetTabs(),
        "/owner/home": (context) => const OwnerTabs(),
      },
    );
  }
}
