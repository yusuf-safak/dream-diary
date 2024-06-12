import 'package:flutter/material.dart';
import 'package:dream_diary/utility/app_colors.dart' as ac;
class CustomAppBar extends AppBar {
  final BuildContext context;
  CustomAppBar({required this.context});
  @override
  Widget? get leading => GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Icon(Icons.arrow_back_ios));

  Color? get backgroundColor => ac.backgroundColor;
}
