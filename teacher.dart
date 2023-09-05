import 'package:cloud_firestore/cloud_firestore.dart';

class Teacher {
  String name;
  String phone;
  String email;
  String password;

  Teacher({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required String id,
  });

  // Create a reference to the Firestore collection
  static CollectionReference teacherCollection =
  FirebaseFirestore.instance.collection('Students');

  // Save the student details to the Firestore collection
  Future<void> save() async {
    await teacherCollection.add({
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
    });
  }
}
