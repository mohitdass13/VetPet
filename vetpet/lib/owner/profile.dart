import 'package:flutter/material.dart';

class OwnerProfile extends StatelessWidget {
  const OwnerProfile({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Column(
          children: const [
            SizedBox(
              height: 30,
            ),
             Text(
                'Name:',
                style: TextStyle(fontSize: 17),
              ),
            
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Phone Number:',
                style: TextStyle(fontSize: 17),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'State:',
                style: TextStyle(fontSize: 17),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
