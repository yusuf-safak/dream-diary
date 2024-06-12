import 'package:dream_diary/app/bloc/app_bloc.dart';
import 'package:dream_diary/auth/auth_check.dart';
import 'package:dream_diary/db/firestore/bloc/firestore_bloc.dart';
import 'package:dream_diary/dream_comment/bloc/dream_comment_bloc.dart';
import 'package:dream_diary/login/bloc/login_bloc.dart';
import 'package:dream_diary/register/bloc/register_bloc.dart';
import 'package:dream_diary/utility/app_colors.dart';
import 'package:dream_diary/utility/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context)=>RegisterBloc(),
        ),
        BlocProvider(
          create: (context)=>LoginBloc(),
        ),
        BlocProvider(
          create: (context)=>AppBloc(),
        ),
        BlocProvider(
          create: (context)=>FirestoreBloc(),
        ),
        BlocProvider(
          create: (context)=>DreamCommentBloc(),
        ),
      ],
      child: Builder(
        builder: (context) {
          SizeConfig.init(context);
          return MaterialApp(
            title: 'Dream Diary',
            theme: ThemeData(
              scaffoldBackgroundColor: backgroundColor,
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Colors.black,
              ),

              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return Colors.white;
                    },
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.black;
                    },
                  ),
                  textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                        (Set<MaterialState> states) {
                      return TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      );
                    },
                  ),
                ),
              ),
              fontFamily: 'Quicksand',
              iconTheme: const IconThemeData(
                  color: Colors.black
              ),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home:AuthCheck(),
          );
        }
      ),
    );
  }
}