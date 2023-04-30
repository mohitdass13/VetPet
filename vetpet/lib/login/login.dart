import 'package:flutter/material.dart';

import '../api/authentication.dart';
import '../common/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;
  final emailReg = RegExp(r'^[a-zA-Z0-9_.-]+@[a-zA-Z]+\.[a-zA-Z]+$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText: 'Email', icon: Icon(Icons.mail)),
              validator: (value) => value != null && emailReg.hasMatch(value)
                  ? 'Invalid Email'
                  : null,
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> map =
                      await Authentication.requestOtp(_emailController.text);
                  if (mounted) {
                    Utils.showSnackbar(context, map["response"]);
                    if (map["success"]) {
                      setState(() {
                        _otpSent = true;
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
                child: const Text("Get Otp"),
              ),
            ),
            TextFormField(
              controller: _otpController,
              decoration: const InputDecoration(
                  labelText: 'OTP', icon: Icon(Icons.key)),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: _otpSent == false
                    ? null
                    : () async {
                        Map<String, dynamic> map =
                            await Authentication.verifyOtp(
                                _emailController.text, _otpController.text);
                        String role = map["role"];
                        if (map["success"]) {
                          if (mounted) {
                            Navigator.popAndPushNamed(
                              context,
                              role == "owner" ? '/owner/home' : '/vet/home',
                            );
                          }
                        } else {
                          if (mounted) {
                            Utils.showSnackbar(context, map['response']);
                          }
                        }
                      },
                child: const Text("Login")),
            const SizedBox(
              height: 10,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                const Divider(
                  color: Colors.black,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: const Text(
                    'Don\'t have an account ?',
                  ),
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text("Register")),
          ],
        ),
      ),
    );
  }
}
