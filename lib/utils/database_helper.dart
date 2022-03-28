import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_para_yoneticisi/models/category.dart';
import 'package:flutter_para_yoneticisi/models/spending.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper!;
    } else {
      return _databaseHelper!;
    }
  }
  DatabaseHelper._internal();

  _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  //alınan tarih
  String dateFormat(DateTime dt) {
    DateTime today = DateTime.now();
    Duration oneDay = const Duration(days: 1);
    Duration twoDay = const Duration(days: 2);
    Duration oneWeek = const Duration(days: 7);
    String? month;
    switch (dt.month) {
      case 1:
        month = 'Ocak';
        break;
      case 2:
        month = 'Şubat';
        break;
      case 3:
        month = 'Mart';
        break;
      case 4:
        month = 'Nisan';
        break;
      case 5:
        month = 'Mayıs';
        break;
      case 6:
        month = 'Haziran';
        break;
      case 7:
        month = 'Temmuz';
        break;
      case 8:
        month = 'Ağustos';
        break;
      case 9:
        month = 'Eylül';
        break;
      case 10:
        month = 'Ekim';
        break;
      case 11:
        month = 'Kasım';
        break;
      case 12:
        month = 'Aralık';
        break;
    }
    Duration difference = today.difference(dt);
    if (difference.compareTo(oneDay) < 1) {
      return 'Bu gün';
    } else if (difference.compareTo(twoDay) < 1) {
      return 'Dün';
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (dt.weekday) {
        case 1:
          return 'Pazartesi';
        case 2:
          return 'Salı';
        case 3:
          return 'Çarşamba';
        case 4:
          return 'Perşembe';
        case 5:
          return 'Cuma';
        case 6:
          return 'Cumartesi';
        case 7:
          return 'Pazar';
      }
    } else if (dt.year == today.year) {
      return '${dt.day} $month';
    } else {
      return '${dt.day} $month ${dt.year}';
    }
    return '';
  }

  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "spending.db");

    var exists = await databaseExists(path);
    print(path);

    if (!exists) {
      print("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data =
          await rootBundle.load(join("assets/database", "spending.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    return await openDatabase(path, readOnly: false);
  }

  Future<List<Map<String, dynamic>>> categoryRead() async {
    Database db = await _getDatabase();
    var sonuc = await db.query('category');
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> categoryReadIncome() async {
    Database db = await _getDatabase();
    var sonuc = await db.query('category',
        where: 'type= ?', whereArgs: ['Gelir'], orderBy: 'categoryID DESC');
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> categoryReadExpenses() async {
    Database db = await _getDatabase();
    var sonuc = await db.query('category',
        where: 'type= ?', whereArgs: ['Gider'], orderBy: 'categoryID DESC');
    return sonuc;
  }

  Future<int> categoryCreate(Category category) async {
    Database db = await _getDatabase();
    var sonuc = await db.insert('category', category.toMap(),
        nullColumnHack: 'categoryID');
    return sonuc;
  }

  Future<int> categoryUpdate(Category category) async {
    Database db = await _getDatabase();
    var sonuc = await db.update('category', category.toMap(),
        where: 'categoryID= ? ', whereArgs: [category.categoryID]);
    return sonuc;
  }

  Future<int> categoryDelete(int categoryID) async {
    Database db = await _getDatabase();
    var sonuc = await db
        .delete('category', where: 'categoryID= ? ', whereArgs: [categoryID]);
    return sonuc;
  }

  ///spending CRUD

  Future<List<Map<String, dynamic>>> spendingRead() async {
    Database db = await _getDatabase();
    var sonuc = await db.rawQuery(
        'SELECT * FROM spending INNER JOIN category ON category.categoryID= spending.categoryID ORDER BY spendingID Desc ');
    return sonuc;
  }

  Future getTotalIncome() async {
    var db = await _getDatabase();
    var result =
        await db.rawQuery("SELECT SUM(incomeMoney) AS TOTAL FROM spending");

    return result.toList();
  }

  Future getTotalExpenses() async {
    var db = await _getDatabase();
    var result =
        await db.rawQuery("SELECT SUM(expensesMoney) AS TOTAL FROM spending");

    return result.toList();
  }

  Future<List<Spending>> spendingList() async {
    var spendingMapList = await spendingRead();
    var spendingList = <Spending>[];
    for (Map<String, dynamic> readMap in spendingMapList) {
      spendingList.add(Spending.fromMap(readMap));
    }
    return spendingList;
  }

  Future<int> spendingCreate(Spending spending) async {
    Database db = await _getDatabase();
    var sonuc = await db.insert('spending', spending.toMap());
    return sonuc;
  }

  Future<int> spendingUpdate(Spending spending) async {
    Database db = await _getDatabase();
    var sonuc = await db.update('spending', spending.toMap(),
        where: 'spendingID= ? ', whereArgs: [spending.spendingID]);
    return sonuc;
  }

  Future<int> spendingDelete(int spendingID) async {
    Database db = await _getDatabase();
    var sonuc = await db
        .delete('spending', where: 'spendingID= ? ', whereArgs: [spendingID]);
    return sonuc;
  }
}
