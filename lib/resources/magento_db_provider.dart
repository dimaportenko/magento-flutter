import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'magento_repository.dart';

final String _configsTableName = 'configs';

class MagentoDbProvider implements Source, Cache {
  Database db;
  Future initialized;

  MagentoDbProvider() {
    initialized = init();
  }

  init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'magento1.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute("""
            CREATE TABLE $_configsTableName
              (
                id INTEGER PRIMARY KEY,
                name TEXT,
                content TEXT
              )
          """);
    });
    print('open database done');
    return true;
  }

  Future<String> fetchConfig(String name) async {
    if (db == null) {
      await initialized;
    }
    print('fetch config start');
    final maps = await db.query(
      _configsTableName,
      columns: null,
      where: "name = ?",
      whereArgs: [name],
    );

    if (maps.length > 0) {
      return maps.first['content'] as String;
    }

    return null;
  }

  Future<String> fetchHomeConfig() async {
    return await fetchConfig('home');
  }

  Future<int> addConfig(String name, String content) {
    return db.insert(
      _configsTableName,
      <String, dynamic>{ 'name': name, 'content': content },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> clear() {
    return db.delete(_configsTableName);
  }
}

final magentoDbProvider = MagentoDbProvider();
