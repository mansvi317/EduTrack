import 'package:flutter/material.dart';
import 'package:Remind/database/db_helper.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class Stu_todo extends StatefulWidget {
  const Stu_todo({Key? key}) : super(key: key);

  @override
  State<Stu_todo> createState() => _Stu_todoState();
}

class _Stu_todoState extends State<Stu_todo> {
  Future<List<Map<String, dynamic>>> getNotes() async {
    final notes = await DatabaseProvider.db.getNotes();
    return notes;
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error occurred while fetching notes: ${snapshot.error}"),
            );
          } else {
            final notesData = snapshot.data;
            if (notesData == null || notesData.isEmpty) {
              return Center(
                child: Text("You don't have any notes yet"),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: notesData.length,
                  itemBuilder: (context, index) {
                    String title = notesData[index]['title'];
                    String body = notesData[index]['body'];
                    String creation_date = notesData[index]['creation_date'];
                    int id = notesData[index]['id'];

                    return Card(
                      child: GestureDetector(
                        onLongPress: () {
                          _showDeleteConfirmationDialog(context, id);
                        },
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/ShowNote",
                              arguments: Todo(
                                title: title,
                                body: body,
                                creation_date: DateTime.parse(creation_date),
                                id: id,
                              ),
                            );
                          },
                          title: Text(
                            title,
                            maxLines: 2, // Show up to 2 lines for the title
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  body,
                                  maxLines: 2, // Show up to 2 lines for the body
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                formatDate(DateTime.parse(creation_date)),
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/AddNote");
        },
        child: Icon(Icons.note_add_outlined),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int noteId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Note"),
          content: Text("Are you sure you want to delete this note?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseProvider.db.deleteNote(noteId);
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
