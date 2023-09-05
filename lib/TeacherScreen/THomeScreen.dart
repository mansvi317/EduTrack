import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/classroom.dart';
import '../models/student.dart';
class THomeScreen extends StatefulWidget {
  final List<Classroom> classrooms; // List of classrooms passed to the screen
  final Function(Classroom) removeClassroom; // Callback to remove a classroom

  THomeScreen({required this.classrooms, required this.removeClassroom});

  @override
  _THomeScreenState createState() => _THomeScreenState();
}
class _THomeScreenState extends State<THomeScreen> {
  List<Classroom> _classrooms = [];

  @override
  void initState() {
    super.initState();
    _classrooms = widget.classrooms;
    _fetchClassrooms();
  }

  Future<void> _fetchClassrooms() async {
    List<Classroom> fetchedClassrooms = await DBHelper.getAllClassrooms();
    setState(() {
      _classrooms = fetchedClassrooms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Home'),
      ),
      body: ListView.builder(
        itemCount: _classrooms.length,
        itemBuilder: (context, index) {
          final classroom = _classrooms[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classroom.name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    '${classroom.code}',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
