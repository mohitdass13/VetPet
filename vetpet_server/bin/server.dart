import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'api/authentication.dart';
import 'api/user.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  ..post('/api/signup/add_user/', _signupUser)
  ..post('/api/signup/vet/', _signupVet)
  ..post('/api/signup/owner/', _signupOwner)
  ..post('/api/login/requestotp/', _otpRequest)
  ..post('/api/login/verifyotp/', _otpVerify)
  ..get('/api/vet/details', _vetInfo)
  ..get('/api/owner/details', _ownerInfo);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

AuthApi auth = AuthApi();

Future<bool> verifyUser(Request request, String role) async {
  String? email = request.headers['email'];
  String? key = request.headers['authorization'];
  if (email == null || key == null) {
    return false;
  }
  bool verified = await auth.verifyKey(email, key);
  String userType = await auth.userType(email);
  if (!verified || userType != role) {
    return false;
  }
  return true;
}

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
    return Response.ok(jsonEncode(verification));
  } else {
    return Response.forbidden("Incorrect OTP!");
  }
}

Future<Response> _signupUser(Request req) async {
  Map<String, dynamic> content = jsonDecode(await req.readAsString());
  String? email = content['email'];
  String? role = content['role'];
  if (email == null || role == null) {
    return Response.badRequest();
  }

  if (await auth.addUser(email, role)) {
    return await auth.sendOtp(email);
  } else {
    return Response.internalServerError();
  }
}

Future<Response> _signupVet(Request req) async {
  Map<String, dynamic> content = jsonDecode(await req.readAsString());
  String email = content['email'];
  String name = content['name'];
  String phone = content['phone'];
  String wTime = content['working_time'];
  String state = content['state'];

  if (await auth.addVet(email, name, phone, wTime, state)) {
    return Response.ok('Vet added!');
  } else {
    return Response.internalServerError();
  }
}

Future<Response> _signupOwner(Request req) async {
  Map<String, dynamic> content = jsonDecode(await req.readAsString());
  String email = content['email'];
  String name = content['name'];
  String phone = content['phone'];
  String state = content['state'];

  if (await auth.addOwner(email, name, phone, state)) {
    return Response.ok('Owner added!');
  } else {
    return Response.internalServerError();
  }
}

Future<Response> _vetInfo(Request request) async {
  String email = request.headers['email']!;
  final data =
      await UserApi.getInfo(email, 'vet', !await verifyUser(request, 'vet'));
  if (data == null) {
    return Response.notFound("No vet");
  } else {
    return Response.ok(jsonEncode(data));
  }
}

Future<Response> _ownerInfo(Request request) async {
  String email = request.headers['email']!;
  final data = await UserApi.getInfo(
      email, 'owner', !await verifyUser(request, 'owner'));
  if (data == null) {
    return Response.notFound("No vet");
  } else {
    return Response.ok(jsonEncode(data));
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
