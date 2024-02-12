part of 'my_user_bloc.dart';

@immutable

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}
class ChangeGridViewState extends TaskState {}
class TaskInitial extends TaskState {}

class AppChangeBottomNavBar extends TaskState {}

class TasksLoaded extends TaskState {
  final List<TaskModel> tasks;

  const TasksLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}
class DoneTasksLoaded extends TaskState {
  final List<TaskModel> tasks;

  const DoneTasksLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}
class ImportantTasksLoaded extends TaskState {
  final List<TaskModel> tasks;

  const ImportantTasksLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}


class TasksError extends TaskState {
  final String message;

  const TasksError(this.message);

  @override
  List<Object> get props => [message];
}
class EmptyTasksMessage extends TaskState {
  final String message;

  const EmptyTasksMessage(this.message);

  @override
  List<Object> get props => [message];
}