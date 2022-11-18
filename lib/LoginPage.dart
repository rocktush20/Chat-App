// ignore_for_file: file_names, prefer_const_constructors, avoid_print, non_constant_identifier_names, use_build_context_synchronously

import 'package:chat_app/AuthenticationFirebase/auth.dart';
import 'package:chat_app/Files/Properties.dart';
import 'package:chat_app/RegisterPage.dart';
import 'package:chat_app/Shared/InitializationVariables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'AuthenticationFirebase/Database.dart';
import 'HelperFunctions.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Auth auth = Auth();
  bool loading = false;
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              color: primaryColor,
            ),
          )
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: Form(
                key: formkey,
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Chat App",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "More Social More Fun",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Image.asset("assets/LoginPage.jpg"),
                      const SizedBox(
                        height: 100,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          prefixIcon: Icon(
                            Icons.email,
                            color: primaryColor,
                          ),
                          labelText: "Email",
                        ),
                        validator: (username) {
                          if (username!.length <= 10) {
                            return "Enter a valid Email";
                          }

                          String check = "@gmail.com";
                          int j = username.length - 1;
                          for (int i = check.length - 1; i >= 0; i--) {
                            if (username[j] != check[i]) {
                              return "Enter a valid Email";
                            }
                            j--;
                          }

                          return null;
                        },
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: primaryColor,
                          ),
                        ),
                        validator: (username) {
                          if (username!.length <= 6) {
                            return "Password length should be greater than 6 characters";
                          }

                          return null;
                        },
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: Text(
                            "Sign in",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            login();
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                                text: " Register here",
                                style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, RegisterPage());
                                  }),
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          );
  }

  login() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      await auth.logInUser(email, password).then((value) async {
        if (value == true) {
          QuerySnapshot snp =
              await Dbs(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);

          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmail(email);
          await HelperFunctions.saveUserName(snp.docs[0]['fullName']);
          nextScreen(context, const HomePage());
        } else {
          setState(() {
            showbar(context, Colors.red, value);
            setState(() {
              loading = false;
            });
          });
        }
      });
    }
  }
}
