import '../core/enums/view_states.dart';
import '../core/models/task.dart';
import '../core/services/firebase_service.dart';
import 'base_model.dart';

class TaskViewModel extends BaseModel {
  final FirebaseService _firebaseService;
  List<Task> tasks = [];

  List<Task> get completedTasks =>
      tasks.where((task) => task.isCompleted).toList();

  _ResultHolder? _resultHolder;

  _ResultHolder? get resultHolder => _resultHolder;

  TaskViewModel(this._firebaseService);

  Future fetchTasks() async {
    try {
      if (tasks.isEmpty) {
        changeState(ViewState.busy);
        notifyListeners();
        List<Task> tasksResponse = await _firebaseService.tasks;
        tasks.addAll(tasksResponse);
        changeState(ViewState.idle);
      }
    } catch (e) {
      changeState(ViewState.error);
    } finally {
      notifyListeners();
    }
  }

  void clearResultHolder() => _resultHolder = null;

  Future addTask(Task task) async {
    try {
      String docId = await _firebaseService.addTask(task);
      task.id = docId;

      tasks.add(task);
      _resultHolder = _ResultHolder(false, 'Task added successfully');
    } catch (e) {
      _resultHolder = _ResultHolder(false, 'Failed to add task!');
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      if (task.id != null) {
        await _firebaseService.deleteTask(task.id!);
        tasks.removeWhere((element) => element.id == task.id);
        _resultHolder = _ResultHolder(false, 'Task deleted successfully');
      }
    } catch (error) {
      _resultHolder = _ResultHolder(true, 'Failed to delete task!');
    } finally {
      notifyListeners();
    }
  }

  Future updateTask(Task updatedTask) async {
    try {
      await _firebaseService.editTask(updatedTask);
      tasks[tasks.indexWhere((element) => element.id == updatedTask.id)] =
          updatedTask;

      _resultHolder = _ResultHolder(false, 'Task updated successfully');
    } catch (e) {
      _resultHolder = _ResultHolder(true, 'Failed to update task!');
    } finally {
      notifyListeners();
    }
  }
}

class _ResultHolder {
  bool hasError;
  String message;

  _ResultHolder(this.hasError, this.message);
}
