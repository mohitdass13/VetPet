import 'package:postgres_pool/postgres_pool.dart';

class Database {
  final connection = PgPool(
    PgEndpoint(
      host: 'localhost',
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
