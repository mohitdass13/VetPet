import 'dart:math';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shelf/shelf.dart';

import 'database.dart';

class Authentication {
  final _username = 'depmohit@gmail.com';
  final _password = 'BqAfVOWUSCIGw8LF';

  Future<Response> sendOtp(String emailAddress) async {
    if (!await Database.userExist(emailAddress)) {
      return Response.unauthorized("Email does not exist");
    }

    Random random = Random();
    int otp = random.nextInt(89999) + 10000;
    await Database.saveOtp(emailAddress, otp);
    String body = "Your OTP for email verification is $otp";
    print(body);

    final message = Message()
      ..from = Address(_username, 'VetPet')
      ..recipients.add(emailAddress)
      ..subject = 'Email verification'
      ..text = body;

    final smtpServer = SmtpServer(
      'smtp-relay.sendinblue.com',
      port: 587,
      username: _username,
      password: _password,
    );

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
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

  Future<Response> verifyOtp(String emailAddress, int otp) async {
    bool verified = await Database.verifyOtp(emailAddress, otp);
    if (verified) {
      String apiKey = generateRandomString(20);
      await Database.storeLoggedIn(emailAddress, apiKey);
      String userType = await Database.userType(emailAddress);
      return Response.ok("OTP Verified:$userType",
          headers: {'authorization': apiKey});
    } else {
      return Response.forbidden("OTP Incorrect");
    }
  }
}
