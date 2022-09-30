import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter_phonecheck/helpers/supabase.dart';
import 'package:tru_sdk_flutter/tru_sdk_flutter.dart';
import 'package:supabase_flutter_phonecheck/models.dart';
import 'package:http/http.dart' as http;

<<<<<<< HEAD
final String baseURL = '{YOUR_NGROK_URL}';
=======
final String baseURL = '<YOUR_LOCALTUNNEL_URL>';
>>>>>>> main

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

<<<<<<< HEAD
=======
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

>>>>>>> main
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

<<<<<<< HEAD
  Future<PhoneCheckResult> exchangeCode(
      String checkID, String code, String? referenceID) async {
    var body = jsonEncode(<String, String>{
      'code': code,
      'check_id': checkID,
      'reference_id': (referenceID != null) ? referenceID : ""
    });

    final response = await http.post(
      Uri.parse('$baseURL/v0.2/phone-check/exchange-code'),
      body: body,
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8',
      },
    );
    print("response request ${response.request}");
    if (response.statusCode == 200) {
      PhoneCheckResult exchangeCheckRes =
          PhoneCheckResult.fromJson(jsonDecode(response.body));
      print("Exchange Check Result $exchangeCheckRes");
      if (exchangeCheckRes.match) {
        print("✅ successful PhoneCheck match");
      } else {
        print("❌ failed PhoneCheck match");
      }
      return exchangeCheckRes;
    } else {
      throw Exception('Failed to exchange Code');
    }
  }

=======
>>>>>>> main
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });

                      TruSdkFlutter sdk = TruSdkFlutter();

                      Map<Object?, Object?> reach = await sdk.openWithDataCellular(
                          "https://eu.api.tru.id/public/coverage/v0.1/device_ip",
                          false);

<<<<<<< HEAD
                      print("-------------REACHABILITY RESULT --------------");
                      print("isReachable = $reach");
                      bool isPhoneCheckSupported = true;

                      if (reach.containsKey("http_status") &&
                          reach["http_status"] != 200) {
                        if (reach["http_status"] == 400 ||
                            reach["http_status"] == 412) {
                          setState(() {
                            loading = false;
                          });

                          return errorHandler(context, "Something Went Wrong.",
                              "Mobile Operator not supported, or not a Mobile IP.");
                        }
                      } else if (reach.containsKey("http_status") ||
                          reach["http_status"] == 200) {
                        Map body =
                            reach["response_body"] as Map<dynamic, dynamic>;
                        Coverage coverage = Coverage.fromJson(body);

                        for (var product in coverage.products!) {
                          if (product.name == "Phone Check") {
=======
                      print("-------------REACHABILITTY RESULT --------------");
                      print(reachabilityInfo);

                      ReachabilityDetails reachabilityDetails =
                          ReachabilityDetails.fromJson(
                              jsonDecode(reachabilityInfo!));

                      if (reachabilityDetails.error?.status == 400) {
                        setState(() {
                          loading = false;
                        });
                        return errorHandler(context, "Something Went Wrong.",
                            "Mobile Operator not supported.");
                      }
                      bool isPhoneCheckSupported = true;

                      if (reachabilityDetails.error?.status != 412) {
                        isPhoneCheckSupported = false;

                        for (var products in reachabilityDetails.products!) {
                          if (products.productName == "Phone Check") {
>>>>>>> main
                            isPhoneCheckSupported = true;
                          }
                        }
                      } else {
                        isPhoneCheckSupported = true;
                      }

                      if (isPhoneCheckSupported) {
<<<<<<< HEAD
                        final response = await http.post(
                            Uri.parse('$baseURL/v0.2/phone-check'),
                            body: {"phone_number": phoneNumber});

                        if (response.statusCode != 200) {
=======
                        final PhoneCheck? phoneCheckResponse =
                            await createPhoneCheck(phoneNumber);

                        if (phoneCheckResponse == null) {
>>>>>>> main
                          setState(() {
                            loading = false;
                          });

                          return errorHandler(context, 'Something went wrong.',
                              'Unable to create phone check');
                        }
<<<<<<< HEAD

                        PhoneCheck checkDetails =
                            PhoneCheck.fromJson(jsonDecode(response.body));
=======

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
>>>>>>> main

                        Map result = await sdk.openWithDataCellular(
                            checkDetails.url, false);
                        print("openWithDataCellular Results -> $result");

                        if (result.containsKey("error")) {
                          setState(() {
                            loading = false;
                          });
<<<<<<< HEAD

                          errorHandler(context, "Something went wrong.",
                              "Failed to open Check URL.");
                        }
=======

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

                            return errorHandler(context,
                                "Something went wrong.", result.error!.message);
                          }

                          if (result.data?.user != null) {
                            setState(() {
                              loading = false;
                            });
>>>>>>> main

                        if (result.containsKey("http_status") &&
                            result["http_status"] == 200) {
                          Map body =
                              result["response_body"] as Map<dynamic, dynamic>;
                          if (body["code"] != null) {
                            CheckSuccessBody successBody =
                                CheckSuccessBody.fromJson(body);

                            try {
                              PhoneCheckResult exchangeResult =
                                  await exchangeCode(
                                      successBody.checkId,
                                      successBody.code,
                                      successBody.referenceId);

                              if (exchangeResult.match) {
                                // proceed with Supabase Auth
                                GotrueSessionResponse result =
                                    await supabase.auth.signUp(email, password);

                                if (result.error != null) {
                                  setState(() {
                                    loading = false;
                                  });

                                  return errorHandler(
                                      context,
                                      "Something went wrong.",
                                      result.error!.message);
                                }

                                if (result.data?.user != null) {
                                  setState(() {
                                    loading = false;
                                  });

                                  return successHandler(context);
                                }
                              } else {
                                setState(() {
                                  loading = false;
                                });

                                return errorHandler(
                                    context,
                                    "Something went wrong.",
                                    "Unable to login. Please try again later");
                              }
                            } catch (error) {
                              setState(() {
                                loading = false;
                              });

                              return errorHandler(
                                  context,
                                  "Something went wrong.",
                                  "Unable to login. Please try again later");
                            }
                          }
<<<<<<< HEAD
=======
                        } else {
                          setState(() {
                            loading = false;
                          });

                          return errorHandler(
                              context,
                              'Registration Unsuccessful.',
                              'Please contact your network provider 🙁');
>>>>>>> main
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
      ),
    );
  }
}
