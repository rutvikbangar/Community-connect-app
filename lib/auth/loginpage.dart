import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/auth/entrypage.dart';
import 'package:community/auth/registorpage.dart';
import 'package:community/pages/usermasterpage.dart';
import 'package:community/widgets/Constants.dart';
import 'package:community/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../helper/helperfunction.dart';
import '../service/authservice.dart';
import '../service/databaseservice.dart';


 class LoginPage extends StatefulWidget {
   const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
   @override
   bool _passtap = false;
   final formkey = GlobalKey<FormState>();
   bool _isloading = false;
   String email = "";
   String password = "";
   Authservice authservice = Authservice();
   @override
 void togglepass (){
     setState(() {
       _passtap = !_passtap;
     });

   }

   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Constants().primaryColor,
       appBar: AppBar(
         backgroundColor: Color(0xff080808),
         title: Text("Login",style: TextStyle(color: Color(0xfff2f3f4)),),
         centerTitle: true,
       ),
       body: _isloading? Center(child: CircularProgressIndicator(color: Constants().textcolor),)
           : SingleChildScrollView(
           child: Form(
             key: formkey,
             child: Column(
               children: [
                 Image.asset("assets/images/globe1.jpg"),

                  Container(
                    margin: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: Text("Email Address",style: TextStyle(color: Constants().textcolor,fontWeight: FontWeight.bold),)),


                 Container(
                   padding: EdgeInsets.all(10),
                   margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     color: Color(0xfff2f3f4),
                   ),

                   child: TextFormField(

                     decoration: textInputDecoration.copyWith(
                       prefixIcon: Icon(Icons.email,color: Constants().primaryColor,),
                      hintText: "Enter Your Email"),

                     validator: (val){
                       return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!)
                           ? null : "Please Enter a valid Email";
                     },
                     onChanged: (val){
                       setState(() {
                         email = val;
                       });
                     },
                   ),
                 ),
                 SizedBox(height: 25),
                 Container(
                   margin: EdgeInsets.only(left: 20),
                   alignment: Alignment.centerLeft,
                     decoration: BoxDecoration(

                     ),
                     child: Text("Password",style: TextStyle(color: Constants().textcolor,fontWeight: FontWeight.bold),)),

                 Container(
                   padding: EdgeInsets.all(10),
                   margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     color: Color(0xfff2f3f4),
                   ),

                   child: TextFormField(
                      obscureText: _passtap,
                     decoration: textInputDecoration.copyWith(
                         prefixIcon: Icon(Icons.lock,color: Constants().primaryColor,),
                         suffixIcon:IconButton(icon: Icon(
                             _passtap?
                             Icons.visibility : Icons.visibility_off

                         ),onPressed: (){
                            togglepass();
                           },),
                         hintText: "Enter Your Password"),


                     validator: (val){
                      if(val!.length<6){
                        return "Password must be atleast 6 character";
                      }
                      else{
                        return null;
                      }
                     },
                     onChanged: (val){
                       setState(() {
                         password = val;
                       });
                     },
                   ),
                 ),
                 SizedBox(height: 30,),
                 SizedBox(
                   height: 60,
                   width: 350,
                   child: ElevatedButton(onPressed: (){
                     login();
                   },

                       child: Text("Login",style: TextStyle(color: Constants().textcolor,fontWeight: FontWeight.bold,fontSize: 17),),
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Constants().greycol,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10)
                       )
                     ),


                   ),
                 ),
                 SizedBox(height: 30,),
                Text.rich(
                  TextSpan(
                    text:  "No Account? ",style: TextStyle(color: Constants().textcolor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16

                  ),
                    children:<TextSpan>[
                      TextSpan(
                      text: " Sign up here!", style: TextStyle(
                          color: Constants().greycol,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: TextDecoration.underline

                      ), recognizer: TapGestureRecognizer()..onTap=(){
                        nextScreen(context, RegistorPage());
                      }
                      )

                    ]


                  )


                ),
               ],
             ),
           ),

       ),
     );
   }
   login() async {
     if(formkey.currentState!.validate()){
       setState(() {
         _isloading = true;
       });
       await authservice.loginUserWithEmailandPassword(email, password).then((value) async{
         if(value == true){
           QuerySnapshot snapshot = await DatabaseService(uid:
           FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
           //saving the values in shared preferences
           await HelperFunction.saveUserLoggedInStatus(true);
           await HelperFunction.saveUserEmailSF(email);
           await HelperFunction.saveUserNameSF(snapshot.docs[0]['fullname']);
           nextScreenReplace(context, UserMasterPage());
         } else {
           showSnackbar(context, Colors.red, value);
           setState(() {
             _isloading = false;
           });

         }
       });
     }
   }
}
