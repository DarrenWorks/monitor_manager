//楼
class Building {
  int id;
  String name;

  Building({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Building fromMap(Map<String, dynamic> map) {
    return Building(
      id: map['id'],
      name: map['name'],
    );
  }

}
