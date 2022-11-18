// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:chat_app/AuthenticationFirebase/auth.dart';
import 'package:chat_app/HelperFunctions.dart';
import 'package:chat_app/LoginPage.dart';
import 'package:chat_app/home_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'Files/Properties.dart';
import 'Shared/InitializationVariables.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool loading = false;
  final formkey = GlobalKey<FormState>();
  String fullname = "";
  String email = "";
  String password = "";
  Auth auth = Auth();
  @override
  Widget build(BuildContext context) {
    return loading ? Center(
      child: CircularProgressIndicator(color: primaryColor),
    ) : Scaffold(
      body:  Padding(
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
                  "Create your account to chat and explore",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 50,
                ),
                Image.asset("assets/RegisterApp.png",),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    prefixIcon: Icon(
                      Icons.email,
                      color: primaryColor,
                    ),
                    labelText: "Full Name",
                  ),
                  validator: (username) {
                    if(username!.isEmpty)
                    {
                      return "Name can't be empty";
                    }

                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      fullname = val;
                    });
                  },
                ),
                SizedBox(height: 20,),
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
                    style: ElevatedButton.styleFrom(primary: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                    child: Text("Sign in",
                    style: TextStyle(color: Colors.white,fontSize: 16),),
                  onPressed: (){
                    register();
                  },
                  ),
                ),
                SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(color: Colors.black,fontSize: 14),
                    children: [
                      TextSpan(text: " Login here",
                      style: TextStyle(color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        nextScreenReplace(context, LoginPage());
                      }
                      ),
                    ],
                    ),
                ),
              ]),
        ),
      ),
    );
  }

  register() async{
    if(formkey.currentState!.validate())
    {
      setState(() {
        loading = true;
      });
      await auth.registerUser(fullname, email, password).then((value) async{
        if(value == true)
        {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmail(email);
          await HelperFunctions.saveUserName(fullname);
          nextScreenReplace(context, HomePage());
        }
        else
        {
          setState(() {
            showbar(context, Colors.red,value);
            setState(() {
              loading = false;
            });
          });
        }

      });
     
    }
  }
}