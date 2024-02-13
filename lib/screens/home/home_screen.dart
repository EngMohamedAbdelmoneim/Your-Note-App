import 'package:final_tasks_app/Style/colors.dart';
import 'package:final_tasks_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tasks_repository/tasks_repository.dart';
import '../../app_view.dart';
import '../../blocs/my_user_bloc/my_user_bloc.dart';

import '../../blocs/sign_in_bloc/sign_in_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TaskRepository taskRepository = TaskRepository();
  IconData gridIconOrListIcon = Icons.grid_view_outlined;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
                List<PreferredSizeWidget> appBars = [
                  AppBar(
                      backgroundColor: Colors.transparent,
                      title: Text(
                        taskBloc.titles[taskBloc.currentPageIndex],
                        style: GoogleFonts.k2d(
                            color: orange,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        BlocProvider(
                          create: (context) =>
                              SignInBloc(
                                  userRepository:
                                  BlocProvider
                                      .of<AuthenticationBloc>(context)
                                      .userRepository),
                          child: BlocBuilder<SignInBloc, SignInState>(
                            builder: (context, state) {
                              return IconButton(
                                  icon: Icon(
                                    Icons.logout,
                                    color: orange,
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<SignInBloc>(context)
                                        .add(const SignOutRequired());
                                  });
                            },
                          ),
                        ),
                      ]),
                  AppBar(
                      surfaceTintColor: Colors.blue,
                      backgroundColor: Colors.transparent,
                      scrolledUnderElevation: 100,
                      title: Text(
                        taskBloc.titles[taskBloc.currentPageIndex],
                        style: GoogleFonts.k2d(
                            color: blue,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        BlocProvider(
                          create: (context) =>
                              SignInBloc(
                                  userRepository:
                                  BlocProvider
                                      .of<AuthenticationBloc>(context)
                                      .userRepository),
                          child: BlocBuilder<SignInBloc, SignInState>(
                            builder: (context, state) {
                              return IconButton(
                                  icon: Icon(
                                    Icons.logout,
                                    color: blue,
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<SignInBloc>(context)
                                        .add(const SignOutRequired());
                                  });
                            },
                          ),
                        ),
                        BlocProvider(
                          create: (context) =>
                              TaskBloc(taskBloc.userId, taskRepository),
                          child: IconButton(
                            isSelected: context
                                .read<TaskBloc>()
                                .gridIcon,
                            onPressed: () {
                              setState(() {
                                if (context
                                    .read<TaskBloc>()
                                    .currentPageIndex == 1) {
                                  if (context
                                      .read<TaskBloc>()
                                      .isGridorList) {
                                    gridIconOrListIcon =
                                        Icons.format_list_bulleted;
                                    context.read<TaskBloc>().add(
                                        ChangeGridView());
                                  } else {
                                    gridIconOrListIcon =
                                        Icons.grid_view_outlined;
                                    context.read<TaskBloc>().add(
                                        ChangeGridView());
                                  }
                                } else {
                                  context.read<TaskBloc>().add(
                                      ChangeGridIcon());
                                }
                              });
                            },
                            selectedIcon: null,
                            icon: Icon(
                              gridIconOrListIcon,
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
                            color: lightPurple,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        BlocProvider(
                          create: (context) =>
                              SignInBloc(
                                  userRepository:
                                  BlocProvider
                                      .of<AuthenticationBloc>(context)
                                      .userRepository),
                          child: BlocBuilder<SignInBloc, SignInState>(
                            builder: (context, state) {
                              return IconButton(
                                  icon: Icon(
                                    Icons.logout,
                                    color: purple,
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<SignInBloc>(context)
                                        .add(const SignOutRequired());
                                  });
                            },
                          ),
                        ),
                      ]),
                  AppBar(
                      backgroundColor: Colors.transparent,
                      title: Text(
                        taskBloc.titles[taskBloc.currentPageIndex],
                        style: GoogleFonts.k2d(
                            color: green,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        BlocProvider(
                          create: (context) =>
                              SignInBloc(
                                  userRepository:
                                  BlocProvider
                                      .of<AuthenticationBloc>(context)
                                      .userRepository),
                          child: BlocBuilder<SignInBloc, SignInState>(
                            builder: (context, state) {
                              return IconButton(
                                  icon: Icon(
                                    Icons.logout,
                                    color: green,
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<SignInBloc>(context)
                                        .add(const SignOutRequired());
                                  });
                            },
                          ),
                        ),
                      ]),
                ];
                return Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: appBars[taskBloc.currentPageIndex],
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
                          icon: const Icon(
                            Icons.search_rounded,
                            weight: 200,
                          ),
                          title: Text("Search", style: GoogleFonts.k2d(),),
                          selectedColor: orange,
                          unselectedColor: dark),
                      SalomonBottomBarItem(

                          icon: const Icon(
                            Icons.home_filled,
                          ),
                          title: Text(
                            "Home", style: GoogleFonts.k2d(),
                          ),
                          selectedColor: blue,
                          unselectedColor: dark),
                      SalomonBottomBarItem(

                          icon: const Icon(
                            Icons.bookmark_outlined,
                          ),
                          title: Text("Important", style: GoogleFonts.k2d(),),
                          selectedColor: purple,
                          unselectedColor: dark),
                      SalomonBottomBarItem(
                        icon: const Icon(
                          Icons.check_circle,
                          weight: 5,
                        ),
                        title: Text("Done", style: GoogleFonts.k2d(),),
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
                      taskBloc.taskScreens[taskBloc.currentPageIndex],
                    ],
                  ),
                );
              },
            );
          }
          else {
            return MyAppView();
          }
        });
  }
}