import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'api/authentication.dart';
import 'database/authentication.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  ..post('/api/login/requestotp/', _otpRequest)
  ..post('/api/login/verifyotp/', _otpVerify);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

AuthApi auth = AuthApi();

Future<Response> _otpRequest(Request req) async {
  dynamic content = jsonDecode(await req.readAsString());
  String emailAddress = content['email'];
  print("OTP request: $emailAddress");
  return await auth.sendOtp(emailAddress);
}

Future<Response> _otpVerify(Request req) async {
  Map<String, dynamic> content = jsonDecode(await req.readAsString());
  dynamic otp = content['otp'];
  String email = content['email'];
  print("OTP validation: $otp");
  int? otpInt;
  if (otp.runtimeType == String) {
    otpInt = int.tryParse(otp);
  } else if (otp.runtimeType == int) {
    otpInt = otp;
  }
  if (otpInt == null) {
    return Response.badRequest(body: 'No OTP');
  }
  final verification = await auth.verifyOtp(email, otpInt);
  if (verification != null) {
    return Response.ok(
        "OTP Verified! Logging in as ${verification['user_type']}...",
        headers: {'authorization': verification['api_key']});
  } else {
    return Response.forbidden("Incorrect OTP!");
  }
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
