import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/todo.dart';
import 'todo_bloc/todo_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void addTodo() {
    final String title = _titleController.text;
    final String description = _descriptionController.text;
    final Todo todo = Todo(title: title, subtitle: description);

    context.read<TodoBloc>().add(AddTodo(todo));

    _titleController.clear();
    _descriptionController.clear();
    Navigator.of(context).pop();
  }

  void removeTodo(Todo todo) {
    context.read<TodoBloc>().add(RemoveTodo(todo));
  }

  void updateTodo(int index) {
    context.read<TodoBloc>().add(UpdateTodo(index));
  }

  alertTodo(int index) {
    context.read<TodoBloc>().add(UpdateTodo(index));
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "ToDo App",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state.status == TodoStatus.success) {
                return ListView.builder(
                  itemCount: state.todos.length,
                  itemBuilder: (context, i) {
                    return Card(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                      child: Slidable(
                        key: ValueKey(i),
                        startActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) {
                                removeTodo(state.todos[i]);
                              },
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: ListTile(
                            title: Text(state.todos[i].title),
                            subtitle: Text(state.todos[i].subtitle),
                            trailing: Checkbox(
                              value: state.todos[i].isDone,
                              activeColor: Colors.white,
                              onChanged: (newValue) {
                                alertTodo(i);
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state.status == TodoStatus.initial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Add New Todo"),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: "Title"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          decoration:
                              const InputDecoration(labelText: "Description"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        _titleController.clear();
                        _descriptionController.clear();
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      onPressed: addTodo,
                      child: const Text("Submit"),
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
