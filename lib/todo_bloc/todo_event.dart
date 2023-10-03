part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

// For Start Up Event
class StartTodo extends TodoEvent {}

// For Add Event
class AddTodo extends TodoEvent {
  final Todo todo;

  const AddTodo(this.todo);

  @override
  List<Object?> get props => [todo];
}

// For Remove Event
class RemoveTodo extends TodoEvent {
  final Todo todo;

  const RemoveTodo(this.todo);

  @override
  List<Object?> get props => [todo];
}

// For Update Event
class UpdateTodo extends TodoEvent {
  final int index;

  const UpdateTodo(this.index);

  @override
  List<Object?> get props => [index];
}
