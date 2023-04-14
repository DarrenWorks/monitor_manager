//摄像头
class Camera {
  int id;
  int floorId;
  String name;
  String ip;

  Camera({required this.id, required this.floorId, required this.name, required this.ip});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'floorId': floorId,
      'name': name,
      'ip': ip,
    };
  }

  static Camera fromMap(Map<String, dynamic> map) {
    return Camera(
      id: map['id'],
      floorId: map['floorId'],
      name: map['name'],
      ip: map['ip'],
    );
  }
}