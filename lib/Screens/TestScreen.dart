import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Tests:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildTestCard(
              'Math Test',
              'Date: 10/18/2023',
              'Chapters: 5-7',
            ),
            _buildTestCard(
              'Science Quiz',
              'Date: 10/22/2023',
              'Topics: Chemistry and Biology',
            ),
            // Add more test cards as needed
          ],
        ),
      ),
    );
  }

  Widget _buildTestCard(String title, String date, String details) {
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
              date,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(details),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TestScreen(),
  ));
}
