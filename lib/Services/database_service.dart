import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bill_calculator/models/Item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static const _dbName = "bill_calculator_database.db";

  DatabaseService._privateConstructor();

  static final databaseServiceInstance = DatabaseService._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, _dbName);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE Item (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL UNIQUE,
            price DOUBLE NOT NULL,
            indx INTEGER NUT NULL
          )
          ''');
  }

  Future<List<Item>> get items async {
    Database db = await database;
    List<Map<String, Object?>> maps = await db.query('Item', orderBy: 'indx');

    if (maps.isNotEmpty) {
      return maps.map((e) => Item.fromJson(e)).toList();
    }
    return [];
  }

  Future<int> addItem(Item item) async {
    Database db = await database;
    var js = item.toJson();
      js['indx'] = (await db.rawQuery('SELECT IFNULL(MAX(indx) + 1, 0) FROM Item'))[0]['IFNULL(MAX(indx) + 1, 0)'];


    print(js);
    return db.insert('Item', js, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateItem(Item item) async {
    Database db = await database;
    return db.update(
      'Item',
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteItem(String id) async {
    Database db = await database;
    return db.delete(
      'Item',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll() async {
    Database db = await database;
    return await db.delete('Item');
  }
}
