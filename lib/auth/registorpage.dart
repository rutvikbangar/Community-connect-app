import 'package:community/auth/loginpage.dart';
import 'package:community/pages/usermasterpage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../helper/helperfunction.dart';
import '../service/authservice.dart';
import '../widgets/Constants.dart';
import '../widgets/widgets.dart';

class RegistorPage extends StatefulWidget {
  const RegistorPage({super.key});

  @override
  State<RegistorPage> createState() => _RegistorPageState();
}

class _RegistorPageState extends State<RegistorPage> {
  @override
  bool _passtap1 = false;
  final formkey = GlobalKey<FormState>();
  String email = "";
  String fullname = "";
  String password = "";
  bool _isloading = false;
  Authservice authservice = Authservice();
  @override
  void togglepass (){
    setState(() {
      _passtap1 = !_passtap1;
    });

  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().primaryColor,
      appBar: AppBar(
        backgroundColor: Color(0xff080808),
        title: Text("Register",style: TextStyle(color: Color(0xfff2f3f4)),),
        centerTitle: true,
      ),
      body: _isloading ? Center(child: CircularProgressIndicator(
          color: Constants().textcolor,
      ),) :
      SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(children: [
            Image.asset("assets/images/register.jpg"),
            Container(
                margin: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: Text("Full Name",style: TextStyle(color: Constants().textcolor,fontWeight: FontWeight.bold),)),

            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 10,right: 10,top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xfff2f3f4),
              ),

              child: TextFormField(

                decoration: textInputDecoration.copyWith(
                    prefixIcon: Icon(Icons.person,color: Constants().primaryColor,),
                    hintText: "Enter Your Name"),
                onChanged: (val){
                  setState(() {
                    fullname = val;
                  });
                },

                validator: (val){
                  if(val==null){
                    return "Name Cannot be empty";
                  }
                  else{
                    return null;
                  }
                },
              ),
            ),
            SizedBox(height: 10),

            Container(
                margin: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: Text("Email Address",style: TextStyle(color: Constants().textcolor,fontWeight: FontWeight.bold),)),


            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 10,right: 10,top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xfff2f3f4),
              ),

              child: TextFormField(

                decoration: textInputDecoration.copyWith(
                    prefixIcon: Icon(Icons.email,color: Constants().primaryColor,),
                    hintText: "Enter Your Email"),
                onChanged: (val){
                  setState(() {
                    email = val;
                  });
                },
                validator: (val){
                  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!)
                      ? null : "Please Enter a valid Email";
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
                margin: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(

                ),
                child: Text("Password",style: TextStyle(color: Constants().textcolor,fontWeight: FontWeight.bold),)),

            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 10,right: 10,top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xfff2f3f4),
              ),

              child: TextFormField(
                obscureText: _passtap1,
                decoration: textInputDecoration.copyWith(
                    prefixIcon: Icon(Icons.lock,color: Constants().primaryColor,),
                    suffixIcon:IconButton(icon: Icon(
                        _passtap1?
                        Icons.visibility : Icons.visibility_off

                    ),onPressed: (){
                      togglepass();
                    },),
                    hintText: "Enter Your Password"),
                onChanged: (val){
                  setState(() {
                    password = val;
                  });
                },
                validator: (val){
                  if(val!.length<6){
                    return "Password must be atleast 6 character";
                  }
                  else{
                    return null;
                  }
                },
              ),
            ),
            SizedBox(height: 25,),
            SizedBox(
              height: 60,
              width: 350,
              child: ElevatedButton(onPressed: (){
                register();

              },

                child: Text("Register",style: TextStyle(color: Constants().textcolor,fontWeight: FontWeight.bold,fontSize: 17),),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Constants().greycol,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),


              ),
            ),
            SizedBox(height: 20,),
            Text.rich(
                TextSpan(
                    text:  "Already have an account? ",style: TextStyle(color: Constants().textcolor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16

                ),
                    children:<TextSpan>[
                      TextSpan(
                          text: " Sign in here!", style: TextStyle(
                          color: Constants().greycol,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: TextDecoration.underline

                      ), recognizer: TapGestureRecognizer()..onTap=(){
                        nextScreen(context, LoginPage());
                      }
                      )

                    ]


                )


            ),

          ],),
        ),
      ),
    );
  }
  register() async{
    if(formkey.currentState!.validate()){
      setState(() {
        _isloading = true;
      });
      await authservice.registerUserWithEmailandPassword(fullname, email, password).then((value) async{
        if(value == true){
          //saving the shared preference state
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSF(email);
          await HelperFunction.saveUserNameSF(fullname);
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
