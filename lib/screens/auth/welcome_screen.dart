
import 'package:final_tasks_app/Style/colors.dart';
import 'package:final_tasks_app/screens/auth/sign_in_screen.dart';
import 'package:final_tasks_app/screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/authentication_bloc/authentication_bloc.dart';
import '../../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../blocs/sign_up_bloc/sign_up_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: SvgPicture.asset(
                    'assets/backgrounds/BackGround.svg',
                    fit: BoxFit.fill,
                  ),
                ),

                SizedBox(
                  height: 580,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.2,
                      ),
                      SvgPicture.asset(
                        'assets/icons/SmallNote.svg',
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.2,

                      ),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.1,),
                      RichText(
                        text:  TextSpan(
                          style: const TextStyle(fontSize: 34),

                          children: <TextSpan>[

                            TextSpan(text: 'Welcome ', style:  GoogleFonts.k2d(
                                color: orange,  fontWeight: FontWeight.bold),),

                            TextSpan(text: 'to ', style:  GoogleFonts.k2d(
                                color: yellow,  fontWeight: FontWeight.bold),),
                            TextSpan(text: 'Your ', style:  GoogleFonts.k2d(
                                color: blue,  fontWeight: FontWeight.bold),),

                            TextSpan(text: 'Note', style:  GoogleFonts.k2d(
                                color: purple,  fontWeight: FontWeight.bold),),

                          ],

                        ),

                      ),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.02,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 9.0),
                        child: RichText(
                          text:  TextSpan(
                            style: const TextStyle(fontSize: 26),
                            children: <TextSpan>[

                              TextSpan(text: 'simple note ', style:  GoogleFonts.k2d(
                                  color: orange,  fontWeight: FontWeight.bold),),

                              TextSpan(text: ' app to ', style:  GoogleFonts.k2d(
                                  color: yellow,  fontWeight: FontWeight.bold),),
                              TextSpan(text: 'lead your ', style:  GoogleFonts.k2d(
                                  color: purple,  fontWeight: FontWeight.bold),),

                              TextSpan(text: 'tasks easily.', style:  GoogleFonts.k2d(
                                  color:lightBlue ,  fontWeight: FontWeight.bold),),

                            ],

                          ),

                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.02,),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.1,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => SignInBloc(
                                            userRepository: context
                                                .read<AuthenticationBloc>()
                                                .userRepository),
                                        child: const SignInScreen(),
                                      )));
                            },
                            style: TextButton.styleFrom(
                                elevation: 3.0,
                                backgroundColor:
                                    orange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              child: Text(
                                'Sign In',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.k2d(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.02,),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                              create: (context) => SignUpBloc(
                                                  userRepository: context
                                                      .read<AuthenticationBloc>()
                                                      .userRepository),
                                              child: const SignUpScreen(),
                                            )));
                              },
                              style: TextButton.styleFrom(
                                  elevation: 3.0,
                                  backgroundColor:
                                  purple,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 5),
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.k2d(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
