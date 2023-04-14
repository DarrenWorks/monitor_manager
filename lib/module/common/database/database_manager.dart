import 'dart:async';

import 'package:monitor_manager/module/common/database/camera_dao.dart';
import 'package:monitor_manager/module/common/database/floor_dao.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'building_dao.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();

  factory DatabaseManager() => _instance;

  DatabaseManager._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // 初始化sqflite_common_ffi
    sqfliteFfiInit();

    // 打开数据库
    final db = await _openDatabase();
    await BuildingDAO.createBuildingTable(db);
    await FloorDAO.createFloorTable(db);
    await CameraDAO.createCameraTable(db);

    _database = db;
    return db;
  }

  Future<Database> _openDatabase() async {
    // 获取数据库文件路径
    final dbPath = 'path_to_database_file';

    // 打开数据库
    return await databaseFactoryFfi.openDatabase(dbPath);
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
