import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:tru_sdk_flutter/tru_sdk_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter_phonecheck/models.dart';
import 'package:supabase_flutter_phonecheck/helpers/supabase.dart';

final String baseURL = '<YOUR_LOCAL_TUNNEL_URL>';

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
  String phoneNumber = '';
  String email = '';
  String password = '';
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.only(bottom: 45.0),
              margin: const EdgeInsets.only(top: 50),
              child: Image.asset(
                'assets/images/tru-id-logo.png',
              )),
          Container(
              width: double.infinity,
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (text) {
                  setState(() {
                    email = text;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email.',
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: TextField(
                keyboardType: TextInputType.text,
                obscureText: true,
                onChanged: (text) {
                  setState(() {
                    password = text;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your password.',
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: TextField(
                keyboardType: TextInputType.phone,
                onChanged: (text) {
                  setState(() {
                    phoneNumber = text;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your phone number.',
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: TextButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });

                    TruSdkFlutter sdk = TruSdkFlutter();

                    String? reachabilityInfo = await sdk.isReachable();

                    print("-------------REACHABILITTY RESULT --------------");
                    print(reachabilityInfo);
                    ReachabilityDetails reachabilityDetails =
                        json.decode(reachabilityInfo!);

                    if (reachabilityDetails.error?.status == 400) {
                      setState(() {
                        loading = false;
                      });
                      return errorHandler(context, "Something Went Wrong.",
                          "Mobile Operator not supported.");
                    }
                    bool isPhoneCheckSupported = false;

                    if (reachabilityDetails.error?.status != 412) {
                      isPhoneCheckSupported = false;

                      for (var products in reachabilityDetails.products!) {
                        if (products.productName == "Phone Check") {
                          isPhoneCheckSupported = true;
                        }
                      }
                    } else {
                      isPhoneCheckSupported = true;
                    }

                    if (isPhoneCheckSupported) {
                      final PhoneCheck? phoneCheckResponse =
                          await createPhoneCheck(phoneNumber!);
                      if (phoneCheckResponse == null) {
                        setState(() {
                          loading = false;
                        });
                        return errorHandler(context, 'Something went wrong.',
                            'Phone number not supported');
                      }
                      // open check URL

                      String? result =
                          await sdk.check(phoneCheckResponse.checkUrl);

                      if (result == null) {
                        setState(() {
                          loading = false;
                        });
                        return errorHandler(context, "Something went wrong.",
                            "Failed to open Check URL.");
                      }
                      final PhoneCheckResult? phoneCheckResult =
                          await getPhoneCheck(phoneCheckResponse.checkId);

                      if (phoneCheckResult == null) {
                        // return dialog
                        setState(() {
                          loading = false;
                        });
                        return errorHandler(context, 'Something Went Wrong.',
                            'Please contact support.');
                      }

                      if (phoneCheckResult.match) {
                        // proceed with Supabase Auth
                        GotrueSessionResponse result =
                            await supabase.auth.signUp(email, password);

                        if (result.error != null) {
                          setState(() {
                            loading = false;
                          });

                          return errorHandler(context, "Something went wrong.",
                              result.error!.message);
                        }
                        if (result.data?.user != null) {
                          setState(() {
                            loading = false;
                          });

                          return successHandler(context);
                        }

                        return successHandler(context);
                      } else {
                        setState(() {
                          loading = false;
                        });
                        return errorHandler(
                            context,
                            'Registration Unsuccessful.',
                            'Please contact your network provider 🙁');
                      }
                    } else {
                      GotrueSessionResponse result =
                          await supabase.auth.signUp(email, password);

                      if (result.error != null) {
                        setState(() {
                          loading = false;
                        });

                        return errorHandler(context, "Something went wrong.",
                            result.error!.message);
                      }

                      if (result.data?.user != null) {
                        setState(() {
                          loading = false;
                        });

                        return successHandler(context);
                      }
                    }
                  },
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text('Register')),
            ),
          )
        ],
      ),
    );
  }
}
