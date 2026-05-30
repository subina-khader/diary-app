import 'package:diary/models/diary_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/diaryentry_model.dart';

class DatabaseHelper {
  static const String DiaryTable = "diary";
  static final DatabaseHelper instance = DatabaseHelper._constructor();
  static Database? _db;

  ///diary table - for diary creation
  final String _diaryTable = "diary";
  final String _diaryId = "id";
  final String _diaryName = "name";
  final String _diaryThemeValue = "themeValue";
  final String _diaryThemeName = "themeName";
  final String _diaryCategoryIconPath = "categoryIconPath";
  final String _diaryCategoryName = "categoryName";
  final String _diaryIsPrivate = "isPrivate";
  final String _diaryPassword = "password";

  /// diary entry table -for content of each diary
  final String _diaryEntryTable = "diaryEntries";
  final String _diaryEntryId = "entryId";
  final String _diaryTableId = "diaryId";
  final String _diaryContent = "content";
  final String _diaryEntryDate = "entryDate";

  DatabaseHelper._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final dataBaseDir = getDatabasesPath();
    final databasePath = join(await dataBaseDir, "diary.db");
    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' CREATE TABLE $_diaryTable(
    $_diaryId INTEGER PRIMARY KEY AUTOINCREMENT,
    $_diaryName TEXT NOT NULL,
    $_diaryThemeValue INTEGER,
    $_diaryThemeName TEXT NOT NULL,
    $_diaryCategoryIconPath TEXT NOT NULL,
    $_diaryCategoryName TEXT NOT NULL,
    $_diaryIsPrivate INTEGER,
    $_diaryPassword TEXT
    
      )
      ''');

        await db.execute(''' CREATE TABLE $_diaryEntryTable(
    $_diaryEntryId INTEGER PRIMARY KEY AUTOINCREMENT,
    $_diaryTableId INTEGER NOT NULL,
    $_diaryContent TEXT NOT NULL,
    $_diaryEntryDate TEXT NOT NULL
   
    
      )
      ''');
      },
    );
  }

  Future<void> insertDiary(DiaryModel diary) async {
    Database db = await instance.database;
    await db.insert(_diaryTable, diary.toMap());
  }

  Future<List<DiaryModel>> getDiary() async {
    Database db = await instance.database;
    final data = await db.query("$_diaryTable");
    return data.map((e) => DiaryModel.fromMap(e)).toList();
  }

  Future<void> insertDiaryEntry(DiaryEntryModel entry) async {
    Database db = await instance.database;
    final existing = await getEntryBySelectedDate(entry.diaryId, entry.date);
    if (existing != null) {
      await db.update(
        _diaryEntryTable,
        entry.toMap(),
        where: '$_diaryEntryId=?',
        whereArgs: [existing.id],
      ); //existing .id means the entry id
    } else {
      await db.insert(_diaryEntryTable, entry.toMap());
    }
  }

  Future<List<DiaryEntryModel>> getAllEntriesByDiaryId(int diaryId) async {
    Database db = await instance.database;
    final data = await db.query(
      "$_diaryEntryTable",
      where: '$_diaryTableId=?',
      whereArgs: [diaryId],
      orderBy: '$_diaryEntryDate ASC',
    );
    return data.map((e) => DiaryEntryModel.fromMap(e)).toList();
  }

  Future<List<DiaryEntryModel>> getEntriesByDiaryId(int diaryId) async {
    Database db = await instance.database;
    final data = await db.query(
      "$_diaryEntryTable",
      where: '$_diaryTableId=?',
      whereArgs: [diaryId],
      orderBy: '$_diaryEntryDate ASC',
    );
    return data.map((e) => DiaryEntryModel.fromMap(e)).toList();
  }

  Future<DiaryEntryModel?> getEntryBySelectedDate(
    int diaryId,
    String date,
  ) async {
    Database db = await instance.database;
    final data = await db.query(
      "$_diaryEntryTable",
      where: '$_diaryTableId=? AND $_diaryEntryDate=?',
      whereArgs: [diaryId, date],
    );
    if (data.isNotEmpty) {
      return DiaryEntryModel.fromMap(data.first);
    }
    return null;
  }

  Future<bool> checkPassword(int diaryId, String password) async {
    Database db = await instance.database;
    final diary= await db.query(
      "$_diaryTable",
      where: "$_diaryId=?",
      whereArgs: [diaryId],
    );//Get value from map using column name
    return password==diary.first[_diaryPassword]? true:false;
  }
}
