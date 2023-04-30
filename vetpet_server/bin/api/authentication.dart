import 'dart:math';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shelf/shelf.dart';

import '../database/authentication.dart';
import 'user.dart';

/// Handles login and authentication
class AuthApi {
  final _username = 'depmohit@gmail.com';
  final _password = 'BqAfVOWUSCIGw8LF';

  late final smtpServer = SmtpServer(
    'smtp-relay.sendinblue.com',
    port: 587,
    username: _username,
    password: _password,
  );

  Future<Response> sendOtp(String emailAddress) async {
    if (!await UserApi.userExist(emailAddress)) {
      return Response.unauthorized("Email does not exist");
    }

    int otp = 10000 + Random().nextInt(89999);
    await AuthDB.saveOtp(emailAddress, otp);
    String body = "Your OTP for email verification is $otp";
    print(body);

    final message = Message()
      ..from = Address(_username, 'VetPet')
      ..recipients.add(emailAddress)
      ..subject = 'Email verification'
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      print(sendReport.toString());
      return Response.ok('OTP sent successfully');
    } on MailerException catch (e) {
      print('Message not sent: ${e.problems}');
      print(e);
      return Response.internalServerError(body: "Server error");
    }
  }

  String generateRandomString(int len) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(
      len,
      (index) => chars[Random().nextInt(chars.length)],
    ).join();
  }

  Future<Map<String, dynamic>?> verifyOtp(String emailAddress, int otp) async {
    bool verified = await AuthDB.verifyOtp(emailAddress, otp);
    if (verified) {
      String apiKey = generateRandomString(20);
      await AuthDB.storeLoggedIn(emailAddress, apiKey);
      String userType = (await UserApi.userType(emailAddress))!;
      return {'user_type': userType, 'api_key': apiKey};
    }
    return null;
  }

  Future<bool> verifyKey(String email, String key) {
    return AuthDB.verifyKey(email, key);
  }

  Future<bool> addUser(String email, String role) async {
    if (role != 'vet' && role != 'owner') {
      return false;
    }

    return AuthDB.addUser(email, role);
  }

  Future<bool> addVet(String email, String name, String phone, String wTime,
      String state) async {
    if (await UserApi.userType(email) == 'vet') {
      return AuthDB.addVet(email, name, phone, wTime, state);
    }
    return false;
  }

  Future<bool> addOwner(
      String email, String name, String phone, String state) async {
    if (await UserApi.userType(email) == 'owner') {
      return AuthDB.addOwner(email, name, phone, state);
    }
    return false;
  }
}
