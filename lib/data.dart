import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableMath = 'math';
final String columnId = 'id';
final String columnDateTime = 'dateTime';
final String columnNote = 'note';
final String columnMinutes = 'minutes';

class SeshInfo {
  int id;
  DateTime dateTime;
  String note;
  int minutes;

  SeshInfo({
    this.id,
    this.dateTime,
    this.note,
    this.minutes,
  });

  factory SeshInfo.fromMap(Map<String, dynamic> json) => SeshInfo(
        id: json["id"],
        dateTime: DateTime.parse(json["dateTime"]),
        note: json["note"],
        minutes: json["minutes"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "dateTime": dateTime.toIso8601String(),
        "note": note,
        "minutes": minutes,
      };
}

class DatabaseHelper {
  static Database _database;
  static DatabaseHelper _databaseHelper;

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "math.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tableMath (
          $columnId integer primary key autoincrement,
          $columnDateTime text not null,
          $columnNote text not null,
          $columnMinutes integer
          )
        ''');
      },
    );
    return database;
  }

  insertSesh(SeshInfo seshInfo) async {
    var db = await this.database;
    var result = await db.insert(tableMath, seshInfo.toMap());
    //print('result : $result');
    return result;
  }

  getSeshs() async {
    List<SeshInfo> _meds = [];

    var db = await this.database;
    var result = await db.query(tableMath);
    result.forEach((element) {
      var seshInfo = SeshInfo.fromMap(element);
      _meds.add(seshInfo);
    });

    return _meds;
  }

  Future<int> delete(int id) async {
    var db = await this.database;
    return await db.delete(tableMath, where: '$columnId = ?', whereArgs: [id]);
  }
}
