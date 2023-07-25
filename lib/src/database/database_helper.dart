// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:youdu/src/model/api_model/guest/categories/category_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableName = 'categoryTable';
  final String columnId = 'id';
  final String columnParentId = 'parent_id';
  final String columnName = 'name';
  final String columnImage = 'ico';

  static Database? _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();

    return _db!;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'ewew.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE $tableName('
      '$columnId INTEGER PRIMARY KEY, '
      '$columnName TEXT, '
      '$columnImage TEXT, '
      '$columnParentId INTEGER)',
    );
  }

  Future<int> saveCategory(CategoryModel item) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(
      tableName,
      columns: [
        columnId,
      ],
      where: '$columnId = ?',
      whereArgs: [item.id],
    );
    if (result.isNotEmpty) {
      return await dbClient.update(
        tableName,
        item.toJson(),
        where: "$columnId = ?",
        whereArgs: [item.id],
      );
    } else {
      var result = await dbClient.insert(
        tableName,
        item.toJson(),
      );
      return result;
    }
  }

  Future<List<CategoryModel>> getCategory(String search) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
      "SELECT * FROM $tableName WHERE $columnName LIKE '%$search%'",
    );
    List<CategoryModel> products = <CategoryModel>[];
    for (int i = 0; i < list.length; i++) {
      CategoryModel items = CategoryModel(
        id: list[i][columnId],
        name: list[i][columnName],
        parentId: list[i][columnParentId],
        ico: list[i][columnImage],
        childCount: 0,
      );
      products.add(items);
    }
    return products;
  }

  Future<int> deleteCategory(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateCategory(CategoryModel products) async {
    var dbClient = await db;
    return await dbClient.update(
      tableName,
      products.toJson(),
      where: "$columnId = ?",
      whereArgs: [products.id],
    );
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

  Future<void> clear() async {
    var dbClient = await db;
    await dbClient.rawQuery('DELETE FROM $tableName');
  }
}
