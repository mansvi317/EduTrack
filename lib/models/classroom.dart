class Classroom {
  final int? id;
  final String name;
  final String code;


  Classroom({
    this.id,
    required this.name,
    required this.code,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,

    };
  }

  factory Classroom.fromMap(Map<String, dynamic> map) {
    return Classroom(
      id: map['id'],
      name: map['name'] ?? '',
      code: map['code'] ?? '',

    );
  }

}