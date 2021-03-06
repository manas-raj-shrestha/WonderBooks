import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nytbooks/core/constants/screen_titles.dart';
import '../../core/helper/dependency_injection.dart';
import '../../core/models/task.dart';
import '../../view_models/task_view_model.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key, this.task}) : super(key: key);

  final Task? task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? newTaskScreenTitle : editTaskScreenTitle),
      ),
      body: _TaskForm(task: task),
    );
  }
}

class _TaskForm extends StatefulWidget {
  final Task? task;

  const _TaskForm({this.task});

  @override
  // ignore: no_logic_in_create_state
  __TaskFormState createState() => __TaskFormState(task);
}

class __TaskFormState extends State<_TaskForm> {
  static const double _padding = 16;

  Task? task;
  TextEditingController? _titleController;
  TextEditingController? _descriptionController;

  __TaskFormState(this.task);

  void init() {
    if (task == null) {
      task = Task();
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
    } else {
      _titleController = TextEditingController(text: task?.title ?? '');
      _descriptionController =
          TextEditingController(text: task?.description ?? '');
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  void _save(BuildContext context) {
    if (_titleController!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Title is required'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    task!.title = _titleController!.text;
    task!.description = _descriptionController!.text;

    if (task!.isNew) {
      serviceLocator<TaskViewModel>().addTask(task!);
    } else {
      serviceLocator<TaskViewModel>().updateTask(task!);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(_padding),
        child: Column(
          children: [
            TextField(
              key: const Key('title_text_field'),
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: _padding),
            TextField(
              key: const Key('description_text_field'),
              controller: _descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
              minLines: 5,
              maxLines: 10,
            ),
            const SizedBox(height: _padding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Completed ?'),
                CupertinoSwitch(
                  key: const Key('completion_switch'),
                  value: task?.isCompleted ?? false,
                  onChanged: (_) {
                    setState(() {
                      task?.toggleComplete();
                    });
                  },
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              key: const Key('action_button'),
              onPressed: () => _save(context),
              child: SizedBox(
                width: double.infinity,
                child: Center(child: Text((task!.isNew) ? 'Create' : 'Update')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
