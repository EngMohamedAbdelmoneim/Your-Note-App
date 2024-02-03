import 'package:final_tasks_app/screens/auth/sign_in_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter/material.dart';

import '../../Style/colors.dart';
import '../../app_view.dart';
import '../../blocs/authentication_bloc/authentication_bloc.dart';
import '../../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../blocs/sign_up_bloc/sign_up_bloc.dart';
import '../home/home_screen.dart';
import 'components/my_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = Icons.visibility_outlined;
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                    builder: ( context) =>
                        const MyAppView()),
                    (Route<dynamic> route) => false
            );
          });
          // Navigator.pop(context);
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          return;
        }
      },
      child: Scaffold(
        body: Center(
          child: Stack(
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
                    child: Center(
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
                                    GradientText("Create Account",style: GoogleFonts.k2d(
                                        fontSize: 36, fontWeight: FontWeight.bold),
                                      gradient: LinearGradient(colors: [
                                        lightPurple,
                                        purple,
                                      ]),
                                    ),

                                  ],),
                              ],),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.05,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.87,
                            height: 55,
                            child: MyTextField(
                                controller: nameController,
                                hintText: 'Name',
                                obscureText: false,
                                keyboardType: TextInputType.name,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  } else if (val.length > 30) {
                                    return 'Name too long';
                                  }
                                  return null;
                                }),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 55,
                            width: MediaQuery.of(context).size.width *  0.87,
                            child: MyTextField(
                                controller: emailController,
                                hintText: 'Email',
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,

                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  } else if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                      .hasMatch(val)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                }),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.87,
                            height: 55,
                            child: MyTextField(
                                controller: passwordController,
                                hintText: 'Password',
                                obscureText: obscurePassword,
                                keyboardType: TextInputType.visiblePassword,

                                onChanged: (val) {
                                  if (val!.contains(RegExp(r'[A-Z]'))) {
                                    setState(() {
                                      containsUpperCase = true;
                                    });
                                  } else {
                                    setState(() {
                                      containsUpperCase = false;
                                    });
                                  }
                                  if (val.contains(RegExp(r'[a-z]'))) {
                                    setState(() {
                                      containsLowerCase = true;
                                    });
                                  } else {
                                    setState(() {
                                      containsLowerCase = false;
                                    });
                                  }
                                  if (val.contains(RegExp(r'[0-9]'))) {
                                    setState(() {
                                      containsNumber = true;
                                    });
                                  } else {
                                    setState(() {
                                      containsNumber = false;
                                    });
                                  }
                                  if (val.contains(RegExp(
                                      r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
                                    setState(() {
                                      containsSpecialChar = true;
                                    });
                                  } else {
                                    setState(() {
                                      containsSpecialChar = false;
                                    });
                                  }
                                  if (val.length >= 8) {
                                    setState(() {
                                      contains8Length = true;
                                    });
                                  } else {
                                    setState(() {
                                      contains8Length = false;
                                    });
                                  }
                                  return null;
                                },
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                      if (obscurePassword) {
                                        iconPassword = Icons.visibility_outlined;
                                      } else {
                                        iconPassword =
                                            Icons.visibility_off_outlined;
                                      }
                                    });
                                  },
                                  icon: Icon(iconPassword,color: lightPurple,),
                                ),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  } else if (!RegExp(
                                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                                      .hasMatch(val)) {
                                    return 'Please enter a valid password';
                                  }
                                  return null;
                                }),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.87,
                            height: 55,
                            child: MyTextField(
                                controller: passwordConfirmController,
                                hintText: 'Re-Enter Password',
                                obscureText: obscurePassword,
                                keyboardType: TextInputType.visiblePassword,

                                onChanged: (val) {
                                  if (val!.contains(RegExp(r'[A-Z]'))) {
                                    setState(() {
                                      containsUpperCase = true;
                                    });
                                  }
                                  return null;
                                },
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                      if (obscurePassword) {
                                        iconPassword = Icons.visibility_outlined;
                                      } else {
                                        iconPassword =
                                            Icons.visibility_off_outlined;
                                      }
                                    });
                                  },
                                  icon: Icon(iconPassword,color: lightPurple),),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  } else if (val != passwordController.text) {
                                    return 'Please enter a same password';
                                  }
                                  return null;
                                }),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    containsUpperCase ? "✔  1 uppercase" :"✘  1 uppercase",
                                    style: TextStyle(
                                        color: containsUpperCase
                                            ? Colors.green
                                            : lightPurple),
                                  ),
                                  Text(
                                    containsLowerCase ? "✔  1 lowercase" :"✘  1 lowercase",
                                    style: TextStyle(
                                        color: containsLowerCase
                                            ? Colors.green
                                            :  lightPurple),
                                  ),
                                  Text(
                                    containsNumber
                                        ? "✔  1 number":"✘  1 number",
                                    style: TextStyle(
                                        color: containsNumber
                                            ? Colors.green
                                            :  lightPurple),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    containsSpecialChar
                                        ? "✔  1 special character" : "✘  1 special character",
                                    style: TextStyle(
                                        color: containsSpecialChar
                                            ? Colors.green
                                            :  lightPurple),
                                  ),
                                  Text(
                                    contains8Length ? "✔  8 minimum character" : "✘  8 minimum character" ,
                                    style: TextStyle(
                                        color: contains8Length
                                            ? Colors.green
                                            :  lightPurple),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          !signUpRequired
                              ? SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          MyUser myUser = MyUser.empty;
                                          myUser = myUser.copyWith(
                                            email: emailController.text,
                                            name: nameController.text,
                                          );
                                          setState(() {
                                            context.read<SignUpBloc>().add(
                                                SignUpRequired(myUser,
                                                    passwordController.text));
                                          });
                                        }
                                      },
                                      style: TextButton.styleFrom(

                                          elevation: 3.0,
                                          backgroundColor: lightPurple,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60))),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 5),
                                        child: Text(
                                          'Sign Up',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )),
                                )
                              : const CircularProgressIndicator(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an Account:",
                                style: TextStyle(

                                    decorationColor: HexColor("008EFF"),
                                    color: lightPurple,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              TextButton(

                                onPressed: () {
                                  Navigator.pushReplacement(
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
                                style: TextButton.styleFrom(padding: EdgeInsets.all(0),
                                ),
                                child: Text(
                                  "SignIn",
                                  style: TextStyle(
                                      decoration:
                                      TextDecoration.underline,
                                      decorationColor: HexColor("008EFF"),
                                      color: lightPurple,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

