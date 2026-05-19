import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:islamic_law_reference/services/database_helper.dart';
import 'dart:io';

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  final dbHelper = DatabaseHelper();
  final db = await dbHelper.database;
  final topics = await db.query('topics');
  for (var t in topics) {
    print('Topic: ${t['title']}');
  }
  exit(0);
}
