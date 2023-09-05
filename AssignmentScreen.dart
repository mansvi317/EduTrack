import 'package:flutter/material.dart';

class AssignmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Assignments:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildAssignmentCard(
              'Math Homework',
              'Due Date: 10/15/2023',
              'Complete the math exercises from chapter 5.',
            ),
            _buildAssignmentCard(
              'History Essay',
              'Due Date: 10/20/2023',
              'Write a 5-page essay on the American Revolution.',
            ),
            // Add more assignment cards as needed
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(String title, String dueDate, String description) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              dueDate,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AssignmentScreen(),
  ));
}
