// ignore_for_file: file_names, non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

  static String userLoggedInKey = "USERLOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  // saving the data to sf

  static Future<bool> saveUserName(String username) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, username);
  }

  static Future<bool> saveUserEmail(String userEmail) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  // get the data from sf

  static Future<bool?> userLoggedInStatus() async
  {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getuserName() async
  {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getuserEmail() async
  {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

}