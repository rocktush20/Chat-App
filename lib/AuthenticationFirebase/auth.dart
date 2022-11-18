// ignore_for_file: empty_catches, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';

import '../HelperFunctions.dart';
import 'Database.dart';

class Auth{
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future logInUser(String email, String password) async
  {
    try{
      User user = (await auth.signInWithEmailAndPassword(email: email, password: password))
      .user!;

      if(user != null)
      {
        return true;
      }
    }on FirebaseAuthException catch(e)
    {
      return e.message;
    }
  }

  Future registerUser(String fullname, String email, String password) async
  {
    try{
      User user = (await auth.createUserWithEmailAndPassword(email: email, password: password))
      .user!;

      if(user != null)
      {
        await Dbs(uid:user.uid).updateUserData(fullname,email);
        return true;
      }
    }on FirebaseAuthException catch(e)
    {
      return e.message;
    }
  }

  Future signOut() async{
    try{
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmail("");
      await HelperFunctions.saveUserName("");
      await auth.signOut();
    }
    catch(e)
    {
      return null;
    }
  }
}