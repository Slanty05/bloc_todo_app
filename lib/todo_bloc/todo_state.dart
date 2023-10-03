part of 'todo_bloc.dart';

enum TodoStatus { initial, loading, success, error }

class TodoState extends Equatable {
  final List<Todo> todos;
  final TodoStatus status;

  const TodoState({
    required this.todos,
    required this.status,
  });

  TodoState copyWith({
    List<Todo>? todos,
    TodoStatus? status,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      status: status ?? this.status,
    );
  }

  factory TodoState.fromJson(Map<String, dynamic> json) {
    try {
      final List<Todo> listOfTodos = (json['todos'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList();
      return TodoState(
        todos: listOfTodos,
        status: TodoStatus.values.firstWhere(
          (element) => element.toString() == json['status'],
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> todosJson =
        todos.map((todo) => todo.toJson()).toList();

    return {
      'todos': todosJson,
      'status': status.toString(),
    };
  }

  @override
  List<Object> get props => [todos, status];
}
