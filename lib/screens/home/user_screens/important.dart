import 'package:final_tasks_app/screens/home/user_screens/task_details.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';
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
                              taskColor: task.color,
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
                color:purple,
                shape:  RoundedRectangleBorder(
                    side: BorderSide(color: purple,width: 3),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0))),

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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3.0),
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
                                child:  Padding(
                                  padding:const EdgeInsets.all(5),
                                  child: Icon(Icons.delete,size: 28,color: dark,),
                                ),
                                onTap: () {
                                  BlocProvider.of<TaskBloc>(context)
                                      .add(DeleteImportantTask(task.id));
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
                                taskBloc.add(UpdateImportantTask(
                                  task.date,
                                  taskId: task.id,
                                  isDone: value!,
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
                                child:  Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(Icons.bookmark_remove_rounded,size: 28,color: dark,),
                                ),
                                onTap: () {
                                  BlocProvider.of<TaskBloc>(context).add(
                                      UpdateImportantTask(task.date,
                                          taskId: task.id,
                                          isImportant: false,
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
              Text("Don't have important tasks",style: GoogleFonts.k2d(
                  color:  lightPurple.withOpacity(0.5), fontSize: 22, fontWeight: FontWeight.bold),),
            ],
          ),
        );
      } else {
        return  Center(
          child: CircularProgressIndicator(color:  purple,),
        );
      }
    },

    );}
}
