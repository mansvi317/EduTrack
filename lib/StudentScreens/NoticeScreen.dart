import 'package:flutter/material.dart';

class NoticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notice'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latest Notices:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildNoticeCard(
              'School Closure',
              'Posted: 10/10/2023',
              'Due to inclement weather, the school will be closed tomorrow.',
            ),
            _buildNoticeCard(
              'Parent-Teacher Meeting',
              'Posted: 10/12/2023',
              'The parent-teacher meeting is scheduled for next Saturday.',
            ),
            // Add more notice cards as needed
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeCard(String title, String postedDate, String details) {
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
              postedDate,
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
    home: NoticeScreen(),
  ));
}
