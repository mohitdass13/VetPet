import 'package:flutter/material.dart';
import 'package:vetpet/api/authentication.dart';
import 'package:vetpet/common/utils.dart';

class Registration extends StatefulWidget {
  const Registration({super.key, required this.role});
  final String role;

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _workingTime = TextEditingController();
  String? _state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: "Name",
                  labelStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 19,
                  )),
            ),
            TextFormField(
              controller: _phone,
              decoration: const InputDecoration(
                  icon: Icon(Icons.phone),
                  labelText: "Phone Number",
                  labelStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 19,
                  )),
            ),
            if (widget.role == "vet")
              TextFormField(
                controller: _workingTime,
                decoration: const InputDecoration(
                    icon: Icon(Icons.work),
                    labelText: "Working time",
                    labelStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: 19,
                    )),
              ),
            const SizedBox(
              height: 17,
            ),
            Row(
              children: const [
                Icon(Icons.location_on),
                SizedBox(
                  width: 15,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select State:',
                    style: TextStyle(fontSize: 19, color: Colors.black87),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 250),
                child: DropdownButton<String>(
                  alignment: Alignment.centerLeft,
                  isExpanded: true,
                  value: _state,
                  items: states
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _state = value;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: (_state == null)
                  ? null
                  : () async {
                      Map<String, dynamic> response;
                      if (widget.role == "vet") {
                        response = await Authentication.addVet(_name.text,
                            _phone.text, _workingTime.text, _state!);
                        if (response["success"] == true) {
                          if (mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              "/vet/home",
                              (route) => false,
                            );
                          }
                        }
                      } else {
                        response = await Authentication.addOwner(
                            _name.text, _phone.text, _state!);
                        if (response["success"] == true) {
                          if (mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              "/owner/home",
                              (route) => false,
                            );
                          }
                        } else {
                          if (mounted) {
                            Utils.showSnackbar(context, response['response']);
                          }
                        }
                      }
                    },
              child: const Text("Register"),
            )
          ],
        ),
      ),
    );
  }

  List<String> states = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Delhi",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu & Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Maharashtra",
    "Madhya Pradesh",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Tripura",
    "Telangana",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
    "Andaman & Nicobar (UT)",
    "Chandigarh (UT)",
    "Dadra & Nagar Haveli (UT)",
    "Daman & Diu (UT)",
    "Lakshadweep (UT)",
    "Puducherry (UT)",
  ];
}
