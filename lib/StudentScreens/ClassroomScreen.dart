import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/joinedclassroom.dart';

class ClassroomScreen extends StatelessWidget {
  final JoinedClassroom joinedClassroom;

  ClassroomScreen({required this.joinedClassroom});

  @override
  Widget build(BuildContext context) {
    print('Class Name: ${joinedClassroom.className}');
    print('Class Code: ${joinedClassroom.code}');
    return Scaffold(
      appBar: AppBar(
        title: Text(joinedClassroom.className), // Display class name in the app bar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Class Name: ${joinedClassroom.className}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Class Code: ${joinedClassroom.code}',
              style: TextStyle(fontSize: 24),
            ),

            // Other content for the ClassroomScreen
          ],
        ),
      ),
    );
  }
}
