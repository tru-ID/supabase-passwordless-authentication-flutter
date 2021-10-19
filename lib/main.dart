import 'package:flutter/material.dart';
import 'package:supabase_flutter/registration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Registration(),
    );
  }
}

