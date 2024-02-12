part of 'my_user_bloc.dart';


@immutable
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}
class AppChangeBottomNavBarEvent extends TaskEvent {
  final int index;

  const AppChangeBottomNavBarEvent({required this.index});
  @override
  List<Object> get props => [index];

}


class LoadTasks extends TaskEvent {}

class LoadAllTasks extends TaskEvent {}

class ChangeGridView extends TaskEvent {}

class ChangeGridIcon extends TaskEvent {}

class ChangeIndexColor extends TaskEvent {}

class AddTask extends TaskEvent {
  final TaskModel task;

  const AddTask(this.task);

  @override
  List<Object> get props => [task];
}
class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object> get props => [taskId];
}
class DeleteDoneTask extends TaskEvent {
  final String taskId;

  const DeleteDoneTask(this.taskId);

  @override
  List<Object> get props => [taskId];
}
class DeleteImportantTask extends TaskEvent {
  final String taskId;

  const DeleteImportantTask(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class UpdateTask extends TaskEvent {
  final String taskId;
  final String title;
  final String description;
  final String color;
  final DateTime date;
  final bool isDone;
  final bool isImportant;

  const UpdateTask(this.date, {
    required this.taskId,
    required this.title,
    required this.description,
    required this.color,
    required this.isDone,
    required this.isImportant,
  });

  @override
  List<Object> get props => [taskId, title, description, color,date,isDone,isImportant];
}

class UpdateDoneTask extends TaskEvent {
  final String taskId;
  final DateTime date;
  final bool isDone;

  const UpdateDoneTask(this.date, {
    required this.taskId,
    required this.isDone,
  });

  @override
  List<Object> get props => [taskId,date,isDone,];
}

class UpdateImportantTask extends TaskEvent {
  final String taskId;
  final DateTime date;
  final bool isDone;
  final bool isImportant;

  const UpdateImportantTask(this.date, {
    required this.taskId,
    required this.isDone,
    required this.isImportant,

  });

  @override
  List<Object> get props => [taskId,date,isDone,isImportant];
}
class LoadDoneTasks extends TaskEvent {}

class LoadImportantTasks extends TaskEvent {}

class SearchTasks extends TaskEvent {
  final String query;

  const SearchTasks(this.query);

  @override
  List<Object> get props => [query];
}


