
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../screens/home/user_screens/done.dart';
import '../../screens/home/user_screens/important.dart';
import '../../screens/home/user_screens/mytasks.dart';
import '../../screens/home/user_screens/search.dart';







part 'my_user_event.dart';
part 'my_user_state.dart';


class TaskBloc extends Bloc<TaskEvent, TaskState> {
  String userId;
  int currentPageIndex = 1;
  bool gridIcon = false;
  bool isGridorList = true;
  bool isIndexChanged = false;
  List<Widget> Task_Screens = [
    Search(),
    MyTasks(),
    ImportantScreen(),
    DoneTasksPage(),
  ];
  List<Widget> Appbars = [
    Search(),
    MyTasks(),
    ImportantScreen(),
    DoneTasksPage(),
  ];
  List<String> titles = [
    'Search',
    'My Tasks',
    'Important Tasks',
    'Done Tasks',
  ];

  final TaskRepository taskRepository;
  TaskBloc(this.userId, this.taskRepository) : super(TaskInitial()){
    on<AppChangeBottomNavBarEvent>((event , emit) async{
      currentPageIndex = event.index;
      emit(AppChangeBottomNavBar());
    });
    on<SearchTasks>((event, emit) async {
      var tasks = await taskRepository.getTasks(userId);
      try {
        if (event.query.isEmpty) {
          if(tasks.isEmpty){
            emit(EmptyTasksMessage("No Data"));
          }
          else{
            emit(TasksLoaded(tasks));} // Restore original tasks
        } else {
          final List<TaskModel> filteredTasks = tasks.where((task) {
            return task.title.toLowerCase().contains(event.query.toLowerCase()) ||
                task.description.toLowerCase().contains(event.query.toLowerCase());
          }).toList();
          emit(TasksLoaded(filteredTasks));
        }
      } catch (e) {
        emit(TasksError("Error searching tasks"));
      }
    });
    on<LoadAllTasks>((event, emit) async {
      try {
        var tasks = await taskRepository.getTasks(userId);
        if(tasks.isEmpty){
          emit(EmptyTasksMessage("No Data"));
        }
        else{
          emit(TasksLoaded(tasks));}
      } catch (e) {
        emit(TasksError("Error loading tasks"));
      }
    });
    on<LoadTasks>((event, emit) async {
      try {
        var tasks = await taskRepository.getTasks(userId);
        tasks = tasks.where((task) => !task.isDone).toList();
        if(tasks.isEmpty){
          emit(EmptyTasksMessage("No Data"));
        }
        else{
        emit(TasksLoaded(tasks));}
      } catch (e) {
        emit(TasksError("Error loading tasks"));
      }
    });
    on<AddTask>((event, emit) async {
      try {
        event.task.userId = userId;
        print( event.task.userId);// Set the user ID for the task
        await taskRepository.addTask(event.task);
        // Reload tasks
      } catch (e) {
        emit(TasksError("Error adding task in Id: ${event.task.userId}"));
      }
    });
    on<DeleteTask>((event, emit) async {
      try {
        await taskRepository.deleteTask(event.taskId);
        add(LoadTasks());

      } catch (e) {
        emit(TasksError("Error deleting task"));
      }
    });
    on<DeleteDoneTask>((event, emit) async {
      try {
        await taskRepository.deleteTask(event.taskId);
        add(LoadDoneTasks());

      } catch (e) {
        emit(TasksError("Error deleting task"));
      }
    });
    on<DeleteImportantTask>((event, emit) async {
      try {
        await taskRepository.deleteTask(event.taskId);
        add(LoadImportantTasks());

      } catch (e) {
        emit(TasksError("Error deleting task"));
      }
    });

    on<UpdateTask>((event,emit) async{
      try {
        await taskRepository.updateTask(
          event.taskId,
          title: event.title,
          description: event.description,
          isDone: event.isDone,
          isImportant : event.isImportant,
          date: event.date
        );
        add(LoadTasks());
      } catch (e) {
       emit(TasksError("Error updating task"));
      }
    });

    on<UpdateDoneTask>((event,emit) async{
      try {
        await taskRepository.updateTask(
            event.taskId,
            isDone: event.isDone,
            date: event.date
        );
        add(LoadDoneTasks());
      } catch (e) {
        emit(TasksError("Error updating task"));
      }
    });
    on<LoadDoneTasks>((event, emit) async {
      try {
        var doneTasks = await taskRepository.getTasks(userId);
        doneTasks = doneTasks.where((task) => task.isDone).toList();
        if(doneTasks.isEmpty){
          emit(EmptyTasksMessage("No Data"));
        }
        else{
          emit(DoneTasksLoaded(doneTasks));}
        // Reload tasks
      } catch (e) {
        emit(TasksError("Error loading done tasks"));
      }
    });
    on<UpdateImportantTask>((event,emit) async{
      try {
        await taskRepository.updateTask(
            event.taskId,
            isDone: event.isDone,
            date: event.date,
            isImportant: event.isImportant
        );
        add(LoadImportantTasks());
      } catch (e) {
        emit(TasksError("Error updating task"));
      }
    });
    on<LoadImportantTasks>((event, emit) async {
      try {
        var importantTasks = await taskRepository.getTasks(userId);
        importantTasks = importantTasks.where((task) => task.isImportant).toList();
        if(importantTasks.isEmpty){
          emit(EmptyTasksMessage("No Data"));
        }
        else{
          emit(ImportantTasksLoaded(importantTasks));}
        // Reload tasks
      } catch (e) {
        emit(TasksError("Error loading done tasks"));
      }
    });

    on<ChangeGridView>((event, emit) async {
      try{
      isGridorList = !isGridorList ;
      var tasks = await taskRepository.getTasks(userId);
      tasks = tasks.where((task) => !task.isDone).toList();
      if(tasks.isEmpty){
        emit(EmptyTasksMessage("No Data"));
      }
      else{
        emit(TasksLoaded(tasks));}
      }
          catch(e) {
            emit(TasksError("Error loading done tasks"));
          }
    });
    on<ChangeGridIcon>((event, emit) async {
      gridIcon = !gridIcon ;
    });
    on<ChangeIndexColor>((event, emit) async {
      isIndexChanged = !isIndexChanged ;
      add(LoadTasks());
    });
  }
}
