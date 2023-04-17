import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;

  String role = "";
  String email = "";
  String otp = "";
  final emailReg = RegExp(r'^[a-zA-Z0-9_.-]+@[a-zA-Z]+\.[a-zA-Z]+$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 10),
                    backgroundColor: role == 'vet'
                        ? Colors.green[600]
                        : Colors.blueGrey[400],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      role = "vet";
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (role == "vet") const Icon(Icons.check),
                      if (role == "vet")
                        const SizedBox(
                          width: 3,
                        ),
                      const Text('Veterinary'),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 10),
                    backgroundColor: role == 'owner'
                        ? Colors.green[600]
                        : Colors.blueGrey[400],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      role = "owner";
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (role == "owner") const Icon(Icons.check),
                      if (role == "owner")
                        const SizedBox(
                          width: 3,
                        ),
                      const Text('Pet Owner'),
                    ],
                  ),
                ),
              ],
            ),
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
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  // List response = await Authentication.requestOTP(
                  //     _emailController.text);
                  // _otpSent=response[0];
                  // String message = response[1];
                  // if (mounted) {
                  //   ScaffoldMessenger.of(context)
                  //       .showSnackBar(SnackBar(
                  //     content: Text(message),
                  //   ));
                  //   if (_otpSent) {
                  //     setState(() {});
                  //   }
                  // }
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
            ElevatedButton(onPressed: () {}, child: const Text("Submit"))
          ],
        ),
      ),
    );
  }
}
