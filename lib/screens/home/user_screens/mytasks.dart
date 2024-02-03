import 'dart:math';


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
    const List<Widget> status = <Widget>[
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Not Important'),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Important'),
      ),
    ];
    List<bool> important = <bool>[
      false,
      true,
    ];
    bool isImportant = true;
    List<Color> gridColors = [
      HexColor("FFFFFF"),
      HexColor("008EFF"),
      HexColor("52FBDD"),
    ];
    Color getRandomColor() {
      final random = Random();
      return gridColors[random.nextInt(gridColors.length)];
    }

    DateTime currentDate = DateTime.now();
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    print("MY ID Is Here ${taskBloc.userId}");
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
                                  taskDate: task.date,
                                  id: task.id),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color:  taskBloc.isIndexChanged ? HexColor("0000FF") : HexColor("00CBFF"),
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
                                      style:  TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color:  taskBloc.isIndexChanged ? HexColor("FFFFFF") : HexColor("000000"),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:  const EdgeInsets.symmetric(
                                        horizontal: 3.0),
                                    child: Text(
                                      task.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:  TextStyle(
                                        fontSize: 14.0,
                                        color:  taskBloc.isIndexChanged ? HexColor("FFFFFF") : HexColor("000000"),

                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3.0),
                                    child: Text(
                                      DateFormat.yMd().format(task.date),
                                      style:  TextStyle(fontSize: 12.0,
                                        color:  taskBloc.isIndexChanged ? HexColor("FFFFFF") : HexColor("000000"),
                                      ),

                                    ),
                                  ),
                                  Padding(
                                    padding:  const EdgeInsets.all(2.0),
                                    child: Text(
                                      DateFormat.Hm().format(task.date),
                                      style: TextStyle(fontSize: 12.0,
                                        color:  taskBloc.isIndexChanged ? HexColor("FFFFFF") : HexColor("000000"),
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
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.red.shade100,
                                    child: IconButton(
                                      color: Colors.red,
                                      onPressed: () {
                                        BlocProvider.of<TaskBloc>(context)
                                            .add(DeleteTask(task.id));
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ),
                                  Checkbox(
                                    activeColor: Colors.greenAccent.shade200,
                                    checkColor: Colors.green,
                                    side : BorderSide(width: 2,color:taskBloc.isIndexChanged ? HexColor("FFFFFF") : HexColor("000000"), ),
                                    value: task.isDone,
                                    onChanged: (value) {
                                      taskBloc.add(UpdateTask(
                                        task.date,
                                        taskId: task.id,
                                        isDone: value!,
                                        title: task.title,
                                        description: task.description,
                                        isImportant: task.isImportant,
                                      ));
                                    },
                                  ),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.blue.withOpacity(0.9),
                                    child: IconButton(
                                      color:  taskBloc.isIndexChanged ? HexColor("FFFFFF") : HexColor("000000"),
                                      onPressed: () {
                                        BlocProvider.of<TaskBloc>(context).add(UpdateTask(
                                            task.date,
                                            taskId: task.id,
                                            isImportant: true,
                                            title: task.title,
                                            description: task.description,
                                            isDone: task.isDone
                                        ));
                                      },
                                      icon: const Icon(Icons.bookmark_added),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Set the number of columns in the grid
                    crossAxisSpacing: 8.0, // Set the spacing between columns
                    mainAxisSpacing: 8.0, // Set the spacing between rows
                  ),
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) {
                    final task = state.tasks[index];
                    final randomColor = getRandomColor();
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
                                taskDate: task.date,
                                id: task.id,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color:taskBloc.isIndexChanged ? HexColor("0000FF") : HexColor("00CBFF"),
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
                                      style:  TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color:  taskBloc.isIndexChanged ? HexColor("FFFFFF") : HexColor("000000"),
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
                                      style:  TextStyle(
                                        fontSize: 14.0,
                                        color:  taskBloc.isIndexChanged ? HexColor("FFFFFF") : HexColor("000000"),

                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3.0),
                                    child: Text(
                                      DateFormat.yMd().format(task.date),
                                      style:  TextStyle(fontSize: 12.0,
                                        color:  taskBloc.isIndexChanged ? HexColor("FFFFFF") : HexColor("000000"),

                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      DateFormat.Hm().format(task.date),
                                      style: TextStyle(fontSize: 12.0,
                                        color:  taskBloc.isIndexChanged ? HexColor("FFFFFF") : HexColor("000000"),

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
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.red.shade100,
                                    child: IconButton(
                                      color: Colors.red,
                                      onPressed: () {
                                        BlocProvider.of<TaskBloc>(context)
                                            .add(DeleteTask(task.id));
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ),
                                  Checkbox(
                                    checkColor: Colors.green,
                                    value: task.isDone,
                                    fillColor: MaterialStateProperty.resolveWith ((Set  states) {
                                      if (states.contains(MaterialState.disabled)) {
                                        return Colors.white;
                                      }
                                      return Colors.transparent;
                                    }),
                                    side : BorderSide(width: 2,color:taskBloc.isIndexChanged ? HexColor("FFFFFF") : HexColor("000000"), ),
                                    onChanged: (value) {
                                      taskBloc.add(UpdateTask(
                                        task.date,
                                        taskId: task.id,
                                        isDone: value!,
                                        title: task.title,
                                        description: task.description,
                                        isImportant: task.isImportant,
                                      ));
                                    },
                                  ),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.blue.withOpacity(0.9),
                                    child: IconButton(
                                      color:  taskBloc.isIndexChanged ? HexColor("FFFFFF") : HexColor("000000"),
                                      onPressed: () {
                                        BlocProvider.of<TaskBloc>(context).add(UpdateTask(
                                            task.date,
                                            taskId: task.id,
                                            isImportant: true,
                                            title: task.title,
                                            description: task.description,
                                            isDone: task.isDone
                                        ));
                                      },
                                      icon: const Icon(Icons.bookmark_added),
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
                    Icon(Icons.add_rounded,color: blue.withOpacity(0.5),size: 180,),
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
            // Show a dialog to add a new task
            print(dark.value);

            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    BlocProvider<TaskBloc>(
                      create: (context) => TaskBloc(
                        taskBloc.userId,
                        taskRepository,
                      ),
                      child: const AddNoteScreen(),
                    ),
              ),
            );

                // return AlertDialog(
                //   insetPadding: EdgeInsets.zero,
                //   title: Text(
                //     "Add Task",
                //     style: GoogleFonts.k2d(
                //         color: darkBlue,
                //         fontSize: 22,
                //         fontWeight: FontWeight.w600),
                //   ),
                //   content:
                //       StatefulBuilder(builder: (context, StateSetter setState) {
                //     return SingleChildScrollView(
                //       child: Column(
                //         children: [
                //           TextField(
                //             controller: titleController,
                //             decoration:
                //                 const InputDecoration(labelText: "Title"),
                //           ),
                //           TextField(
                //             controller: descriptionController,
                //             decoration:
                //                 const InputDecoration(labelText: "Description"),
                //             minLines: 1,
                //             maxLines: 10,
                //           ),
                //           Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: ToggleButtons(
                //               direction: Axis.horizontal,
                //               onPressed: (int index) {
                //                 setState(() {
                //                   for (int i = 0; i < important.length; i++) {
                //                     important[i] = i == index;
                //                   }
                //                   print(important[1]);
                //                   isImportant = important[1];
                //                   print(isImportant);
                //                 });
                //                 // The button that is tapped is set to true, and the others to false.
                //               },
                //               borderRadius:
                //                   const BorderRadius.all(Radius.circular(8)),
                //               selectedBorderColor: darkBlue,
                //               selectedColor: Colors.white,
                //               fillColor: darkBlue,
                //               color: darkBlue,
                //               constraints: const BoxConstraints(
                //                 minHeight: 40.0,
                //                 minWidth: 110.0,
                //               ),
                //               isSelected: important,
                //               children: status,
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //   }),
                //   actions: [
                //     TextButton(
                //       onPressed: () {
                //         Navigator.pop(context);
                //       },
                //       child: Text("Cancel"),
                //     ),
                //     TextButton(
                //       onPressed: () {
                //         taskBloc.add(AddTask(taskRepository.createTask(
                //             title: titleController.text,
                //             // Replace with your logic for setting default values
                //             description: descriptionController.text,
                //             date: currentDate,
                //             isImportant:
                //                 isImportant // Replace with your logic for setting default values
                //             )));
                //         taskBloc.add(LoadTasks());
                //         Navigator.pop(context);
                //       },
                //       child: const Text("Add"),
                //     ),
                //   ],
                // );

          },
          child: Icon(Icons.add_rounded,color: blue,weight: 5,size: 40,),
        ),
      ));

  }
}
