class Todo {
  int? id; // Make id nullable

  String title;
  String body;
  DateTime creation_date;

  Todo({
    this.id, // Update id parameter to be nullable
    required this.title,
    required this.body,
    required this.creation_date,
  });

  // Update the copyWith method to include the nullable id
  Todo copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? creation_date,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      creation_date: creation_date ?? this.creation_date,
    );
  }

  // Rest of the Todo class remains unchanged
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'creation_date': creation_date.toIso8601String(),
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      creation_date: DateTime.parse(map['creation_date']),
    );
  }
}
