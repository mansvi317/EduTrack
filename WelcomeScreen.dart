import 'dart:ui';
import 'package:Remind/TeacherScreen/TeacherLoginScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../StudentScreens/StudentLoginScreen.dart';


class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFbcb88a),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/purple.jpeg',
            fit: BoxFit.cover,
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child:
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              //showAuthenticationPopup(context);
                              Navigator.pushNamed(context, '/StuloginSignup',
                                  arguments: 'student');
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white24, //withOpacity(0.1),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/images/74586-learning-concept.json',
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Student',
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontFamily: 'CinzelDecorative-Black',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 4,
                              color: Colors.black.withOpacity(0.9),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child:
                            Text(
                              'OR',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontFamily: 'CinzelDecorative-Black',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 4,
                              color: Colors.black.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/TealoginSignup',
                                  arguments: 'teacher');

                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white24,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/images/73170-teacher-all-language.json',
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Teacher',
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontFamily: 'CinzelDecorative-Black',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

