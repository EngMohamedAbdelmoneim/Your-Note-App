import 'package:final_tasks_app/Style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../blocs/my_user_bloc/my_user_bloc.dart';
import '../home_screen.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {

  int _selectedIndex = 0; // Default index, indicating no color selected


  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isImportant = false;

  Color _selectedColor =HexColor("FF999A"); // Default color
  final List<Color> _colorOptions = [
    HexColor("FF999A"),
    HexColor("65DF9D"),
    HexColor("6BDBCF"),
    HexColor("71CFFE"),
    HexColor("61B1EF"),
    HexColor("F3CD3D"),
    HexColor("FBBD38"),
    HexColor("B183FB"),
  ];
  String getHexCode(Color color) {
    String code = color.value.toRadixString(16).toString();
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
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: _selectedColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                "Add Task",
                style: GoogleFonts.k2d(
                    color: _selectedColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
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
                      SizedBox(
                        height: AppBar().preferredSize.height,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewPadding.top,
                      ),
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
                                  });
                                },
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  margin: const EdgeInsets.all(4),
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
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ToggleSwitch(
                                  customWidths: const [150.0, 150.0],
                                  initialLabelIndex: 1,
                                  cornerRadius: 10.0,
                                  customTextStyles: [GoogleFonts.k2d(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),GoogleFonts.k2d(
                                        fontSize: 14,
                                      fontWeight: FontWeight.bold)],
                                  borderWidth: 4,
                                  borderColor: [dark],
                                  activeFgColor: dark,
                                  inactiveBgColor: dark,
                                  inactiveFgColor: _selectedColor,
                                  animate: true,
                                  animationDuration: 200,
                                  totalSwitches: 2,
                                  labels: const ['Important', 'Not Important'],
                                  icons: const [
                                    Icons.bookmark_added,
                                    Icons.bookmark_remove_rounded
                                  ],
                                  activeBgColor: [_selectedColor],
                                  onToggle: (index) {
                                    if (index == 0) {
                                      isImportant = true;
                                    } else {
                                      isImportant = false;
                                    }
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10), // <-- Radius
                                        ),
                                        foregroundColor: _selectedColor,
                                        backgroundColor: dark,
                                        padding: const EdgeInsets.all(16.0),
                                        textStyle: const TextStyle(fontSize: 14),
                                      ),
                                      child: Text("Cancel",style: GoogleFonts.k2d(
                                          color: _selectedColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      onPressed: () {
                                        taskBloc.add(AddTask(
                                            taskRepository.createTask(
                                                title: titleController.text,
                                                description:
                                                    descriptionController.text,
                                                color:getHexCode(_selectedColor),
                                                date: currentDate,
                                                isImportant:
                                                    isImportant
                                                )));
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
                                      style: TextButton.styleFrom(

                                        foregroundColor: dark,
                                        backgroundColor: _selectedColor,
                                        side:   BorderSide(color: dark,width:4),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10), // <-- Radius
                                        ),
                                        padding: const EdgeInsets.all(16.0),
                                        textStyle: const TextStyle(fontSize: 14),
                                      ),
                                      child:  Text("Add",style: GoogleFonts.k2d(
                                          color: dark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),),
                                    ),
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
