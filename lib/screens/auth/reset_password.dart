import 'package:final_tasks_app/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetScreen extends StatelessWidget {
  const ResetScreen({super.key, required this.email});
  final TextEditingController email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: 5,
                    width: 50,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reset Password',
                        style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Insert your E-mail below \nWe gonna send you a link to reset your password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Row(
                          children: [
                            Icon(
                              Icons.alternate_email,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              height: 50,
                              width: 250,
                              child: TextField(
                                controller: email,
                                decoration: const InputDecoration(
                                    hintText: 'E-mail ID',
                                    focusedBorder: UnderlineInputBorder(
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
                        color: Colors.amber,
                        onPressed: () {
                          context
                              .read<SignInBloc>()
                              .add(ResetPasswordEvent(email.text));
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: const Text('E-mail sended'),
                              content: const Text(
                                  'An E-mail with your password recovery link was send to E-mail provided'),
                              actions: [
                                CupertinoDialogAction(
                                    child: const Text('Ok'),
                                    onPressed: () =>  Navigator.pop(context))
                              ],
                            ),
                          );
                        },
                        child: const Text('Send'),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
