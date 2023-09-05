import 'dart:async';
import 'package:Remind/StudentScreens/Stu_side_menu.dart';
import 'package:Remind/StudentScreens/add_note.dart';
import 'package:Remind/TeacherScreen/TeacherLoginScreen.dart';
import 'package:Remind/widgets/add_task_bar.dart';
import 'package:Remind/widgets/themeServices.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart'; // Import the package
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'Screens/WelcomeScreen.dart';
import 'StudentScreens/AssignmentScreen.dart';
import 'StudentScreens/StHomeScreen.dart';
import 'StudentScreens/StuCalendarScreen.dart';
import 'StudentScreens/StudentLoginScreen.dart';
import 'StudentScreens/display_note.dart';
import 'TeacherScreen/Tea_side_menu.dart';
import 'database/db_helper.dart';
import 'controllers/task_controller.dart';
import 'widgets/firebase_options.dart';
import 'package:Remind/widgets/Palette.dart';
import 'package:Remind/Screens/WelcomeScreen.dart' as MyWelcomeScreen;
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize your database
  await DBHelper.initDb();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize FlutterLocalNotificationsPlugin
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('appicon');
  final InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Initialize TaskController
  Get.put(TaskController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //initialRoute: '/',
      // Remove the defaultRouteName "/"
      routes: {
        '/TealoginSignup': (context) => TeacherLoginScreen(),
        '/StuloginSignup': (context) => StudentLoginScreen(),
        '/studentHome': (context) => Stu_side_menu(),
        '/teacherHome': (context) => Tea_side_menu(),
        '/AddTaskPage': (context) => AddTaskPage(),
        '/AddNote': (context) => AddNote(),
        '/ShowNote': (context) => ShowNote(),
        '/StHomeScreen': (context) => StHomeScreen(joinedClassrooms: []),
        '/assignment': (context) => AssignmentScreen(),
        '/calendar': (context) => StuCalendarScreen(),
      },
      // Replace the home property with AnimatedSplashScreen
      home: AnimatedSplashScreen(
        splash: 'assets/images/Remind.png', // Replace with your animation asset
        nextScreen: WelcomeScreen(),
        splashTransition: SplashTransition.fadeTransition,
        duration: 3000, // Duration in milliseconds
      ),
      title: 'Splash Screen',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
    );
  }
}
