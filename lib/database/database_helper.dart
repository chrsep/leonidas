import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  Database db;

  Future<void> open() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'leonidas.db');
    db ??= await openDatabase(path);
  }

  Future<void> close() async {
    await db.close();
  }
}
