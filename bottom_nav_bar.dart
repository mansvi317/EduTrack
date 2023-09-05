import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Assignment',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.purple,
      onTap: (index) {
        // Use the onTap function to navigate to the selected screen
        switch (index) {
          case 0:
          // Navigate to the Home screen
          // Replace 'HomeScreen' with the actual screen you want to navigate to
            Navigator.pushReplacementNamed(context, '/StHomeScreen');
            break;
          case 1:
          // Navigate to the Assignment screen
          // Replace 'AssignmentScreen' with the actual screen you want to navigate to
            Navigator.pushReplacementNamed(context, '/assignment');
            break;
          case 2:
          // Navigate to the Calendar screen
          // Replace 'CalendarScreen' with the actual screen you want to navigate to
            Navigator.pushReplacementNamed(context, '/calendar');
            break;
          default:
            break;
        }
        onTap(index);
      },
    );
  }
}
