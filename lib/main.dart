import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_phonecheck/registration.dart';

Future<void> main() async {
  await dotenv.load();

  print("-------ENVIRONMENT VARIABLES ARE ----------");
  print(dotenv.env["SUPABASE_URL"]);
  print(dotenv.env["SUPABASE_PUBLIC_ANON"]);

  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"],
    anonKey: dotenv.env["SUPABASE_PUBLIC_ANON"],
  );

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
