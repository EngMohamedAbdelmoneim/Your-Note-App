import 'package:final_tasks_app/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Style/colors.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key, required this.email});
  final TextEditingController email;

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 25),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          'Reset Password',
                          style: GoogleFonts.k2d(
                              color: dark,
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Insert your E-mail below \nWe gonna send you a link to reset your password',
                          style: GoogleFonts.k2d(
                            color: dark,
                            fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Row(
                            children: [
                              Icon(
                                Icons.alternate_email,
                                color:dark.withOpacity(0.6),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              SizedBox(
                                height: 50,
                                width: 250,
                                child: TextField(
                                  controller: widget.email,

                                  decoration:  InputDecoration(
                                      errorText: _validate ? "Value Can't Be Empty" : null,
                                      hintText: 'E-mail ID',
                                      hintStyle:  GoogleFonts.k2d(
                                      color: dark.withOpacity(0.6),
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.amber))),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 50,
                      width: 200,
                      child: BlocProvider(
                        create: (context) => context.read<SignInBloc>(),
                        child: MaterialButton(
                          color: orange,
                          onPressed: () {
                            if(widget.email.text.isEmpty){
                              setState(() {
                                _validate = widget.email.text.isEmpty;
                              });
                            }
                            else {
                              setState(() {
                                _validate = false;
                              });
                              context
                                  .read<SignInBloc>()
                                  .add(ResetPasswordEvent(widget.email.text));
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    CupertinoAlertDialog(
                                      title: Text(
                                        'E-mail sent', style: GoogleFonts.k2d(
                                          color: dark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),),
                                      content: Text(
                                        'An E-mail with your password recovery link was send to E-mail provided',
                                        style: GoogleFonts.k2d(
                                            color: dark,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),),
                                      actions: [
                                        CupertinoDialogAction(
                                            child: Text(
                                              'Ok', style: GoogleFonts.k2d(
                                                color: dark,
                                                fontWeight: FontWeight.bold),),
                                            onPressed: () =>
                                                Navigator.pop(context))
                                      ],
                                    ),
                              );
                            }},
                          child:  Text('Send',style: GoogleFonts.k2d(
                              color: dark,
                              fontSize: 14, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
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
