import 'package:monitor_manager/module/model/floor.dart';
import 'package:sqflite_common/sqlite_api.dart';

class FloorDAO {
  static const String _tableName = 'floor';

  static Future<void> createFloorTable(Database database) async {
    await database.execute('''
    CREATE TABLE IF NOT EXISTS $_tableName (
      id INTEGER PRIMARY KEY,
      building_id INTEGER NOT NULL,
      name TEXT NOT NULL,
      FOREIGN KEY (building_id) REFERENCES building (id)
    )
  ''');
  }

  // 插入一条floor记录
  static Future<int> insertFloor(
      Database database, int buildingId, String name) async {
    final values = <String, Object?>{
      'building_id': buildingId,
      'name': name,
    };
    return database.insert(_tableName, values);
  }

// 更新一条floor记录
  static Future<int> updateFloor(
      Database database, int id, int buildingId, String name) async {
    final values = <String, Object?>{
      'building_id': buildingId,
      'name': name,
    };
    return database
        .update(_tableName, values, where: 'id = ?', whereArgs: [id]);
  }

// 删除一条floor记录
  static Future<int> deleteFloor(Database database, int id) async {
    return database.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

// 查询所有floor记录
  static Future<List<Floor>> queryAllFloors(Database database) async {
    final List<Map<String, dynamic>> maps = await database.query(_tableName);
    return List.generate(maps.length, (i) {
      return Floor(
          id: maps[i]['id'],
          buildingId: maps[i]['building_id'],
          name: maps[i]['name']);
    });
  }

// 通过buildingId查询所有对应floor
  static Future<List<Floor>> queryFloorsByBuildingId(
      Database database, int buildingId) async {
    final List<Map<String, dynamic>> maps = await database
        .query(_tableName, where: 'building_id = ?', whereArgs: [buildingId]);

    return List.generate(maps.length, (i) {
      return Floor(
          id: maps[i]['id'],
          buildingId: maps[i]['building_id'],
          name: maps[i]['name']);
    });
  }
}
