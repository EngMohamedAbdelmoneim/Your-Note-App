import 'package:flutter/material.dart';

import 'package:final_tasks_app/screens/home/user_screens/task_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../../Style/colors.dart';
import '../../../blocs/my_user_bloc/my_user_bloc.dart';
import 'add_note_screen.dart';

class MyTasks extends StatelessWidget {
  final TaskRepository taskRepository = TaskRepository();

  MyTasks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    taskBloc.add(LoadTasks());
    return BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {},
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TasksLoaded) {
                if (context.read<TaskBloc>().isGridorList) {
                  return ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  BlocProvider<TaskBloc>(
                                create: (context) => TaskBloc(
                                  taskBloc.userId,
                                  taskRepository,
                                ),
                                child: TaskDetails(
                                    taskTitle: task.title,
                                    taskDescription: task.description,
                                    taskColor: task.color,
                                    taskDate: task.date,
                                    id: task.id),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: HexColor(task.color),
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3.0),
                                      child: Text(
                                        task.title,
                                        style: GoogleFonts.k2d(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: dark,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3.0),
                                      child: Text(
                                        task.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.k2d(
                                          fontSize: 14.0,
                                          color: dark2,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        DateFormat.jm().format(task.date),
                                        style: GoogleFonts.k2d(
                                          fontSize: 12.0,
                                          color: dark2,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3.0),
                                      child: Text(
                                        DateFormat.MEd().format(task.date),
                                        style: GoogleFonts.k2d(
                                          fontSize: 12.0,
                                          color: dark2,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.delete,
                                              size: 28,
                                              color: dark,
                                            ),
                                          ),
                                          onTap: () {
                                            BlocProvider.of<TaskBloc>(context)
                                                .add(DeleteTask(task.id));
                                          },
                                        ),
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 1.25,
                                      child: Checkbox(
                                        shape: const CircleBorder(),
                                        activeColor:
                                            Colors.greenAccent.shade200,
                                        checkColor: Colors.green,
                                        side: BorderSide(
                                          width: 2,
                                          color: dark,
                                        ),
                                        value: task.isDone,
                                        onChanged: (value) {
                                          taskBloc.add(UpdateTask(
                                            task.date,
                                            taskId: task.id,
                                            isDone: value!,
                                            title: task.title,
                                            description: task.description,
                                            color: task.color,
                                            isImportant: task.isImportant,
                                          ));
                                        },
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.bookmark_add,
                                              size: 28,
                                              color: dark,
                                            ),
                                          ),
                                          onTap: () {
                                            BlocProvider.of<TaskBloc>(context)
                                                .add(UpdateTask(task.date,
                                                    taskId: task.id,
                                                    isImportant: true,
                                                    title: task.title,
                                                    description:
                                                        task.description,
                                                    color: task.color,
                                                    isDone: task.isDone));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      // Set the number of columns in the grid
                      crossAxisSpacing: 8.0,
                      // Set the spacing between columns
                      mainAxisSpacing: 8.0, // Set the spacing between rows
                    ),
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  BlocProvider<TaskBloc>(
                                create: (context) => TaskBloc(
                                  taskBloc.userId,
                                  taskRepository,
                                ),
                                child: TaskDetails(
                                  taskColor: task.color,
                                  taskTitle: task.title,
                                  taskDescription: task.description,
                                  taskDate: task.date,
                                  id: task.id,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: HexColor(task.color),
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3.0),
                                      child: Text(
                                        task.title,
                                        style: GoogleFonts.k2d(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: dark,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3.0),
                                      child: Text(
                                        task.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.k2d(
                                          fontSize: 14.0,
                                          color: dark2,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        DateFormat.jm().format(task.date),
                                        style: GoogleFonts.k2d(
                                          fontSize: 12.0,
                                          color: dark2,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3.0),
                                      child: Text(
                                        DateFormat.MEd().format(task.date),
                                        style: GoogleFonts.k2d(
                                          fontSize: 12.0,
                                          color: dark2,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.delete,
                                              size: 24,
                                              color: dark,
                                            ),
                                          ),
                                          onTap: () {
                                            BlocProvider.of<TaskBloc>(context)
                                                .add(DeleteTask(task.id));
                                          },
                                        ),
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 1.1,
                                      child: Checkbox(
                                        shape: const CircleBorder(),
                                        activeColor:
                                            Colors.greenAccent.shade200,
                                        checkColor: Colors.green,
                                        side: BorderSide(
                                          width: 2,
                                          color: dark,
                                        ),
                                        value: task.isDone,
                                        onChanged: (value) {
                                          taskBloc.add(UpdateTask(
                                            task.date,
                                            taskId: task.id,
                                            isDone: value!,
                                            title: task.title,
                                            description: task.description,
                                            color: task.color,
                                            isImportant: task.isImportant,
                                          ));
                                        },
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              Icons.bookmark_add,
                                              size: 24,
                                              color: dark,
                                            ),
                                          ),
                                          onTap: () {
                                            BlocProvider.of<TaskBloc>(context)
                                                .add(UpdateTask(task.date,
                                                    taskId: task.id,
                                                    isImportant: true,
                                                    title: task.title,
                                                    description:
                                                        task.description,
                                                    color: task.color,
                                                    isDone: task.isDone));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              } else if (state is TasksError) {
                return Center(
                  child: Text(state.message),
                );
              } else if (state is EmptyTasksMessage) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        color: blue.withOpacity(0.5),
                        size: 180,
                      ),
                      Text(
                        state.message,
                        style: GoogleFonts.k2d(
                            color: blue.withOpacity(0.5),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => BlocProvider<TaskBloc>(
                    create: (context) => TaskBloc(
                      taskBloc.userId,
                      taskRepository,
                    ),
                    child: const AddNoteScreen(),
                  ),
                ),
              );
            },
            child: Icon(
              Icons.add_rounded,
              color: blue,
              weight: 5,
              size: 40,
            ),
          ),
        ));
  }
}
