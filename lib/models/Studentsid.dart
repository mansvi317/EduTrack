class Studentid {
  final int id;
  final String name;
  final String classroomId;

  Studentid({
    required this.id,
    required this.name,
    required this.classroomId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'classroomId': classroomId,
    };
  }

  factory Studentid.fromMap(Map<String, dynamic> map) {
    return Studentid(
      id: map['id'],
      name: map['name'],
      classroomId: map['classroomId'],
    );
  }
}
