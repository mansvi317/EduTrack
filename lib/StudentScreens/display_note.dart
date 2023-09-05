import 'package:flutter/material.dart';
import 'package:Remind/database/db_helper.dart';
import '../models/todo.dart';

class ShowNote extends StatefulWidget {
  const ShowNote({Key? key}) : super(key: key);

  @override
  State<ShowNote> createState() => _ShowNoteState();
}
class _ShowNoteState extends State<ShowNote> {
  late Todo todo;
  late TextEditingController titleController;
  late TextEditingController bodyController;

  bool isEditing = false;
  String editedTitle = ""; // Initialize with an empty string
  String editedBody = "";

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    bodyController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    final Todo? receivedTodo =
    ModalRoute.of(context)?.settings.arguments as Todo?;

    if (receivedTodo == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(child: Text("Error: No note data found.")),
      );
    }

    // Initialize the controller text with the receivedTodo data
    if (!isEditing) {
      todo = receivedTodo;
      titleController.text = todo.title;
      bodyController.text = todo.body;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Note"),

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
        child: Column(
          children: [
            isEditing
                ? TextField(
              controller: titleController,
              onChanged: (value) {
                setState(() {
                  editedTitle = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Note Title",
              ),
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            )
                : Text(
              todo.title,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            isEditing
                ? Expanded(
              child: TextField(
                controller: bodyController,
                onChanged: (value) {
                  setState(() {
                    editedBody = value;
                  });
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Your note",
                ),
              ),
            )
                : Text(
              todo.body,
              style: TextStyle(fontSize: 18.0),
            )
          ],
        ),
        ),
      ),
      floatingActionButton: isEditing
          ? FloatingActionButton.extended(
        onPressed: () async {
          // Save the edited note to the database
          Todo editedTodo = todo.copyWith(
            title: editedTitle,
            body: editedBody,
          );
          await DatabaseProvider.db.updateTodo(editedTodo);

          setState(() {
            isEditing = false;
            todo = editedTodo;
          });
        },
        label: Text("Save"),
        icon: Icon(Icons.save),
      )
          : FloatingActionButton(
        onPressed: () {
          setState(() {
            isEditing = true;
          });
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
