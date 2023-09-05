import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:Remind/Screens/WelcomeScreen.dart' as MyWelcomeScreen;
import '../database/db_helper.dart';
import '../models/classroom.dart';
import '../models/joinedclassroom.dart';

import '../models/joinedclassroom.dart';
import '../widgets/themeServices.dart';
import 'ClassroomPage.dart';
import 'StHomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'StudentClassroomPage.dart';
class Stu_Settingscreen extends StatefulWidget {
  const Stu_Settingscreen({Key? key}) : super(key: key);

  @override
  State<Stu_Settingscreen> createState() => _Stu_SettingscreenState();
}

class _Stu_SettingscreenState extends State<Stu_Settingscreen> {
  TextEditingController _joinCodeController = TextEditingController();

  AppBar _appBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
        },
        child: Icon(
          Icons.nightlight_round,
          size: 28,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Implement the logic to add a classroom (teacher's feature)
          },
          icon: Icon(
            Icons.add,
            size: 20,
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    Get.offAll(() => MyWelcomeScreen.WelcomeScreen());
  }


  Future<List<JoinedClassroom>> _fetchJoinedClassroom() async {
    final joinedClassroom = await DBHelper.getJoinedClassroom(); // Use the correct method
    return joinedClassroom;
  }

  void _joinClassroom(BuildContext context) async {
    final joinCode = _joinCodeController.text;

    // Check if the class code is correct
    final isValidJoinCode = await DBHelper.checkJoinCode(joinCode);

    if (joinCode.isNotEmpty && isValidJoinCode) {
      try {
        await DBHelper.joinClassroom(joinCode); // Call the joinClassroom method
        final className = await DBHelper.getClassNameFromCode(joinCode);
        final joinedClassroom =
        JoinedClassroom(id: 0, code: joinCode, className: className);
        Classroom classroom = Classroom(name: className, code: joinCode);

        // Navigate to ClassroomScreen with the joined classroom data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassroomPage(className),
              //joinedClassroom: joinedClassroom,
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while joining the classroom.'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid Join Code'),
          content: Text('The provided join code is incorrect or does not exist.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }


  @override
    Widget build(BuildContext context) {
      return Scaffold(
        //appBar: _appBar(),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  ThemeServices().switchTheme();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.nightlight_outlined,
                      size: 30,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Switch Theme',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          title: Text('Join Classroom'),
                          content: TextField(
                            controller: _joinCodeController,
                            decoration: InputDecoration(
                              labelText: 'Enter Join Code',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _joinClassroom(
                                    context); // No need for await here
                              },
                              child: Text('Join'),
                            ),
                          ],
                        ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.add_outlined,
                      size: 30,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Join Classroom',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  logout();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      size: 30,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.person_2_outlined,
                      size: 30,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Profile',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
