import 'package:community/admin/adminpage.dart';
import 'package:community/widgets/Constants.dart';
import 'package:community/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'admineventpage.dart';

class CheckerPage extends StatefulWidget {
  const CheckerPage({super.key});

  @override
  State<CheckerPage> createState() => _CheckerPageState();
}

class _CheckerPageState extends State<CheckerPage> {
  String check = "";
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().primaryColor,
      body:
      Form(
        key: formkey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Container(
                    padding: EdgeInsets.all(10),
                   margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                     color: Color(0xfff2f3f4),
                    ),
              child :
              TextFormField(

                decoration: textInputDecoration.copyWith(
                    prefixIcon: Icon(Icons.lock,color: Constants().primaryColor,),

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
                    check = val;
                  });
                },
              ),),
              SizedBox(height: 20,),
              SizedBox(
                height: 60,
                width: 350,
                child: ElevatedButton(onPressed: (){
                 checker();
                },

                  child: Text("Validate",style: TextStyle(color: Constants().textcolor,fontWeight: FontWeight.bold,fontSize: 17),),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Constants().greycol,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),


                ),
              ),
            ],
          ),
        ),


        ),
      );
  }
  checker(){
    if(formkey.currentState!.validate()){
      if(check == "8530271"){
        nextScreenReplace(context, AdminPage());
        setState(() {

        });
      }else{
        return showSnackbar(context, Colors.red, "incorrect password");
      }


    }


  }
}
