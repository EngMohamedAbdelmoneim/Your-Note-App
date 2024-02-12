import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:final_tasks_app/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:final_tasks_app/screens/auth/welcome_screen.dart';
import 'package:final_tasks_app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'blocs/sign_in_bloc/sign_in_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskRepository repository = TaskRepository();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Status bar color
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Auth',
      theme: ThemeData(
        textTheme: const TextTheme(
            displayLarge: TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
        )),
        colorScheme: const ColorScheme.light(
            background: Colors.white,
            onBackground: Colors.white,
            primary: Color(0xFF424242),
            onPrimary: Colors.white,
            secondary: Color.fromRGBO(0, 166, 255, 1.0),
            onSecondary: Colors.black,
            tertiary: Color.fromRGBO(255, 204, 128, 1),
            error: Colors.red,
            outline: Color(0xFF424242)),
      ),
      home: AnimatedSplashScreen(
        duration: 2000,
        splash: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(children: [
              SvgPicture.asset(
                'assets/backgrounds/BackGround.svg',
                fit: BoxFit.fill,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  SvgPicture.asset(
                    'assets/icons/Note logo out.svg',
                    height:MediaQuery.of(context).size.width * 0.7,
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    GradientText("Your",style: GoogleFonts.k2d(
                         fontSize: 60, fontWeight: FontWeight.bold),
                    gradient: LinearGradient(colors: [
                      HexColor("61B1EF"),
                      HexColor("1682D6"),
                    ]),
                    ),
                    GradientText("Note",style: GoogleFonts.k2d(
                        fontSize: 60, fontWeight: FontWeight.bold),
                      gradient: LinearGradient(colors: [
                        HexColor("E74ABB"),
                        HexColor("E70BBB"),
                      ]),
                    ),
                  ],)
                ],),
              )
            ])),
        nextScreen: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return MultiBlocProvider(providers: [
              BlocProvider(
                create: (context) => SignInBloc(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository),
              ),
              BlocProvider(
                create: (context) => TaskBloc(state.user!.uid, repository),
              )
            ], child: const MyHomePage());
          } else {
            return const WelcomeScreen();
          }
        }),
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.bottomToTop,
        splashIconSize: double.infinity,
        backgroundColor: HexColor('#0000FF'),
      ),
    );
  }
}
