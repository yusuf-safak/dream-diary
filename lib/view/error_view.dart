import 'package:flutter/material.dart';
class ErrorView extends StatelessWidget {
  final String error;
  const ErrorView({
    required this.error,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 2),
        child: Text(error,style: TextStyle(
          fontSize: 14,
          color: Colors.red.shade700,
        ),),
      ),
    );
  }
}
