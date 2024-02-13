import 'package:final_tasks_app/Style/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showSnackBarBasic(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
void showSnackBar(BuildContext context , String message) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(Icons.error_outline),
        ),
        Text(message,maxLines: 2,style: GoogleFonts.k2d(
            color: dark,
            fontSize: 14, fontWeight: FontWeight.bold),),
      ],
    ),
    showCloseIcon: true,
    closeIconColor: dark,
    backgroundColor: yellow,
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSnackBar2(BuildContext context , String message) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(Icons.error_outline),
        ),
        Text(message,maxLines: 2,style: GoogleFonts.k2d(
            color: dark,
            fontSize: 14, fontWeight: FontWeight.bold),),
      ],
    ),
    showCloseIcon: true,
    closeIconColor: dark,
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}