import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
  final port = '8080';
  final host = 'http://0.0.0.0:$port';
  late Process p;
  final baseUrl = '/api';

  // setUpAll(() async {
  //   p = await Process.start(
  //     'dart',
  //     ['run', 'bin/server.dart'],
  //     environment: {'PORT': port},
  //   );
  //   // Wait for server to start and print to stdout.
  //   await p.stdout.first;
  // });
  //jsonEncode({"email":"kbsingh296@gmail.com"})
  // tearDownAll(() => p.kill(ProcessSignal.sigkill));
  
  test('Request OTP', () async {
    final response = await post(
      Uri.parse('$host$baseUrl/login/requestotp/'),
      body: '{"email": "kbsingh296@gmail.com"}',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );
    expect(response.statusCode, 200);

    // response = await post(
    //   Uri.parse('$host$baseUrl/login/requestotp/'),
    //   body: '{"email": "kbsingh@gmail.com"}',
    //   headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    // );

  });

//   test('Root', () async {
//     final response = await get(Uri.parse('$host/'));
//     expect(response.statusCode, 200);
//     expect(response.body, 'Hello, World!\n');
//   });
//
//   test('Echo', () async {
//     final response = await get(Uri.parse('$host/echo/hello'));
//     expect(response.statusCode, 200);
//     expect(response.body, 'hello\n');
//   });
//
//   test('404', () async {
//     final response = await get(Uri.parse('$host/foobar'));
//     expect(response.statusCode, 404);
//   });
//
//   test('vet info', () async {
//     final response = await get(Uri.http(
//         'localhost:8080', '/api/vet/details', {'email': 'navroop005@gmail.com'}));
//     expect(response.statusCode, 200);
//     print(response.body);
//   });
//
//   test('owner info', () async {
//     final response = await get(Uri.http(
//         'localhost:8080', '/api/owner/details', {'email': '2020csb1101@iitrpr.ac.in'}));
//     expect(response.statusCode, 200);
//     print(response.body);
//   });
}
