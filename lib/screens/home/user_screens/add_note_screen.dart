import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../../Style/colors.dart';
import '../../../blocs/my_user_bloc/my_user_bloc.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  Color _selectedColor = Colors.red; // Default color
  int _selectedIndex = 0; // Default index, indicating no color selected

  List<Color> _colorOptions = [
    HexColor("FF999A"),
    HexColor("65DF9D"),
    HexColor("6BDBCF"),
    HexColor("71CFFE"),
    HexColor("61B1EF"),
    HexColor("F3CD3D"),
    HexColor("FBBD38"),
    HexColor("B183FB"),
  ];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Widget> status = <Widget>[
    const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('Not Important'),
    ),
    const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('Important'),
    ),
  ];
  List<bool> important = <bool>[
    false,
    true,
  ];
  bool isImportant = true;

  String getHexCode(Color color){
    String code  = color.value.toRadixString(16).toString();
    code = code.substring(2);
    return code.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    final TaskRepository taskRepository = TaskRepository();
    DateTime currentDate = DateTime.now();
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {},
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text("Add Task" ,style: GoogleFonts.k2d(
                color: _selectedColor, fontSize: 22, fontWeight: FontWeight.bold),),),
            backgroundColor: _selectedColor,
            body: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: SvgPicture.asset(
                    'assets/backgrounds/BackGround.svg',
                    fit: BoxFit.fill,
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemCount: _colorOptions.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = _colorOptions[index];
                                    _selectedIndex = index;
                                    print(getHexCode(_selectedColor));

                                  });
                                },
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  margin: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: _colorOptions[index],
                                    shape: BoxShape.circle,
                                    border: _selectedIndex == index
                                        ? Border.all(
                                        color: Colors.white, width: 5)
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: _selectedColor,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: titleController,
                                decoration:  InputDecoration(label: Text("Title" ,style: GoogleFonts.k2d(
                                    color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),),
                              ),
                              TextField(
                                controller: descriptionController,
                                decoration: InputDecoration(label: Text("Description" ,style: GoogleFonts.k2d(
                                    color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),),
                                minLines: 1,
                                maxLines: 10,
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    border: Border.all(color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                    child: ToggleButtons(
                                    direction: Axis.horizontal,
                                    onPressed: (int index) {
                                      setState(() {
                                        for (int i = 0; i < important.length; i++) {
                                          important[i] = i == index;
                                        }
                                        print(important[1]);
                                        isImportant = important[1];
                                        print(isImportant);
                                      });
                                      // The button that is tapped is set to true, and the others to false.
                                    },
                                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                                    selectedBorderColor: darkBlue,
                                    selectedColor: Colors.white,
                                    disabledColor: Colors.white,
                                    fillColor: darkBlue,
                                    color: _selectedColor,
                                    splashColor: Colors.white,
                                    constraints: const BoxConstraints(
                                      minHeight: 40.0,
                                      minWidth: 110.0,
                                    ),
                                    isSelected: important,
                                    children: status,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      taskBloc.add(AddTask(taskRepository.createTask(
                                          title: titleController.text,
                                          // Replace with your logic for setting default values
                                          description: descriptionController.text,
                                          date: currentDate,
                                          isImportant:
                                              isImportant // Replace with your logic for setting default values
                                          )));
                                      taskBloc.add(LoadTasks());
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Add"),
                                  ),

                                ],

                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
