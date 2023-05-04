import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vetpet/api/owner_api.dart';

import '../common/utils.dart';
import '../types.dart';

class AddHistory extends StatefulWidget {
  const AddHistory({Key? key, required this.pet}) : super(key: key);
  final Pet pet;

  @override
  State<AddHistory> createState() => _AddHistoryState();
}

class _AddHistoryState extends State<AddHistory> {
  TextEditingController nameController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TextEditingController descriptionController = TextEditingController();
  FilePickerResult? fileResult;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void getFile() async {
    fileResult = await FilePicker.platform.pickFiles();
    if (fileResult != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add History'),
        leading: BackButton(
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (nameController.value.text.isEmpty) {
                Utils.showSnackbar(context, "Name cannot be empty");
                return;
              }
              bool added;
              try {
                added = await OwnerApi.addHistory(PetHistory(
                  widget.pet.id,
                  nameController.value.text,
                  descriptionController.value.text,
                  selectedDate,
                  "Vaccination",
                  fileResult?.files.single.name,
                  fileResult?.files.single.bytes,
                ));
              } catch (e) {
                Utils.showSnackbar(context, "Error");
                return;
              }
              if (mounted) {
                if (added) {
                  Navigator.pop(context);
                  Utils.showSnackbar(context, "History Added");
                } else {
                  Utils.showSnackbar(context, "Error");
                }
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                icon: Column(
                  children: const [
                    SizedBox(
                      height: 15,
                    ),
                    Icon(
                      Icons.history,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(children: [
              const Icon(Icons.calendar_month),
              const SizedBox(
                width: 17,
              ),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${selectedDate.toLocal()}'.split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ]),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Icon(Icons.picture_as_pdf),
                const SizedBox(
                  width: 17,
                ),
                if (fileResult != null)
                  Flexible(
                    child: Text(
                      fileResult!.files.single.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                else
                  const Text('No file selected'),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () => getFile(),
                  child: fileResult == null
                      ? const Text('Upload File')
                      : const Text("Change File"),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: descriptionController,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                icon: Column(
                  children: const [
                    SizedBox(
                      height: 15,
                    ),
                    Icon(
                      Icons.description,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
