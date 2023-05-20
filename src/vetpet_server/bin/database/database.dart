import 'dart:io';

import 'package:postgres_pool/postgres_pool.dart';

class Database {
  static final connection = PgPool(
    PgEndpoint(
      host: Platform.environment['POSTGRES_HOST'] ??  'localhost',
      port: 5432,
      database: 'vetpet',
      username: 'postgres',
      password: '12345',
    ),
    settings: PgPoolSettings()
      ..maxConnectionAge = Duration(hours: 1)
      ..concurrency = 4,
  );
}
