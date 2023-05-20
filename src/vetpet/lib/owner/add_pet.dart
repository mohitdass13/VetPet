import 'package:flutter/material.dart';
import 'package:vetpet/api/owner_api.dart';
import 'package:vetpet/common/utils.dart';
import 'package:vetpet/types.dart';

class AddPet extends StatefulWidget {
  const AddPet({Key? key}) : super(key: key);

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'age': TextEditingController(),
    'vet_id': TextEditingController(),
    'weight': TextEditingController(),
  };

  int hisCount = 0;
  List<String> breeds = [];
  String? breedValue;

  // List<TextEditingController> historyControllers = [];

  @override
  void initState() {
    super.initState();
    // breeds.add('--Select Breed--');
    breeds.addAll(breed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: (breedValue != null &&
                    controllers['name']!.value.text.isNotEmpty &&
                    controllers['age']!.value.text.isNotEmpty &&
                    controllers['weight']!.value.text.isNotEmpty)
                ? () async {
                    bool added = await OwnerApi.addPet(Pet(
                      0,
                      controllers['name']!.value.text,
                      int.parse(controllers['age']!.value.text),
                      breedValue!,
                      double.parse(controllers['weight']!.value.text),
                    ));
                    if (mounted) {
                      if (added) {
                        Navigator.pop(context);
                        Utils.showSnackbar(
                            context, "Pet Added! Tap refresh to show!");
                      } else {
                        Utils.showSnackbar(context, "Error");
                      }
                    }
                  }
                : null,
            child: const Text(
              'Add',
              style: TextStyle(
                fontSize: 17,
                // color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 20, 20),
          child: Column(
            children: [
              TextFormField(
                controller: controllers['name'],
                decoration: InputDecoration(
                  labelText: 'Name',
                  icon: Column(
                    children: const [
                      SizedBox(
                        height: 15,
                      ),
                      Icon(
                        Icons.person,
                      ),
                    ],
                  ),
                ),
              ),
              TextFormField(
                controller: controllers['age'],
                decoration: InputDecoration(
                  labelText: 'Age',
                  icon: Column(
                    children: const [
                      SizedBox(
                        height: 15,
                      ),
                      Icon(
                        Icons.calendar_month,
                      ),
                    ],
                  ),
                  errorText: RegExp(r'^[0-9]*$')
                              .hasMatch(controllers['age']!.value.text) ==
                          false
                      ? 'Please enter valid age'
                      : null,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const Icon(Icons.pets),
                  const SizedBox(
                    width: 17,
                  ),
                  DropdownButton(
                    borderRadius: BorderRadius.circular(20),
                    hint: const Text('--Select Breed--'),
                    value: breedValue,
                    items: breeds
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        breedValue = value!;
                      });
                    },
                  ),
                ],
              ),
              TextFormField(
                controller: controllers['weight'],
                decoration: InputDecoration(
                  labelText: 'Weight (in kg)',
                  icon: Column(
                    children: const [
                      SizedBox(
                        height: 15,
                      ),
                      Icon(
                        Icons.scale_sharp,
                      ),
                    ],
                  ),
                  errorText: RegExp(r"^\d*(\.)?\d*$").hasMatch(
                                  controllers['weight']!.value.text) ==
                              false &&
                          controllers['weight']!.value.text.isNotEmpty
                      ? 'Please enter valid weight'
                      : null,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 20,
              ),
              // ...historyControllers
              //     .map((e) => Column(
              //           children: [
              //             const SizedBox(
              //               height: 15,
              //             ),
              //             Container(
              //               padding: const EdgeInsets.all(10),
              //               decoration: BoxDecoration(
              //                 border: Border.all(
              //                   color: Colors.grey,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //               child: Column(
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   GetHistory(),
              //                   const Divider(),
              //                   IconButton(
              //                     onPressed: () {
              //                       setState(() {
              //                         historyControllers.remove(e);
              //                         hisCount--;
              //                       });
              //                     },
              //                     icon: const Icon(
              //                       Icons.delete,
              //                       color: Colors.red,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             const SizedBox(
              //               height: 15,
              //             ),
              //           ],
              //         ))
              //     .toList(),
              // Stack(
              //   alignment: Alignment.center,
              //   children: [
              //     const Divider(),
              //     ElevatedButton(
              //       onPressed: () => setState(() {
              //         historyControllers.add(TextEditingController());
              //         // historyControllers.add({'name': TextEditingController(), 'date': TextEditingController(), 'description': TextEditingController()});
              //         // hisCount++;
              //       }),
              //       child: const Text('Add History'),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}

