import 'package:Remind/database/db_helper.dart';
import 'package:Remind/widgets/themeServices.dart';
import 'package:flutter/material.dart';
import 'package:Remind/TeacherScreen/TeaCalendarScreen.dart';
import 'package:Remind/widgets/Palette.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'THomeScreen.dart';
import 'Tea_SettingsScreen.dart';

class Tea_side_menu extends StatefulWidget {
  const Tea_side_menu({Key? key}) : super(key: key);

  @override
  State<Tea_side_menu> createState() => _Tea_side_menuState();
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

class _Tea_side_menuState extends State<Tea_side_menu> {
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
    DBHelper dbhelper = DBHelper(); // Create an instance of DBHelper

    _pages = [
      ScreenHiddenDrawer(
        MyItemHiddenMenu(
          name: 'HomePage',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Palette.facebookColor,
          icon: Icons.home,
          onTap: () {},
        ),
        THomeScreen(classrooms: const [], removeClassroom: (Classroom ) {  },),
      ),
      ScreenHiddenDrawer(
        MyItemHiddenMenu(
          name: 'Settings',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Palette.facebookColor,
          icon: Icons.settings,
          onTap: () {},
        ),
        Tea_SettingsScreen(classrooms: [], dbhelper: dbhelper),
      ),
      ScreenHiddenDrawer(
        MyItemHiddenMenu(
          name: 'Calendar',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: Colors.deepOrangeAccent,
          icon: Icons.calendar_month_outlined,
          onTap: () {},
        ),
        TeaCalendarScreen(),
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
