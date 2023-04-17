import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:vetpet/authentication.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});
  String role = "";
  String email = "";
  String otp = "";
  final emailReg = RegExp(r'^[a-zA-Z0-9_.-]+@[a-zA-Z]+\.[a-zA-Z]+$');
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;

  
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
                      fixedSize: Size(150, 10),
                      backgroundColor:
                          widget.role == "owner" || widget.role == ""
                              ? Colors.blueGrey[400]
                              : Colors.green[600]),
                  onPressed: () {
                    setState(() {
                      widget.role = "vet";
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.role == "vet") Icon(Icons.check),
                      if (widget.role == "vet")
                        SizedBox(
                          width: 3,
                        ),
                      Text('Veterinary'),
                    ],
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(150, 10),
                        backgroundColor:
                            widget.role == "vet" || widget.role == ""
                                ? Colors.blueGrey[400]
                                : Colors.green[600]),
                    onPressed: () {
                      setState(() {
                        widget.role = "owner";
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.role == "owner") Icon(Icons.check),
                        if (widget.role == "owner")
                          SizedBox(
                            width: 3,
                          ),
                        Text('Pet Owner'),
                      ],
                    )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  // hintText: 'Enter e-mail',

                  labelText: 'Email',
                  icon: Icon(Icons.mail)),
              validator: (value) =>
                  value != null && widget.emailReg.hasMatch(value)
                      ? 'Invalid Email'
                      : null,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                                  List response = await Authentication.requestOTP(
                                      _emailController.text);
                                  _otpSent=response[0];
                                  String message = response[1];
                                  if (mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(message),
                                    ));
                                    if (_otpSent) {
                                      setState(() {});
                                    }
                                  }
                                },
                child: Text("Get Otp"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ),
            TextFormField(
              controller: _otpController,
              decoration: const InputDecoration(
                  // hintText: 'Enter e-mail',
                  labelText: 'OTP',
                  icon: Icon(Icons.key)),
            ),
            ElevatedButton(onPressed: () {}, child: Text("Submit"))
          ],
        ),
      ),
    );
  }
}
