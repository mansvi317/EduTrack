class JoinedClassroom {
  final int id;
  final String code;
  final String className; // Added class name field

  JoinedClassroom({
    required this.id,
    required this.code,
    required this.className, // Added class name parameter
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'className': className, // Added class name field
    };
  }

  static JoinedClassroom fromMap(Map<String, dynamic> map) {
    return JoinedClassroom(
      id: map['id'],
      code: map['code'],
      className: map['className'], // Added class name field
    );
  }
}
