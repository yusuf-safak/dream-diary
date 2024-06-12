import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  Color? buttonColor;
  CustomButton({
    required this.onTap,
    required this.text,
    this.buttonColor,
    super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3,vertical: 3),
        padding: EdgeInsets.symmetric(horizontal: 14,vertical: 8),
        decoration: BoxDecoration(
          color: buttonColor==null?Colors.black:buttonColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 2.0,
              color: Colors.black54,
              offset: Offset(1.5, 1.5,),
            )
          ]
        ),
        child: Text(text,style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade100
        ),),
      )
    );
  }
}
