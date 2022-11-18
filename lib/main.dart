// ignore_for_file: unused_import
import 'package:chat_app/HelperFunctions.dart';
import 'package:chat_app/LoginPage.dart';
import 'package:chat_app/Shared/InitializationVariables.dart';
import 'package:chat_app/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main(List<String> args) async{
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb)
  {
    // run the initilization for web
    await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: InitializeVar.apiKey,
    appId: InitializeVar.appId,
    messagingSenderId: InitializeVar.messagingSenderId,
    projectId: InitializeVar.projectId));
  }
  else
  {
    // run the initilization for app
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async
  {
    await HelperFunctions.userLoggedInStatus().then((value) {
      if(value != null)
      {
        setState((){
          isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isSignedIn ? const HomePage() : const LoginPage(),
    );
  }
}
