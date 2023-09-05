import 'dart:typed_data';

import 'package:Remind/StudentScreens/ClassroomPage.dart';
import 'package:Remind/StudentScreens/StuCalendarScreen.dart';
import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/joinedclassroom.dart';
import '../widgets/Palette.dart';

class StHomeScreen extends StatefulWidget {
  final List<JoinedClassroom> joinedClassrooms;
  final String? joinedClassName;


  StHomeScreen({
    required this.joinedClassrooms,
    this.joinedClassName, // Add this line
  });

  @override
  _StHomeScreenState createState() => _StHomeScreenState();
}

class _StHomeScreenState extends State<StHomeScreen> {
  List<JoinedClassroom> classrooms = [];



  /*List<Widget> _screens = [
    //ActivityScreen(),
    StHomeScreen(joinedClassrooms: [],),
    AssignmentScreen(),
    StuCalendarScreen(),
    //MoreScreen(),
  ];

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 500), // You can adjust the duration
      curve: Curves.ease,
    );
  }
*/


  @override
  void initState() {
    super.initState();
    fetchJoinedClassrooms();
  }




  Future<void> fetchJoinedClassrooms() async {
    try {
      final List<JoinedClassroom> joinedClassrooms =
      (await DBHelper.getJoinedClassroom()) as List<JoinedClassroom>;

      print('Fetched joined classrooms: $joinedClassrooms');

      setState(() {
        classrooms = joinedClassrooms;
      });
    } catch (e) {
      print("Error fetching joined classrooms: $e");
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.black,
                  // Add your profile image here
                  //backgroundImage: AssetImage('bg2.jpg'),
                ),
                SizedBox(width: 7),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student Name',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    Text(
                      'Student id: 12345',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      '3rd Year, CBCGS',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          /*Text(
            'Joined Classrooms',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),*/
          SizedBox(height: 8),
          Expanded(
            child: Container(
              height: 200,
              child: GridView.builder(
                itemCount: classrooms.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Adjust the number of columns as needed
                  crossAxisSpacing: 10.0, // Adjust spacing between columns
                  mainAxisSpacing: 10.0, // Adjust spacing between rows
                ),
                itemBuilder: (BuildContext context, int index) {
                  final classroom = classrooms[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClassroomPage(classroom.className),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(15), // Increased padding for spacing
                      decoration: BoxDecoration(
                        color: Palette.bgColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FutureBuilder<String>(
                            future: DBHelper.getClassNameFromCode(classroom.code),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData) {
                                return Text('Loading...');
                              } else {
                                return Text(
                                  snapshot.data ?? '',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(height: 10), // Add this SizedBox for spacing
                        ],
                      ),
                    ),
                  );
                },
              ),

            ),
          ),
        ],
      ),


    );
  }
          /*Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 7,
                crossAxisSpacing: 7,
                children: [
                  /*Padding(
                    padding: const EdgeInsets.all(15),
                    child: CircularProgressIndicator(
                      strokeWidth: 15,
                      value: 0.7,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple[300]!,
                      ),
                      backgroundColor: Color(0xFFb8acd1),
                    ),
                  ),*/
                  buildSquareContainer('Upcoming Schedule and lecture time'),
                  buildSquareContainer('Subject topic and lecture teacher'),
                  buildSquareContainer('Upcoming tests with date and marks'),
                ],
              ),
            ),
          ),*/



  Widget buildSquareContainer(String text) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFb8acd1),
            Color(0xFFb8acd1),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 7),
          Container(
            height: 30,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                'View Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
}




void main() {
  runApp(
    MaterialApp(
      home: StHomeScreen(joinedClassrooms: [], joinedClassName: '',),
    ),
  );
}


/*

import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/classroom.dart';
import '../models/joinedclassroom.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class StHomeScreen extends StatefulWidget {
  final List<JoinedClassroom> joinedClassrooms;
  final String? joinedClassName; // Add this line

  StHomeScreen({
    required this.joinedClassrooms,
    this.joinedClassName, // Add this line
  });

  @override
  _StHomeScreenState createState() => _StHomeScreenState();
}

class _StHomeScreenState extends State<StHomeScreen> {
  List<JoinedClassroom> classrooms = [];

  @override
  void initState() {
    super.initState();
    fetchJoinedClassrooms();
  }



  Future<void> fetchJoinedClassrooms() async {
    try {
      final List<JoinedClassroom> joinedClassrooms = (await DBHelper.getJoinedClassroom()) as List<JoinedClassroom>;

      print('Fetched joined classrooms: $joinedClassrooms'); // Add this line

      setState(() {
        classrooms = joinedClassrooms;
      });
    } catch (e) {
      print("Error fetching joined classrooms: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.black,
                  // Add your profile image here
                  //backgroundImage: AssetImage('bg2.jpg'),
                ),
                SizedBox(width: 10),
                Text(
                  'Hi!! There',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: CircularProgressIndicator(
                      strokeWidth: 15,
                      value: 0.7,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple[300]!,
                      ),
                      backgroundColor: Color(0xFFb8acd1),
                    ),
                  ),
                  buildSquareContainer('Upcoming Schedule and lecture time'),
                  buildSquareContainer('Subject topic and lecture teacher'),
                  buildSquareContainer('Upcoming tests with date and marks'),
                ],
              ),
            ),
          ),
          Text(
            'Joined Classrooms',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: classrooms.length,
              itemBuilder: (BuildContext context, int index) {
                final classroom = classrooms[index];

                print('Classroom: ${classroom.className}'); // Print the classroom data

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassroomPage(classroom.className),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    width: 195,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            //"${classroom.className}"
                            "${classroom.code}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          SizedBox(height: 8), // Add this SizedBox for spacing
                          FutureBuilder<String>(
                            future: DBHelper.getClassNameFromCode(classroom.code),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData) {
                                return Text('Loading...');
                              } else {
                                return Text(
                                  snapshot.data ?? '', // Display joined class name
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget buildSquareContainer(String text) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFb8acd1),
            Color(0xFFb8acd1),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                'View Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClassroomPage extends StatelessWidget {
  final String classroomName;

  ClassroomPage(this.classroomName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(classroomName),
      ),
      body: Center(
        child: Text('Classroom content goes here'),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: StHomeScreen(joinedClassrooms: [], joinedClassName: '',),
    ),
  );
}
*/