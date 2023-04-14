//楼层
class Floor {
  int id;
  int buildingId;
  String name;

  Floor({required this.id, required this.buildingId, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buildingId': buildingId,
      'name': name,
    };
  }

  static Floor fromMap(Map<String, dynamic> map) {
    return Floor(
      id: map['id'],
      buildingId: map['buildingId'],
      name: map['name'],
    );
  }
}