import 'dart:math';
import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/classroom.dart';
import '../models/classroom.dart';
import 'THomeScreen.dart';
import '../models/classroom.dart';

class Tea_SettingsScreen extends StatefulWidget {
  final List<Classroom> classrooms; // Pass the list of classrooms
  final DBHelper dbhelper; // Pass the DBHelper instance

  Tea_SettingsScreen({required this.classrooms, required this.dbhelper});

  @override
  _Tea_SettingsScreenState createState() => _Tea_SettingsScreenState();
}

class _Tea_SettingsScreenState extends State<Tea_SettingsScreen> {
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _classCodeController = TextEditingController();

  String _classroomCode = '';

  String generateRandomJoinCode() {
    const int codeLength = 6;
    const String charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    Random random = Random();

    String joinCode = '';
    for (int i = 0; i < codeLength; i++) {
      int randomIndex = random.nextInt(charset.length);
      joinCode += charset[randomIndex];
    }

    return joinCode;
  }

  void _generateRandomCode() {
    setState(() {
      _classroomCode = generateRandomJoinCode();
    });
  }

  void _createClassroom() async {
    if (_classNameController.text.isNotEmpty && _classroomCode.isNotEmpty) {
      await DBHelper.insertClassroom(
        Classroom(name: _classNameController.text, code: _classroomCode,),
      );

      _classNameController.clear();
      setState(() {
        _classroomCode = '';
      });

      List<Classroom> updatedClassrooms = await DBHelper.getAllClassrooms();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => THomeScreen(
            classrooms: updatedClassrooms,
            removeClassroom: (Classroom classroom) {},
          ),
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Class'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _classNameController,
              decoration: InputDecoration(labelText: 'Classroom Name'),
            ),
            if (_classroomCode.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Generated Code: $_classroomCode'),
              ),
            ElevatedButton(
              onPressed: _generateRandomCode,
              child: Text('Generate Code'),
            ),
            ElevatedButton(
              onPressed: _createClassroom,
              child: Text('Create Classroom'),
            ),
          ],
        ),
      ),
    );
  }
}
