import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/classroom.dart';
import '../models/joinedclassroom.dart';
import '../models/studentsid.dart';
import '../models/task.dart';
import '../models/todo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


void createClassroomsTable(Batch batch) {
  batch.execute('''
    CREATE TABLE classrooms(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      code TEXT,

    )
  ''');
}


class DBHelper {
  static Database? _db;
  static final int _version = 2; // Increase the version number
  static final String _taskTableName = "tasks";
  static final String _classroomTableName = "classrooms";
  static final _joinedClassroomTableName = 'joined_classrooms';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'database.db');
      String _path = join(await getDatabasesPath(), 'tasks.db');
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          print("Creating a new database");
          db.execute(
            "CREATE TABLE $_taskTableName ("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "title TEXT, "
                "date TEXT, "
                "startTime TEXT, "
                "endTime TEXT, "
                "remind INTEGER, "
                "repeat INTEGER, "
                "color INTEGER, "
                "isCompleted INTEGER"
                ")",
          );
          db.execute(
            "CREATE TABLE $_classroomTableName ("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "name TEXT, "
                "code TEXT, "
                ")",
          );
          db.execute(
            'CREATE TABLE $_joinedClassroomTableName(id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT)',
          );
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < newVersion) {
            if (oldVersion == 1 && newVersion == 2) {
              // Upgrade from version 1 to 2
              await db.execute(
                "ALTER TABLE $_classroomTableName ADD COLUMN joinCode TEXT",
              );
            }
          }
        },
      );
      await initializeDatabase();
    } catch (e) {
      print(e);
    }
  }


  //TASK DATABASE
  static Future<int> insertTask(Task task) async {
    print("Inserting task: ${task.toJson()}");
    if (_db == null) {
      await initDb();
    }
    return await _db!.insert(_taskTableName, task.toJson());
  }

  static Future<List<Map<String, dynamic>>> queryTask() async {
    print("Querying tasks");
    if (_db == null) {
      await initDb();
    }
    return await _db!.query(_taskTableName);
  }

  static Future<int> deleteTask(Task task) async {
    print("Deleting task: ${task.id}");
    if (_db == null) {
      await initDb();
    }
    return await _db!.delete(
      _taskTableName,
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<int> updateTask(int id) async {
    print("Updating task: $id");
    if (_db == null) {
      await initDb();
    }
    return await _db!.rawUpdate(
      'UPDATE $_taskTableName SET isCompleted = ? WHERE id = ?',
      [1, id],
    );
  }



// CLASSROOM DATABASE
  static Future<Database> initializeDatabase() async {
    final String path = join(await getDatabasesPath(), 'classroom.db');
    final Database database = await openDatabase(
      path,
      version: 3, // Increase the version number
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE $_classroomTableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, code TEXT)',
        );
        db.execute(
          'CREATE TABLE $_joinedClassroomTableName(id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT, className TEXT)', // Add className column
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 3) {
          // Perform migration for version 3
          db.execute('ALTER TABLE $_joinedClassroomTableName ADD COLUMN className TEXT');
        }
      },
    );
    return database;
  }


  static Future<List<JoinedClassroom>> getJoinedClassroom() async {
    final db = await initializeDatabase();
    final List<Map<String, dynamic>> classroomMaps = await db.query(_joinedClassroomTableName);

    return List.generate(classroomMaps.length, (i) {
      return JoinedClassroom.fromMap(classroomMaps[i]);
    });
  }

  static Future<bool> isClassroomJoined(String code) async {
    final db = await initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      _joinedClassroomTableName,
      where: 'code = ?',
      whereArgs: [code],
    );

    return maps.isNotEmpty;
  }
  static Future<void> joinClassroom(String joinCode) async {
    final db = await initializeDatabase();
    final bool isValidJoinCode = await checkJoinCode(joinCode);

    if (isValidJoinCode) {
      final className = await getClassNameFromCode(joinCode);

      if (className.isNotEmpty) {
        await db.insert(
          _joinedClassroomTableName,
          {'code': joinCode, 'className': className},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        print('Joined classroom: $className');
      } else {
        throw Exception('Classroom name not found for code: $joinCode');
      }
    } else {
      throw Exception('Invalid Join Code');
    }
  }





  static Future<bool> checkJoinCode(String code) async {
    final db = await initializeDatabase();
    final List<Map<String, dynamic>> classroomMaps = await db.query(
      _classroomTableName,
      where: 'code = ?',
      whereArgs: [code],
    );

    final List<Map<String, dynamic>> joinedClassroomMaps = await db.query(
      _joinedClassroomTableName,
      where: 'code = ?',
      whereArgs: [code],
    );

    return classroomMaps.isNotEmpty && joinedClassroomMaps.isEmpty;
  }




  static Future<String> getClassNameFromCode(String code) async {
    final db = await initializeDatabase();
    List<Map<String, dynamic>> result = await db.query(_classroomTableName,
      where: 'code = ?',
      whereArgs: [code],
    );

    if (result.isNotEmpty) {
      return result[0]['name'];
    } else {
      return '';
    }
  }


  static Future<List<Classroom>> getAllClassrooms() async {
    final db = await initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_classroomTableName);
    return List.generate(maps.length, (i) {
      return Classroom(
        id: maps[i]['id'],
        name: maps[i]['name'],
        code: maps[i]['code'],
      );
    });
  }

  static Future<int> insertClassroom(Classroom classroom) async {
    final Database db = await initializeDatabase();
    return db.insert(_classroomTableName, classroom.toMap());
  }

  static Future<List<Classroom>> getClassrooms() async {
    final Database db = await initializeDatabase();
    final List<Map<String, dynamic>> classrooms = await db.query(_classroomTableName);
    return classrooms.map((classroom) => Classroom.fromMap(classroom)).toList();
  }

  static Future<List<String>> getClassroomNames() async {
    final db = await initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_classroomTableName);

    return List.generate(maps.length, (i) {
      return maps[i]['name'];
    });
  }
}



  //TO-DO DATABASE
  class DatabaseProvider {
    DatabaseProvider._();

    static final DatabaseProvider db = DatabaseProvider._();
    static Database? _database;

    Future<Database> get database async {
      if (_database != null) {
        return _database!;
      }
      _database = await initDB();
      return _database!;
    }

    initDB() async {
      return await openDatabase(join(await getDatabasesPath(), "todo.db"),
          onCreate: (db, version) async {
            await db.execute('''
        CREATE TABLE todo(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        body TEXT,
        creation_date DATE
        )
        ''');
          }, version: 1);
    }

    addNewTodo(Todo todo) async {
      final db = await database;
      db.insert("todo", todo.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    Future<List<Map<String, dynamic>>> getNotes() async {
      final db = await database;
      var res = await db.query("todo"); // Change "notes" to "todo"
      if (res.length == 0) {
        return [];
      } else {
        return res;
      }
    }

    Future<int> deleteNote(int? id) async {
      final db = await database;
      int count = await db.rawDelete("DELETE FROM todo WHERE id = ?", [id]);
      return count;
    }

    // Inside DatabaseProvider class
    Future<int> updateTodo(Todo todo) async {
      final db = await database;
      return await db.update(
        "todo",
        todo.toMap(),
        where: "id = ?",
        whereArgs: [todo.id],
      );
    }

  }