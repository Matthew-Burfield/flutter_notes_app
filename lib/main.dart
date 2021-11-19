import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes_app/injection.dart';
import 'package:flutter_notes_app/presentation/core/app_widget.dart';
import 'package:injectable/injectable.dart';

void main() async {
  configureDependencies(Environment.prod);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AppWidget());
}
