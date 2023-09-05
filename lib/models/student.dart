import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String id;

  Student({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.id,
  });

  Future<void> save() async {
    await FirebaseFirestore.instance.collection('Students').add({
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'id':id
    });
  }
}
