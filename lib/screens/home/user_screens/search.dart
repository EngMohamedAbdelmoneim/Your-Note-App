import 'package:final_tasks_app/screens/home/user_screens/task_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../../Style/colors.dart';
import '../../../blocs/my_user_bloc/my_user_bloc.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    final taskBloc = BlocProvider.of<TaskBloc>(context);
    final TaskRepository taskRepository = TaskRepository();
    taskBloc.add(LoadAllTasks());
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TasksLoaded) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: AppBar().preferredSize.height*1.5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        onChanged: (query) {
                          taskBloc.add(SearchTasks(query));
                        },
                        style:  TextStyle(color: dark),
                        cursorColor: dark,
                        decoration: InputDecoration(
                          suffixIcon:  Padding(
                            padding: EdgeInsets.zero,
                            child: Icon(
                              Icons.search_rounded,
                              color: dark,
                              size: 26,
                              weight: 10,
                            ),
                          ),
                          filled: true,
                          fillColor:orange,
                          hintText: "Search",
                          hintStyle:  TextStyle(
                              color: dark, fontWeight: FontWeight.bold),
                          labelStyle:  TextStyle(color: dark),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 3, color: yellow),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(width: 3, color:orange),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric( vertical: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,

                        child: ListView.builder(
                          padding: EdgeInsets.zero,
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
                                          id: task.id, taskColor: task.color,),
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                color: orange,
                                elevation: 1.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 3.0),
                                                child: Text(
                                                  task.title,
                                                  style:  GoogleFonts.k2d(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,color: dark
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 3.0),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context).size.width*0.6,
                                                  child: Text(
                                                    task.description,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style:  GoogleFonts.k2d(
                                                      fontSize: 14.0,color: dark
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is TasksError) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is EmptyTasksMessage) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   Icon(Icons.search,color: orange.withOpacity(0.5), size: 100 ,),
                    Text("No Tasks to search",style: GoogleFonts.k2d(
                        color: orange.withOpacity(0.5), fontSize: 22, fontWeight: FontWeight.bold),),
                  ],
                ),
              );
            }else {
              return Center(
                child: CircularProgressIndicator(color:  orange,),
              );
            }
          },
        ),

    );
  }
}
