// Building数据库操作类
import 'package:sqflite_common/sqlite_api.dart';

import '../../model/building.dart';

class BuildingDAO {
  static const String _tableName = 'building';

  // 建立building表
  static Future<void> createBuildingTable(Database database) async {
    await database.execute('''
    CREATE TABLE IF NOT EXISTS $_tableName (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL
    )
  ''');
  }

  // 插入一条Building记录
  static Future<int> insertBuilding(Database database, String name) async {
    final values = <String, Object?>{
      'name': name,
    };
    return database.insert(_tableName, values);
  }

  // 更新一条Building记录
  static Future<int> updateBuilding(Database database, int id, String name) async {
    final values = <String, Object?>{
      'name': name,
    };
    return database
        .update(_tableName, values, where: 'id = ?', whereArgs: [id]);
  }

  // 删除一条Building记录
  static Future<int> deleteBuilding(Database database, int id) async {
    return database.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  // 查询所有Building记录
  static Future<List<Building>> queryAllBuildings(Database database) async {
    final List<Map<String, dynamic>> maps = await database.query(_tableName);
    return List.generate(maps.length, (i) {
      return Building(
          id: maps[i]['id'],
          name: maps[i]['name']);
    });
  }
}
