import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
 hintText: '',
  fillColor: Color(0xfff2f3f4),
  border: InputBorder.none
);

void nextScreen(context, page){
  Navigator.push(context, MaterialPageRoute(builder: (context)=> page));

}
void nextScreenReplace(context, page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> page));

}

void showSnackbar(context, color, message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar
    (content: Text(message, style: TextStyle(fontSize: 14),),
      backgroundColor: color,duration: Duration(seconds: 2),
      action : SnackBarAction(label: "ok", onPressed:(){},)));
}
class routes{

  static String medicationRoute = "/medication";

}