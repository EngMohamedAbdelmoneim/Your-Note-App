import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../Style/colors.dart';
import '../../../blocs/my_user_bloc/my_user_bloc.dart';
import '../home_screen.dart';

class TaskDetails extends StatefulWidget {
  const TaskDetails(
      {super.key,
      required this.taskTitle,
      required this.taskDescription,
      required this.taskDate,
      required this.id});

  final String id;
  final String taskTitle;
  final String taskDescription;
  final DateTime taskDate;

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
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
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {},
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white,

            ),
            child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: darkBlue),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    "Task Details",
                    style: GoogleFonts.k2d(
                        color: darkBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    BlocBuilder<TaskBloc, TaskState>(
                      builder: (context, state) {
                        return IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              context
                                  .read<TaskBloc>()
                                  .add(DeleteTask(widget.id));
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          BlocProvider<TaskBloc>(
                                            create: (context) => TaskBloc(
                                              taskBloc.userId,
                                              taskBloc.taskRepository,
                                            ),
                                            child: MyHomePage(),
                                          )),
                                  (Route<dynamic> route) => false);
                            });
                      },
                    ),
                  ]),
              body: Stack(children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: SvgPicture.asset(
                    'assets/backgrounds/BackGround.svg',
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: AppBar().preferredSize.height,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).viewPadding.top,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 1.0),
                      child: Text(
                        "Description",
                        style: GoogleFonts.k2d(
                            color: darkBlue,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: darkBlue,
                          border: Border.all(color: darkBlue, width: 2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.taskTitle,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: textWhite,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.taskDescription,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textWhite,
                                ),
                                maxLines: 10,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Task Time: ${DateFormat.Hm().format(widget.taskDate)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController titleController =
                          TextEditingController.fromValue(
                              TextEditingValue(text: widget.taskTitle));
                      TextEditingController descriptionController =
                          TextEditingController.fromValue(
                              TextEditingValue(text: widget.taskDescription));

                      return AlertDialog(
                        insetPadding: EdgeInsets.zero,
                        title: Text(
                          "Update Task",
                          style: GoogleFonts.k2d(
                              color: darkBlue,
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                        ),
                        content: StatefulBuilder(
                            builder: (context, StateSetter setState) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  controller: titleController,
                                  decoration:
                                      const InputDecoration(labelText: "Title"),
                                ),
                                TextField(
                                  controller: descriptionController,
                                  decoration: const InputDecoration(
                                      labelText: "Description"),
                                  minLines: 1,
                                  maxLines: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ToggleButtons(
                                    direction: Axis.horizontal,
                                    onPressed: (int index) {
                                      setState(() {
                                        for (int i = 0;
                                            i < important.length;
                                            i++) {
                                          important[i] = i == index;
                                        }
                                        print(important[1]);
                                        isImportant = important[1];
                                        print(isImportant);
                                      });
                                      // The button that is tapped is set to true, and the others to false.
                                    },
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    selectedBorderColor: darkBlue,
                                    selectedColor: Colors.white,
                                    fillColor: darkBlue,
                                    color: darkBlue,
                                    constraints: const BoxConstraints(
                                      minHeight: 40.0,
                                      minWidth: 110.0,
                                    ),
                                    isSelected: important,
                                    children: status,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              taskBloc.add(UpdateTask(DateTime.now(),
                                  taskId: widget.id,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  isDone: false,
                                  isImportant: isImportant));
                              taskBloc.add(LoadTasks());
                              Navigator.pop(context);
                            },
                            child: Text("Add"),
                          ),
                        ],
                      );
                    },
                  );
                },
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                label: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.update,
                        color: darkBlue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "Update",
                        style: TextStyle(
                            color: darkBlue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
