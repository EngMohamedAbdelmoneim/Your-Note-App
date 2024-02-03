import 'package:final_tasks_app/Style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tasks_repository/tasks_repository.dart';
import '../../blocs/my_user_bloc/my_user_bloc.dart';

import '../../blocs/sign_in_bloc/sign_in_bloc.dart';

class MyHomePage extends StatefulWidget {


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TaskRepository taskRepository = TaskRepository();
  IconData GridIconOrListIcon = Icons.grid_view_outlined;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
        List<PreferredSizeWidget> Appbars = [
          AppBar(
            backgroundColor: Colors.transparent,
              title: Text(
                taskBloc.titles[taskBloc.currentPageIndex],
                style: GoogleFonts.k2d(
                    color: orange, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              actions: [
                BlocBuilder<SignInBloc, SignInState>(
                  builder: (context, state) {
                    return IconButton(
                        icon: Icon(
                          Icons.logout,
                          color:  orange,
                        ),
                        onPressed: () {
                          context
                              .read<SignInBloc>()
                              .add(const SignOutRequired());
                        });
                  },
                ),
              ]
          ),
          AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                taskBloc.titles[taskBloc.currentPageIndex],
                style: GoogleFonts.k2d(
                    color: blue, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              actions: [
                BlocBuilder<SignInBloc, SignInState>(
                  builder: (context, state) {
                    return IconButton(
                        icon: Icon(
                          Icons.logout,
                          color:blue,
                        ),
                        onPressed: () {
                          context
                              .read<SignInBloc>()
                              .add(const SignOutRequired());
                        });
                  },
                ),
                IconButton(
                    icon: taskBloc.isIndexChanged
                        ? Icon(
                      Icons.invert_colors_on,
                      color: HexColor("00CBFF"),
                    )
                        : Icon(
                      Icons.invert_colors_rounded,
                      color: HexColor("0000FF"),
                    ),
                    onPressed: () {
                      taskBloc.add(ChangeIndexColor());
                    }),
                BlocProvider(
                  create: (context) => TaskBloc(taskBloc.userId, taskRepository),
                  child: IconButton(
                    isSelected: context.read<TaskBloc>().gridIcon,
                    onPressed: () {
                      setState(() {
                        if (context.read<TaskBloc>().currentPageIndex == 1) {
                          if (context.read<TaskBloc>().isGridorList) {
                            GridIconOrListIcon = Icons.format_list_bulleted;
                            context.read<TaskBloc>().add(ChangeGridView());
                          } else {
                            GridIconOrListIcon = Icons.grid_view_outlined;
                            context.read<TaskBloc>().add(ChangeGridView());
                          }
                          print(context.read<TaskBloc>().isGridorList);
                        } else {
                          context.read<TaskBloc>().add(ChangeGridIcon());
                        }
                      });
                    },
                    selectedIcon: null,
                    icon: Icon(
                      GridIconOrListIcon,
                      color: blue,
                    ),
                  ),
                ),
              ]),
          AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                taskBloc.titles[taskBloc.currentPageIndex],
                style: GoogleFonts.k2d(
                    color: lightPurple, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              actions: [
                BlocBuilder<SignInBloc, SignInState>(
                  builder: (context, state) {
                    return IconButton(
                        icon: Icon(
                          Icons.logout,
                          color:lightPurple,
                        ),
                        onPressed: () {
                          context
                              .read<SignInBloc>()
                              .add(const SignOutRequired());
                        });
                  },
                ),
              ]

              ),
          AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                taskBloc.titles[taskBloc.currentPageIndex],
                style: GoogleFonts.k2d(
                    color: green, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              actions: [
                BlocBuilder<SignInBloc, SignInState>(
                  builder: (context, state) {
                    return IconButton(
                        icon: Icon(
                          Icons.logout,
                          color: green,
                        ),
                        onPressed: () {
                          context
                              .read<SignInBloc>()
                              .add(const SignOutRequired());
                        });
                  },
                ),
              ]),
        ];
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: Appbars[taskBloc.currentPageIndex],
          bottomNavigationBar: SalomonBottomBar(
            selectedItemColor: Colors.white,
            selectedColorOpacity: 0.3,
            currentIndex: taskBloc.currentPageIndex,
            onTap: (index) {
              taskBloc.add(AppChangeBottomNavBarEvent(index: index));
              if (index == 0 || index == 1) {
                taskBloc.add(LoadTasks());
              } else if (index == 2) {
                taskBloc.add(LoadImportantTasks());
              } else {
                taskBloc.add(LoadDoneTasks());
              }
            },
            backgroundColor: Colors.white,
            items: [
              SalomonBottomBarItem(
                  icon:  const Icon(
                    Icons.search_rounded,
                    weight: 200,
                  ),
                  title: const Text("Search"),
                  selectedColor: orange,
                  unselectedColor: dark),
              SalomonBottomBarItem(
                  icon: const Icon(
                    Icons.home_filled,
                  ),
                  title: const Text(
                    "Home",
                  ),
                  selectedColor: blue,
                  unselectedColor:dark),
              SalomonBottomBarItem(
                  activeIcon: const Icon(
                    Icons.bookmark_border,
                  ),
                  icon: const Icon(
                    Icons.bookmark,
                  ),
                  title: const Text("Important"),
                  selectedColor: purple,
                  unselectedColor: dark),
              SalomonBottomBarItem(
                icon: const Icon(
                  Icons.check_circle_outline,
                  weight: 5,
                ),
                title: const Text("Done"),
                selectedColor: green,
                unselectedColor: dark,
              ),
            ],
          ),
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
              taskBloc.Task_Screens[taskBloc.currentPageIndex],
            ],
          ),
        );
      },
    );
  }
}
