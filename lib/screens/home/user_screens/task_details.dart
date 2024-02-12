import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../Style/colors.dart';
import '../../../blocs/my_user_bloc/my_user_bloc.dart';
import '../home_screen.dart';

class TaskDetails extends StatefulWidget {
  const TaskDetails(
      {super.key,
      required this.taskTitle,
      required this.taskDescription,
      required this.taskColor,
      required this.taskDate,
      required this.id});

  final String id;
  final String taskTitle;
  final String taskColor;
  final String taskDescription;
  final DateTime taskDate;

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  final TaskRepository taskRepository = TaskRepository();

  @override
  Widget build(BuildContext context) {
    bool isImportant = false;
    Color selectedColor = HexColor("FF999A"); // Default color
    List<Color> colorOptions = [
      HexColor("FF999A"),
      HexColor("65DF9D"),
      HexColor("6BDBCF"),
      HexColor("71CFFE"),
      HexColor("61B1EF"),
      HexColor("F3CD3D"),
      HexColor("FBBD38"),
      HexColor("B183FB"),
    ];
    int selectedIndex = 0;
    String getHexCode(Color color) {
      String code = color.value.toRadixString(16).toString();
      code = code.substring(2);
      return code.toUpperCase();
    }

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
                    icon: Icon(Icons.arrow_back,
                        color: HexColor(widget.taskColor)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    "Task Details",
                    style: GoogleFonts.k2d(
                        color: HexColor(widget.taskColor),
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
                                            child: const MyHomePage(),
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
                            color: HexColor(widget.taskColor),
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
                          color: HexColor(widget.taskColor),
                          border: Border.all(
                              color: HexColor(widget.taskColor), width: 2),
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
                                    color: dark,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.taskDescription,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: dark,
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
                                  color: dark,
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
                        backgroundColor: HexColor(widget.taskColor),
                        insetPadding: EdgeInsets.zero,
                        title: Text(
                          "Update Task",
                          style: GoogleFonts.k2d(
                              color: dark,
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                        ),
                        content: StatefulBuilder(
                            builder: (context, StateSetter setState) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.transparent,
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: colorOptions.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedColor =
                                                  colorOptions[index];
                                              selectedIndex = index;
                                            });
                                          },
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            margin: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: colorOptions[index],
                                              shape: BoxShape.circle,
                                              border: selectedIndex == index
                                                  ? Border.all(
                                                      color: Colors.white,
                                                      width: 5)
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                TextField(
                                  controller: titleController,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: dark),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: dark2),
                                    ),
                                    label: Text(
                                      "Title",
                                      style: GoogleFonts.k2d(
                                          color: dark,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                TextField(
                                  controller: descriptionController,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: dark),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: dark2),
                                    ),
                                    label: Text(
                                      "Description",
                                      style: GoogleFonts.k2d(
                                          color: dark,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  minLines: 1,
                                  maxLines: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ToggleSwitch(
                                    customWidths: const [140.0, 150.0],
                                    initialLabelIndex: 1,
                                    cornerRadius: 10.0,
                                    borderWidth: 4,
                                    borderColor: [dark],
                                    activeFgColor: dark,
                                    inactiveBgColor: dark,
                                    inactiveFgColor: selectedColor,
                                    totalSwitches: 2,
                                    labels: const [
                                      'Important',
                                      'Not Important'
                                    ],
                                    icons: const [
                                      Icons.bookmark_added,
                                      Icons.bookmark_remove_rounded
                                    ],
                                    activeBgColor: [selectedColor],
                                    onToggle: (index) {
                                      if (index == 0) {
                                        isImportant = true;
                                      } else {
                                        isImportant = false;
                                      }
                                    },
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
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              taskBloc.add(UpdateTask(DateTime.now(),
                                  taskId: widget.id,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  color: getHexCode(selectedColor),
                                  isDone: false,
                                  isImportant: isImportant));
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: ( context) =>
                                          BlocProvider<TaskBloc>(
                                            create: (context) => TaskBloc(
                                              taskBloc.userId,
                                              taskBloc.taskRepository,
                                            ),
                                            child: const MyHomePage(),
                                          )),
                                      (Route<dynamic> route) => false);
                            },
                            child: const Text("Update"),
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
                        color: dark,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "Update",
                        style:
                            TextStyle(color: dark, fontWeight: FontWeight.bold),
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
