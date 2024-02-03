import 'package:final_tasks_app/screens/home/user_screens/task_details.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../../Style/colors.dart';
import '../../../blocs/my_user_bloc/my_user_bloc.dart';






class ImportantScreen extends StatelessWidget {
  final TaskRepository taskRepository = TaskRepository();

   ImportantScreen({super.key});
  @override
  Widget build(BuildContext context) {
    context.read<TaskBloc>().add(LoadImportantTasks());
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);

    return BlocBuilder<TaskBloc, TaskState>(
       builder: (context, state) {
      if (state is ImportantTasksLoaded) {
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
                          create: (context) =>
                              TaskBloc(
                                taskBloc.userId,
                                taskRepository,
                              ),
                          child: TaskDetails(
                              taskTitle: task.title,
                              taskDescription: task.description,
                              taskDate: task.date,
                              id: task.id
                          ),
                        ),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
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
                                horizontal: 3.0), child: Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
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
                              style: const TextStyle(
                                fontSize: 14.0,),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3.0),
                            child: Text(
                              DateFormat.yMd().format(task.date),
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              DateFormat.Hm().format(task.date),
                              style: const TextStyle(fontSize: 12.0),
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
                          const SizedBox(width: 15,),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.red.shade100,
                            child: IconButton(
                              color: Colors.red,
                              onPressed: () {
                                BlocProvider.of<TaskBloc>(context)
                                    .add(DeleteImportantTask(task.id));

                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),

                          Checkbox(
                            activeColor: Colors.greenAccent.shade200,
                            checkColor: Colors.green,
                            value: task.isDone,
                            onChanged: (value) {
                              taskBloc.add(UpdateImportantTask(
                                task.date,
                                taskId: task.id,
                                isDone: value!,
                                isImportant: task.isImportant
                              ));
                              taskBloc.add(LoadImportantTasks());
                            },
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: HexColor("00CBFF"),
                            child: IconButton(
                              color:  HexColor("1F1F29"),
                              onPressed: () {
                                BlocProvider.of<TaskBloc>(context).add(UpdateImportantTask(
                                    task.date,
                                    taskId: task.id,
                                    isDone: task.isDone, isImportant: !task.isImportant
                                ));
                              },
                              icon:  Icon(Icons.bookmark_remove_rounded, color:  HexColor("1F1F29"),),
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
      } else if (state is TasksError) {
        return Center(
          child: Text(state.message),
        );
      }else if (state is EmptyTasksMessage) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bookmark_border_rounded,color:lightPurple.withOpacity(0.5), size: 100 ,),
              Text(state.message,style: GoogleFonts.k2d(
                  color:  lightPurple.withOpacity(0.5), fontSize: 22, fontWeight: FontWeight.bold),),
            ],
          ),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },

    );}
}
