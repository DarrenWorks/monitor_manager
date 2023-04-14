import 'package:sqflite_common/sqlite_api.dart';

import '../../model/camera.dart';

class CameraDAO {
  static const String _tableName = 'camera';

  static Future<void> createCameraTable(Database database) async {
    await database.execute('''
    CREATE TABLE IF NOT EXISTS $_tableName (
      id INTEGER PRIMARY KEY,
      floor_id INTEGER NOT NULL,
      name TEXT NOT NULL,
      ip TEXT NOT NULL,
      FOREIGN KEY (floor_id) REFERENCES floor (id)
    )
  ''');
  }

  //插入一条camera记录
  static Future<int> insertCamera(
      Database database, int floorId, String name, String ip) async {
    final values = <String, Object?>{
      'floor_id': floorId,
      'name': name,
      'ip': ip,
    };
    return database.insert(_tableName, values);
  }

  //更新一条camera记录
  static Future<int> updateCamera(
      Database database, int id, int floorId, String name, String ip) async {
    final values = <String, Object?>{
      'floor_id': floorId,
      'name': name,
      'ip': ip,
    };
    return database
        .update(_tableName, values, where: 'id = ?', whereArgs: [id]);
  }

  //删除一条camera记录
  static Future<int> deleteCamera(Database database, int id) async {
    return database.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  //查询所有camera记录
  static Future<List<Camera>> queryAllCameras(Database database) async {
    final List<Map<String, dynamic>> maps = await database.query(_tableName);
    return List.generate(maps.length, (i) {
      return Camera(
          id: maps[i]['id'],
          floorId: maps[i]['floor_id'],
          name: maps[i]['name'],
          ip: maps[i]['ip']);
    });
  }

  //通过floorId查询所有对应camera
  static Future<List<Camera>> queryCamerasByFloorId(
      Database database, int floorId) async {
    final List<Map<String, dynamic>> maps = await database
        .query(_tableName, where: 'floor_id = ?', whereArgs: [floorId]);

    return List.generate(maps.length, (i) {
      return Camera(
          id: maps[i]['id'],
          floorId: maps[i]['floor_id'],
          name: maps[i]['name'],
          ip: maps[i]['ip']);
    });
  }
}
