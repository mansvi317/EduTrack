import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/TestScreen.dart';
import 'AssignmentScreen.dart';
import 'NoticeScreen.dart';

class ClassroomPage extends StatelessWidget {
  final String classroomName;

  ClassroomPage(this.classroomName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(classroomName),
      ),
      body: Container(
        height: 117,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildCircleItemWithText(
                context, 'Test', 'assets/images/test1.jpeg', 'Test',
                TestScreen()),
            // Replace 'TestScreen()' with the actual screen you want to navigate to.
            _buildCircleItemWithText(
                context, 'Assignment', 'assets/images/test1.jpeg',
                'Assignment', AssignmentScreen()),
            // Replace 'AssignmentScreen()' with the actual screen.
            _buildCircleItemWithText(
                context, 'Notice', 'assets/images/test1.jpeg', 'Notice',
                NoticeScreen()),
            // Replace 'NoticeScreen()' with the actual screen.
            // _buildCircleItemWithText(context, 'Event', 'assets/images/test1.jpeg', 'Event', EventScreen()), // Replace 'EventScreen()' with the actual screen.
          ],
        ),
      ),
    );
  }


  Widget _buildCircleItemWithText(BuildContext context, String title, String imagePath, String textBelow, Widget screenToNavigate) {
    return GestureDetector(
      onTap: () {
        // Navigate to the specified screen when tapped.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screenToNavigate),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        width: 100,
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 2), // Adjust the spacing between the image and text
            Text(
              textBelow,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

