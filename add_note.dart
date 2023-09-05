import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Remind/database/db_helper.dart';

import '../models/todo.dart';
import 'Stu_todo.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late String title;
  late String body;
  late DateTime date;


  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  addNote(Todo todo) async {
    await DatabaseProvider.db.addNewTodo(todo);
    print("Note added successfully");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Note"),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Note Title",
              ),
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TextField(
                controller: bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Your note",
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          setState(() {
            title = titleController.text;
            body = bodyController.text;
            date = DateTime.now();
          });
          Todo todo = Todo(
            title: title,
            body: body,
            creation_date: date,
          );
          await addNote(todo);
          MaterialPageRoute(builder: (context) => Stu_todo()
          );
        },
        label: Text("Save Note"),
        icon: Icon(Icons.save),
      ),
    );
  }
}
