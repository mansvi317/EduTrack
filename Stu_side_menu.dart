import 'package:Remind/StudentScreens/Stu_todo.dart';
import 'package:Remind/widgets/themeServices.dart';
import 'package:flutter/material.dart';
import 'package:Remind/widgets/Palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'Stu_SettingsScreen.dart';
import '../StudentScreens/StHomeScreen.dart';
import '../TeacherScreen/TeaCalendarScreen.dart';
import 'StuCalendarScreen.dart';


class Stu_side_menu extends StatefulWidget {
  const Stu_side_menu({Key? key}) : super(key: key);

  @override
  State<Stu_side_menu> createState() => _Stu_side_menuState();
}

class MyItemHiddenMenu extends ItemHiddenMenu {
  final IconData? icon;
  final VoidCallback onTap;

  MyItemHiddenMenu({
    required String name,
    TextStyle baseStyle = const TextStyle(),
    TextStyle selectedStyle = const TextStyle(),
    Color colorLineSelected = Colors.transparent,
    this.icon,
    required this.onTap,
  }) : super(
    name: name,
    baseStyle: baseStyle,
    selectedStyle: selectedStyle,
    colorLineSelected: colorLineSelected,
  );
}

class _Stu_side_menuState extends State<Stu_side_menu> {
  List<ScreenHiddenDrawer> _pages = [];
  List<ItemHiddenMenu> _items = [];
  bool isDarkMode = false;

  final myTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 19,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _pages = [
      ScreenHiddenDrawer(
        MyItemHiddenMenu(
          name: 'HomePage',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Palette.facebookColor,
          icon: Icons.home, onTap: () {  },
        ),
        StHomeScreen(joinedClassrooms: [],),
      ),
      ScreenHiddenDrawer(
        MyItemHiddenMenu(
          name: 'Settings',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Palette.facebookColor,
          icon: Icons.settings, onTap: () {  },
        ),
        Stu_Settingscreen(),
      ),
      ScreenHiddenDrawer(
        MyItemHiddenMenu(
          name: 'Calendar',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Colors.deepOrangeAccent,
          icon: Icons.calendar_month_outlined, onTap: () {  },
        ),
        StuCalendarScreen(),
      ),
      ScreenHiddenDrawer(
        MyItemHiddenMenu(
          name: 'NotePad',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Colors.deepOrangeAccent,
          icon: Icons.calendar_month_outlined, onTap: () {  },
        ),
        Stu_todo(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      screens: _pages,
      backgroundColorMenu: Palette.bgColor,
      initPositionSelected: 0,
      slidePercent: 40,
    );
  }
}









AppBar _appBar() {
  return AppBar(
    leading: GestureDetector(
      onTap: () {
        ThemeServices().switchTheme();
        /*NotificationServices().displayNotification(
          title: "Theme Changed",
          body: Get.isDarkMode ? "Activated Dark Theme" : "Activated Light Theme",
        );
        NotificationServices().scheduledNotification();*/
      },
      child: Icon(
        Icons.nightlight_round,
        size: 28,
      ),
    ),
    actions: [
      Icon(
        Icons.person,
        size: 20,
      ),
      SizedBox(
        width: 20,
      ),
    ],
  );
}

/*ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Switch Theme',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Colors.deepOrangeAccent,
        ),
        Container(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isDarkMode = !isDarkMode;
                ThemeServices().switchTheme();
              });
            },
            child: ListTile(
              leading: Icon(Icons.light_mode),
              title: Text('Switch Theme'),
            ),
          ),
        ),
      ),
    ];
    */


