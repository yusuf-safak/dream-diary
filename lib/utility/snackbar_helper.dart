import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showSnackbar(BuildContext context, String message, {Color backgroundColor = Colors.red}) {
    final snackBar = SnackBar(
      content: Text(message,style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15
      ),),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
