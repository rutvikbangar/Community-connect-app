import 'package:community/helper/helperfunction.dart';
import 'package:community/pages/usermasterpage.dart';
import 'package:community/widgets/Constants.dart';
import 'package:community/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../service/databaseservice.dart';

class DetailEventPage extends StatefulWidget {
  final String title;
  final String description;
  final String type;
  final String time;
  final String price;
  final String location;
  final String admin;
  final String eventid;
  final String number;

  

  const DetailEventPage({Key? key,
    required this.title,
    required this.description,
    required this.type,
  required this.time,
  required this.price,
  required this.location,
  required this.admin,
    required this.eventid,
    required this.number
  
  }) :super(key: key);

  @override
  State<DetailEventPage> createState() => _DetailEventPageState();
}

class _DetailEventPageState extends State<DetailEventPage> {
  User? user;
  bool isJoined =false;
  String userName = "";
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserIdandName();
  //  joinedOrNot(userName, widget.eventid, widget.title, widget.admin);
  }



  getCurrentUserIdandName() async {
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;

    joinedOrNot(userName,widget.eventid,widget.title,widget.title);
  }
  
  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1
    );
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants().primaryColor,
        appBar: AppBar(
          backgroundColor: Constants().primaryColor,
          title : Text(widget.title,style: TextStyle(color: Constants().textcolor,fontSize: 22,fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 25),
              Text("Description : ",style: TextStyle(color: Constants().textcolor,fontSize: 22,fontWeight: FontWeight.bold),),
              SizedBox(height: 5,),
              Text(widget.description,style: TextStyle(color: Constants().textcolor,fontSize: 17),),
              SizedBox(height: 15),
              Text("Location : ",style: TextStyle(color: Constants().textcolor,fontSize: 22,fontWeight: FontWeight.bold),),
              SizedBox(height: 5,),
              Text(widget.location,style: TextStyle(color: Constants().textcolor,fontSize: 17),),
              SizedBox(height: 15,),
              Text("Date & Time : ",style: TextStyle(color: Constants().textcolor,fontSize: 22,fontWeight: FontWeight.bold),),
              SizedBox(height: 5,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Date : ${getId(widget.time)}",style: TextStyle(color: Constants().textcolor,fontSize: 17),),
                    Text("Time : ${getName(widget.time)}",style: TextStyle(color: Constants().textcolor,fontSize: 17),),


              ] ),
              SizedBox(height: 5,),
              Text("Call Organizer  ",style: TextStyle(color: Constants().textcolor,fontSize: 22,fontWeight: FontWeight.bold),),
              SizedBox(height: 5,),
              ElevatedButton(style: ElevatedButton.styleFrom(
                backgroundColor: Constants().textcolor
              ),
                  onPressed: () async{
                    await FlutterPhoneDirectCaller.callNumber(widget.number);
                  },

                  child: Text(
                    "📞",))


            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Constants().darkgrey,
                borderRadius: BorderRadius.circular(15)
          ),
          padding: EdgeInsets.all(18),
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("₹${widget.price}",style: TextStyle(color: Constants().textcolor,fontSize: 35),),
              InkWell(
                onTap: () async{
                  await DatabaseService(uid: user!.uid).toggleGroupJoin(widget.eventid, userName, widget.title);
                  if(isJoined){
                    setState(() {
                      isJoined = !isJoined;
                    });
                  //  showSnackbar(context, Colors.green, "Event Joined Successfulley");
                    nextScreen(context, UserMasterPage());
                  }else{
                    setState(() {
                      isJoined = !isJoined;
                    //  showSnackbar(context, Colors.red, "Left the Event ${widget.title}");
                    });
                  }
                },
                child: isJoined? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      border: Border.all(color: Colors.white,width: 1)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Text("Joined",style: TextStyle(color: Colors.white),),
                )
                    :Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Constants().textcolor

                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Text("Join",style: TextStyle(color: Colors.black),),
                ),
              ),


              // SizedBox(
              //   height: 60,
              //   width: 100,
              //
              //   child: ElevatedButton(onPressed: () async
              //   {
              //
              //   },
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Constants().primaryColor,
              //
              //       ),
              //       child: Text("Join",style: TextStyle(color: Constants().textcolor,fontSize: 20),)),
              // )
            ],
          ),
        ),
      ),
    );
  }
  joinedOrNot(String userName,String eventid,String title,String admin) async{
    await DatabaseService(uid: user!.uid).isUserJoined(title, eventid, userName).then((value){
      setState(() {
        isJoined = value;
      });
    });

  }


}
