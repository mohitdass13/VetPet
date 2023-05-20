import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'api/authentication.dart';
import 'api/chat.dart';
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
  ..get('/api/vet/list', _vetList)
  ..get('/api/owner/details', _ownerInfo)
  ..post('/api/chat/send', _chatSend)
  ..get('/api/chat/retrieve', _chatRetrieve)
  ..post('/api/pet/add', _addPet)
  ..get('/api/owner/pets', _getPets)
  ..post('/api/vet/client/pet/add_history/add', _addHistory)
  ..post('/api/pet/remove', _removePet)
  ..get('/api/owner/pets', _getPets)
  ..post('/api/owner/request', _requestVet)
  ..get('/api/owner/connections', _ownerConnections)
  ..get('/api/vet/connections', _vetConnections)
  ..post('/api/owner/request', _requestVet)
  ..get('/pet/history', _getHistory)
  ..post('/vet/accept', _vetAccept)
  ;

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

AuthApi auth = AuthApi();

Future<bool> verifyUser(Request request, String? role) async {
  String? email = request.headers['email'];
  String? key = request.headers['authorization'];
  if (email == null || key == null) {
    return false;
  }
  bool verified = await auth.verifyKey(email, key);
  if (role != null) {
    String? userType = await UserApi.userType(email);
    if (!verified || userType != role) {
      return false;
    }
  }
  return verified;
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

Future<Response> _addPet(Request request) async {
  if (!await verifyUser(request, 'owner')) {
    return Response.unauthorized('invalid user');
  }
  Map<String, dynamic> content = jsonDecode(await request.readAsString());
  String name = content['name'];
  String breed = content['breed'];
  double weight = content['weight'];
  int age = content['age'];
  String? email = request.headers['email'];

  if (await UserApi.addPet(name, age, weight, breed, email!)) {
    return Response.ok('Pet added!');
  } else {
    return Response.internalServerError();
  }
}

Future<Response> _addHistory(Request request) async {
  Map<String, dynamic> content = jsonDecode(await request.readAsString());
  String petId = content['pet_id'];
  String name = content['name'];
  String? description = content['description'];
  String date = content['date'];
  String type = content['type'];
  String? fileName = content['file_name'];
  Uint8List fileData = Uint8List.fromList(
      content['file_data'].split(',').map((e) => int.parse(e)).toList());
  if (!await verifyUser(request, null)) {
    return Response.unauthorized('invalid user');
  }

  if (await UserApi.addHistory(
      petId, name, description!, date, type, fileName!, fileData)) {
    return Response.ok('Pet added!');
  } else {
    return Response.internalServerError();
  }
}

Future<Response> _removePet(Request request) async {
  if (!await verifyUser(request, null)) {
    return Response.unauthorized('invalid user');
  }
  String? email = request.headers['email'];
  Map<String, dynamic> content = jsonDecode(await request.readAsString());

  final removed = await UserApi.removePet(content['id'], email!);
  if (removed) {
    return Response.ok('Pet removed');
  } else {
    return Response.notFound('No pet found');
  }
}

Future<Response> _getPets(Request request) async {
  String? email = request.headers['email'];
  if (!await verifyUser(request, null)) {
    return Response.unauthorized('invalid user');
  }

  final data = await UserApi.getPets(email!);

  return Response.ok(jsonEncode(data));
}

Future<Response> _getHistory(Request request) async {
  String? petId = request.headers['pet_id'];

  final data = await UserApi.getHistory(petId!);

  return Response.ok(jsonEncode(data));
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

Future<Response> _vetList(Request request) async {
  if (!await verifyUser(request, null)) {
    return Response.unauthorized('Invalid credentials');
  }

  final data = await UserApi.getVets();
  return Response.ok(jsonEncode(data));
}

Future<Response> _ownerInfo(Request request) async {
  String email = request.headers['email']!;
  final data = await UserApi.getInfo(
      email, 'owner', !await verifyUser(request, 'owner'));
  if (data == null) {
    return Response.notFound("No owner");
  } else {
    return Response.ok(jsonEncode(data));
  }
}

Future<Response> _chatSend(Request request) async {
  Map<String, dynamic> content = jsonDecode(await request.readAsString());
  if (!await verifyUser(request, null)) {
    return Response.unauthorized('Invalid credentials');
  }
  String? email = request.headers['email'];
  String? to = content['to'];
  String? message = content['message'];

  if (email == null || to == null || message == null) {
    return Response.badRequest();
  } else {
    if (await ChatAPI.sendMessage(email, to, message)) {
      return Response.ok("Message sent");
    } else {
      return Response.internalServerError();
    }
  }
}

Future<Response> _requestVet(Request request) async {
  if (!await verifyUser(request, 'owner')) {
    return Response.unauthorized('Invalid credentials');
  }
  String email = request.headers['email']!;

  Map<String, dynamic> content = jsonDecode(await request.readAsString());
  List<int> petIds = (content['pet_ids'] as List<dynamic>).cast<int>();
  String vetEmail = content['vet_id'];

  if (await UserApi.requestVet(petIds, vetEmail, email)) {
    return Response.ok('Request sent');
  } else {
    return Response.internalServerError();
  }
}

Future<Response> _vetAccept(Request request) async {
  if (!await verifyUser(request, 'owner')) {
    return Response.unauthorized('Invalid credentials');
  }
  String email = request.headers['email']!;
  Map<String, dynamic> content = jsonDecode(await request.readAsString());

  String owner = content['owner_id'];

  if (await UserApi.vetAccept( email, owner)) {
    return Response.ok('Request sent');
  } else {
    return Response.internalServerError();
  }
}

Future<Response> _ownerConnections(Request request) async {
  if (!await verifyUser(request, 'owner')) {
    return Response.unauthorized('Invalid credentials');
  }
  String email = request.headers['email']!;
  
  final data = await UserApi.ownerConnections(email);
  return Response.ok(jsonEncode(data));
}

Future<Response> _vetConnections(Request request) async {
  if (!await verifyUser(request, 'vet')) {
    return Response.unauthorized('Invalid credentials');
  }
  String email = request.headers['email']!;
  
  final data = await UserApi.vetConnections(email);
  return Response.ok(jsonEncode(data));
}

Future<Response> _chatRetrieve(Request request) async {
  if (!await verifyUser(request, null)) {
    return Response.unauthorized('Invalid credentials');
  }
  Map<String, dynamic> content = request.requestedUri.queryParameters;

  String email = request.headers['email']!;
  String other = content['other'];
  String time = content['time'];

  final data =
      await ChatAPI.retrieveMessagesJSON(email, other, DateTime.parse(time));

  return Response.ok(data);
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
