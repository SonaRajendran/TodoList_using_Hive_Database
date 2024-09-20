import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todolist_using_hivedb/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Todo> todoBox;

  @override
  @override
  void initState() {
    super.initState();
    todoBox = Hive.box<Todo>('todo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('Todo List'),
      ),
      body: ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (context, Box<Todo> box, _) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              Todo todo = box.getAt(index)!;
              return Container(
                margin: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: todo.isCompleted ? Colors.white38 : Colors.white38,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Dismissible(
                  key: Key(todo.dateTime.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      todo.delete();
                    });
                  },
                  child: ListTile(
                    title: Text(todo.title),
                    subtitle: Text(todo.description),
                    trailing: Text(
                      DateFormat.yMMMd().format(todo.dateTime),
                    ),
                    leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (value) {
                        setState(
                          () {
                            todo.isCompleted = value!;
                            todo.save();
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodoDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTodoDialog(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    TextEditingController _titleController = TextEditingController();
    // ignore: no_leading_underscores_for_local_identifiers
    TextEditingController _descController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addTodo(_titleController.text, _descController.text);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addTodo(String title, String description) {
    if (title.isNotEmpty) {
      todoBox.add(
        Todo(
          title: title,
          description: description,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
