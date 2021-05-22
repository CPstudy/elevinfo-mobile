import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static const int historyNo = 0;
  static const int historyAddress = 1;
  static const int historyQR = 2;
  static const int historyAddressToNo = 3;

  static const String dbElev = 'elevdata.db';

  static const String historyTable = 'history_table';

  static final DatabaseHelper _instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Database _elevDB;
  Future<Database> get elevDB async {
    if(_elevDB != null) return _elevDB;
    _elevDB = await initDatabase(dbElev);
    return _elevDB;
  }

  Future<Database> initDatabase(String name) async {
    String dir = await getDatabasesPath();
    String path = join(dir, name);

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      print('Not Found Database');

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch(_) {}

      ByteData data = await rootBundle.load('data/$name');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);

    } else {
      print('Found Database');
    }

    return await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> historyAllList() async {
    Database db = await elevDB;

    List<Map<String, dynamic>> list = await db.rawQuery('SELECT * FROM $historyTable ORDER BY id DESC LIMIT 0, 100');
    return list;
  }

  Future<int> addHistoryNumber(String no) async {
    Database db = await elevDB;

    int result = await db.rawInsert(
      'INSERT INTO $historyTable (no, address1, address2, search_date, search_type) VALUES (?, ?, ?, ?, ?)',
      [no, null, null, DateTime.now().toString(), historyNo],
    );

    return result;
  }

  Future<int> addHistoryAddress(String address1, String address2) async {
    Database db = await elevDB;

    int result = await db.rawInsert(
      'INSERT INTO $historyTable (no, address1, address2, search_date, search_type) VALUES (?, ?, ?, ?, ?)',
      [null, address1, address2, DateTime.now().toString(), historyAddress],
    );

    return result;
  }

  Future<int> addHistoryAddressToNo(String no, String address1, String address2) async {
    Database db = await elevDB;

    int result = await db.rawInsert(
      'INSERT INTO $historyTable (no, address1, address2, search_date, search_type) VALUES (?, ?, ?, ?, ?)',
      [no, address1, address2, DateTime.now().toString(), historyAddressToNo],
    );

    return result;
  }

  Future<int> addHistoryQR(String no) async {
    Database db = await elevDB;

    int result = await db.rawInsert(
      'INSERT INTO $historyTable (no, address1, address2, search_date, search_type) VALUES (?, ?, ?, ?, ?)',
      [no, null, null, DateTime.now().toString(), historyQR],
    );

    return result;
  }
  
  Future<int> deleteHistory(int id) async {
    Database db = await elevDB;
    
    int result = await db.rawDelete('DELETE FROM $historyTable WHERE id = ?', [id]);
    return result;
  }
}