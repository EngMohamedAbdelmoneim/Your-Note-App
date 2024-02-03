import 'package:final_tasks_app/Style/colors.dart';
import 'package:final_tasks_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:final_tasks_app/screens/auth/reset_password.dart';
import 'package:final_tasks_app/screens/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../app_view.dart';
import '../../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../blocs/sign_up_bloc/sign_up_bloc.dart';
import '../home/home_screen.dart';
import 'components/my_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = Icons.visibility_outlined;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          setState(() {
            signInRequired = false;
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(builder: (context) => const MyAppView()),
                (Route<dynamic> route) => false);
          });
        } else if (state is SignInProcess) {
          setState(() {
            signInRequired = true;
          });
        } else if (state is SignInFailure) {
          setState(() {
            signInRequired = false;
            _errorMsg = 'Invalid email or password';
          });
        }
      },
      child: Scaffold(
        body: Center(
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
              Center(
                child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [

                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/Small logo.svg',
                                        height:MediaQuery.of(context).size.width * 0.3,
                                        width: MediaQuery.of(context).size.width * 0.3,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GradientText("Welcome",style: GoogleFonts.k2d(
                                              fontSize: 40, fontWeight: FontWeight.bold),
                                            gradient: LinearGradient(colors: [
                                              orange,
                                              Colors.orange,
                                            ]),
                                          ),
                                          GradientText("Back",style: GoogleFonts.k2d(
                                              fontSize: 40, fontWeight: FontWeight.bold),
                                            gradient: LinearGradient(colors: [
                                              yellow,
                                             Colors.yellow.shade700
                                            ]),
                                          ),
                                        ],),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GradientText("Sign In to your account",style: GoogleFonts.k2d(
                                              fontSize: 18, fontWeight: FontWeight.bold),
                                            gradient: LinearGradient(colors: [
                                              orange,
                                              Colors.orange,
                                            ]),
                                          ),

                                        ],)
                                    ],),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.87,
                                    height: 55,
                                    child: MyTextField(
                                        controller: emailController,
                                        hintText: 'Email',
                                        obscureText: false,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        errorMsg: _errorMsg,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Please fill in this field';
                                          } else if (!RegExp(
                                                  r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                              .hasMatch(val)) {
                                            return 'Please enter a valid email';
                                          }
                                          return null;
                                        })),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.87,
                                  height: 55,
                                  child: MyTextField(
                                    controller: passwordController,
                                    hintText: 'Password',
                                    obscureText: obscurePassword,
                                    keyboardType: TextInputType.visiblePassword,
                                    errorMsg: _errorMsg,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'Please fill in this field';
                                      } else if (!RegExp(
                                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                                          .hasMatch(val)) {
                                        return 'Please enter a valid password';
                                      }
                                      return null;
                                    },
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obscurePassword = !obscurePassword;
                                          if (obscurePassword) {
                                            iconPassword =
                                                Icons.visibility_outlined;
                                          } else {
                                            iconPassword =
                                                Icons.visibility_off_outlined;
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        iconPassword,
                                        color:orange,
                                      ),
                                    ),
                                  ),
                                ),
                                BlocProvider(
                                    create: (context) =>
                                        context.read<SignInBloc>(),
                                    child: TextButton(
                                      child: Text(
                                        "Forgot the Password?",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationColor: HexColor("008EFF"),
                                          color: orange,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BlocProvider(
                                                      create: (context) => SignInBloc(
                                                          userRepository: context
                                                              .read<
                                                                  AuthenticationBloc>()
                                                              .userRepository),
                                                      child: ResetScreen(
                                                        email: emailController,
                                                      ),
                                                    )));
                                      },
                                    )),
                                !signInRequired
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: TextButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                context.read<SignInBloc>().add(
                                                    SignInRequired(
                                                        emailController.text,
                                                        passwordController
                                                            .text));
                                              }
                                            },
                                            style: TextButton.styleFrom(
                                                elevation: 3.0,
                                                backgroundColor:
                                                    orange,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60))),
                                            child:  Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 25, vertical: 5),
                                              child: Text(
                                                'Sign In',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.k2d(
                                                    fontSize: 18, fontWeight: FontWeight.w800),
                                              ),
                                            )),
                                      )
                                    : const CircularProgressIndicator(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an Account:",
                                      style: TextStyle(
                                          decorationColor: HexColor("008EFF"),
                                          color: orange,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
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
                                        padding: EdgeInsets.all(0),
                                      ),
                                      child: Text(
                                        "SignUp",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: HexColor("008EFF"),
                                            color: orange,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
