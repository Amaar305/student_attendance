import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance/app/app.dart';
import 'package:student_attendance/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  initDependencies();

  runApp(const App());
}
