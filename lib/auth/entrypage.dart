import 'package:community/admin/adminpage.dart';
import 'package:community/admin/checker.dart';
import 'package:community/auth/loginpage.dart';
import 'package:community/widgets/Constants.dart';
import 'package:community/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().primaryColor,
      appBar: AppBar(
        backgroundColor: Constants().primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/back.jpg"))
        ),
        child: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
        
             children: [
        
             SizedBox(
               height: 60,
               width: 350,
               child: ElevatedButton(onPressed: (){
                 nextScreen(context, LoginPage());
               },
        
                 child: Text("Login as User",style: TextStyle(color: Constants().textcolor,fontWeight: FontWeight.bold,fontSize: 17),),
                 style: ElevatedButton.styleFrom(
                     backgroundColor: Constants().darkgrey,
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10)
                     )
                 ),
        
        
               ),
             ),
             SizedBox(height: 50,),
             SizedBox(
               height: 60,
               width: 350,
               child: ElevatedButton(onPressed: (){nextScreen(context, CheckerPage());},
        
                 child: Text("Login as Admin",style: TextStyle(color: Constants().textcolor,fontWeight: FontWeight.bold,fontSize: 17),),
                 style: ElevatedButton.styleFrom(
                     backgroundColor: Constants().darkgrey,
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10)
                     )
                 ),
        
               ),
             ),
        
          ],),
        ),
      )


    );
  }
}
