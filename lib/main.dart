import 'package:dream_diary/app/app.dart';
import 'package:dream_diary/utility/env.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'db/firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting('tr_TR', null);
  Env.load();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

