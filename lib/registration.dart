import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:tru_sdk_flutter/tru_sdk_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter_phonecheck/models.dart';
import 'package:supabase_flutter_phonecheck/helpers/supabase.dart';

final String baseURL = 'https://witty-falcon-83.loca.lt';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

Future<PhoneCheck?> createPhoneCheck(String phoneNumber) async {
  final response = await http.post(Uri.parse('$baseURL/phone-check'),
      body: {"phone_number": phoneNumber});

  if (response.statusCode != 200) {
    return null;
  }
  final String data = response.body;
  return phoneCheckFromJSON(data);
}

Future<PhoneCheckResult?> getPhoneCheck(String checkId) async {
  final response =
      await http.get(Uri.parse('$baseURL/phone-check?check_id=$checkId'));

  if (response.statusCode != 200) {
    return null;
  }

  final String data = response.body;
  return phoneCheckResultFromJSON(data);
}

Future<void> errorHandler(BuildContext context, String title, String content) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
      });
}

Future<void> successHandler(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Successful.'),
          content: const Text('✅'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
      });
}

class _RegistrationState extends State<Registration> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Container(
                padding: const EdgeInsets.only(bottom: 45.0),
                margin: const EdgeInsets.only(top: 40),
                child: Image.asset(
                  'assets/images/tru-id-logo.png',
                  height: 100,
                )),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'Register.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                )),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email.',
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your password.',
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextButton(
                    onPressed: () async {
                    
                    },
                    child: const Text('Register')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
