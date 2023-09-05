import 'package:Remind/widgets/Palette.dart';
import 'package:Remind/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import 'Palette.dart';
import 'button.dart';
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20, 30];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body:
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/bg7.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigate back
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 25,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Add Task",
                    style: headingStyle,
                  ),
                  MyInputField(
                    title: "Title",
                    hint: "Enter your title",

                    controller: _titleController,
                  ),
                  /*MyInputField(
                    title: "Note",
                    hint: "Enter your note",
                    controller: _noteController,
                  ),*/
                ],
              ),
            ),

              Padding(
                  padding: const EdgeInsets.all(3),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyInputField(
                        title: "Date",
                        hint: DateFormat("M/d/yyyy").format(_selectedDate),
                        widget: IconButton(
                          icon: Icon(Icons.calendar_today_outlined),
                          color: Colors.grey,
                          iconSize: 25,
                          onPressed: () {
                            _getDateFromUser();
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MyInputField(
                              title: "Start Time",
                              hint: _startTime,
                              widget: IconButton(
                                onPressed: () {
                                  _getTimeFromUser(isStartTime: true);
                                },
                                icon: Icon(
                                  Icons.access_time_rounded,
                                  size: 25,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MyInputField(
                              title: "End Time",
                              hint: _endTime,
                              widget: IconButton(
                                onPressed: () {
                                  _getTimeFromUser(isStartTime: false);
                                },
                                icon: Icon(
                                  Icons.access_time_rounded,
                                  size: 25,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      MyInputField(
                        title: "Remind",
                        hint: "$_selectedRemind minutes early",
                        widget: DropdownButton(
                          icon: Icon(
                            Icons.notifications,
                            color: Colors.grey,
                          ),
                          iconSize: 32,
                          elevation: 4,
                          style: subTitleStyle,
                          underline: Container(height: 0),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRemind = int.parse(newValue!);
                            });
                          },
                          items: remindList.map<DropdownMenuItem<String>>(
                                (int value) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(value.toString()),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      MyInputField(
                        title: "Repeat",
                        hint: "$_selectedRepeat",
                        widget: DropdownButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          iconSize: 32,
                          elevation: 4,
                          style: subTitleStyle,
                          underline: Container(height: 0),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRepeat = newValue!;
                            });
                          },
                          items: repeatList.map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _colorPalette(),
                          MyButton(label: "Create Task", onTap: _validateData),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
    );
  }


  void _validateData() {
    if (_titleController.text.isNotEmpty) {
      _addTaskToDb();
      Navigator.pop(context); // Navigate back
    } else {
      Get.snackbar(
        "Required",
        "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    }
  }

  Widget _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        SizedBox(height: 8),
        Wrap(
          children: List<Widget>.generate(
            3,
                (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                    print("$index");
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? Palette.facebookColor
                        : index == 1
                        ? Palette.googleColor
                        : Palette.buttonColor,
                    child: _selectedColor == index
                        ? Icon(Icons.done, color: Colors.white, size: 16)
                        : Container(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }



  Future<void> _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    } else {
      print("It's null or something is wrong");
    }
  }

  Future<void> _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await _showTimePicker();
    if (_pickedTime != null) {
      String _formattedTime = _pickedTime.format(context);
      if (isStartTime == true) {
        setState(() {
          _startTime = _formattedTime;
        });
      } else if (isStartTime == false) {
        setState(() {
          _endTime = _formattedTime;
        });
      }
    } else {
      print("Time canceled");
    }
  }

  void _addTaskToDb() async {
    String formattedDate = DateFormat("yyyy-MM-dd").format(_selectedDate);

    int? value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        date: DateTime.parse(formattedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
    print("My id is $value");
  }

  Future<TimeOfDay?> _showTimePicker() async {
    return await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}

