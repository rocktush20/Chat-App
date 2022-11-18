// ignore_for_file: file_names

import 'package:flutter/material.dart';


const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 17, 186, 220) , width: 2),
  ),

  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 17, 186, 220) , width: 2),
  ),
  
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 17, 186, 220) , width: 2),
  ),
);

void nextScreen(context , page){
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context,page)
{
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}

void showbar(context,color,message)
{
  ScaffoldMessenger.of(context).showSnackBar(SnackBar (
    content: Text(message,
    style : const TextStyle(fontSize: 14)),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(label: "Ok",onPressed: (){},textColor: Colors.white,)));
}