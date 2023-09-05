import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../database/db_helper.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    getTasks(); // Fetch tasks when the controller is ready
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    if (task != null) {
      int taskId = await DBHelper.insertTask(task);
      task.id = taskId; // Assign the generated ID to the task
      getTasks(); // Update the task list after adding a new task
      return taskId;
    }
    return 0;
  }

  void getTasks() async {
    print("Fetching tasks...");
    List<Map<String, dynamic>> tasks = await DBHelper.queryTask();
    taskList.value = tasks.map((data) => Task.fromJson(data)).toList();
    print("Tasks fetched: ${taskList.length}");
  }

  void delete(Task task) async {
    print("Deleting task: ${task.id}");
    await DBHelper.deleteTask(task);
    getTasks(); // Update the task list after deleting a task
  }

  void markTaskCompleted(int id) async {
    print("Marking task completed: $id");
    await DBHelper.updateTask(id);
    getTasks(); // Update the task list after marking a task as completed
  }
}
