import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/auth/entrypage.dart';
import 'package:community/auth/loginpage.dart';
import 'package:community/pages/addevent.dart';
import 'package:community/pages/chat/joinedevent.dart';
import 'package:community/pages/eventdetail.dart';
import 'package:community/pages/search.dart';
import 'package:community/pages/searchlocation.dart';
import 'package:community/pages/setting.dart';
import 'package:community/service/databaseservice.dart';
import 'package:community/service/notificationservice.dart';
import 'package:community/widgets/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:like_button/like_button.dart';

import '../helper/helperfunction.dart';
import '../service/authservice.dart';
import '../widgets/widgets.dart';

class UserMasterPage extends StatefulWidget {
  const UserMasterPage({super.key});

  @override
  State<UserMasterPage> createState() => _UserMasterPageState();
}

class _UserMasterPageState extends State<UserMasterPage> {

  String userName = "";
  String email = "";
  Stream? event;
  Authservice authservice = Authservice();
  NotificationService notificationService = NotificationService();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
    getontheload();
    NotificationService().requestNotificationPermission();
    notificationService.isTokenRefresh();
    notificationService.getDeviceToken().then((value){
      print("Device token");
      print(value);
    });



  }

  //string manipulation
  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1
    );
  }

  gettingUserData() async {
    await HelperFunction.getUserEmailFromSF().then((value) =>
    {
      setState(() {
        email = value!;
      })
    });
    await HelperFunction.getUserNameFromSF().then((value) =>
    {
      setState(() {
        userName = value!;
      })
    });
  }
  getontheload() async{
    event = await DatabaseService().gettotalevent();
    setState(() {
      
    });
    
  }
  Widget allEventDetails() {

    return StreamBuilder(stream: event,
        builder: (context,AsyncSnapshot snapshot){
      return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context,index){
        DocumentSnapshot ds = snapshot.data.docs[index];
        Widget? eventImage = conditional(ds["type"]);
        return GestureDetector(
          onTap: (){
            nextScreen(context, DetailEventPage(
                title: ds["title"],
                description: ds["description"],
                type: ds["type"],
                time: ds["time"],
                price: ds["price"],
                location: ds["location"],
                admin: getName(ds["admin"]),
              eventid: ds["eventid"],
              number: ds["number"],

            ));
          },
          child: Container(

            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(left: 10,right: 10,bottom: 15),
            width: MediaQuery.of(context).size.width,
            height: 330,

            decoration: BoxDecoration(
                color: Constants().darkgrey,borderRadius: BorderRadius.circular(20)
            ),
            child:  SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children
                      : [
                        ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(22) ,bottomRight: Radius.circular(22)),
                          child: eventImage ??
                            Container(),
                        ),
                    SizedBox(height: 4,),
                    Text("${ds["title"]}",style: TextStyle(color: Constants().textcolor,fontWeight: FontWeight.bold,fontSize: 23),),
                    SizedBox(height: 4,),
                    Text("Type : ${ds["type"]}",style: TextStyle(color: Constants().textcolor,fontWeight: FontWeight.bold,fontSize: 15),),
                    Text("Organizer : ${getName(ds["admin"])}",style: TextStyle(color: Constants().textcolor,fontWeight: FontWeight.bold,fontSize: 15),),
                    LikeButton(likeCount: 0,size: 20,mainAxisAlignment: MainAxisAlignment.start,
                      likeBuilder: (bool like){
                      return Icon(Icons.thumb_up_alt_sharp,color:like? Colors.red : Colors.white,size: 20,);

                      },),



                  ],),
            ),

          ),
        );

      })
          : Container(
        child: Center(
          child: Text("No events listed",style: TextStyle(color: Constants().textcolor,fontWeight: FontWeight.bold,fontSize: 22),),
        ),
      );
        }


    );}



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Constants().primaryColor,

    body:SafeArea(
      child: Column(
        children: [
          Container(
      
            child:
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("Events near you",style: TextStyle(color: Constants().textcolor,
                          fontSize: 25,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(width: 30,),
                    Container(
                      //padding: EdgeInsets.all(10),

                        margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xfff2f3f4),
                        ),

                        child: IconButton(onPressed: (){
                          nextScreen(context, SearchLocationPage());
                        },icon: Icon(Icons.location_searching),)
                    ),
                    Container(
                      //padding: EdgeInsets.all(10),
                      
                      margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xfff2f3f4),
                      ),

                      child: IconButton(onPressed: (){
                        nextScreen(context, SearchPage());
                      },icon: Icon(Icons.search),)
                    ),
                  ],
                ),
          ),
          SizedBox(height: 20,),
          Expanded(child: allEventDetails()),

          

          


      
      
        ],
      ),
    ),
      bottomSheet: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Constants().darkgrey,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(17),topRight: Radius.circular(17))
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: (){
              //current event
              nextScreen(context, JoinedEventMain());

            }, icon: Icon(Icons.event,color: Color(0xffb7b8b9),)),
            IconButton(onPressed: (){
              //add event
              nextScreen(context, AddEventPage(userName: userName));
            }, icon: Icon(Icons.add_box_rounded,color: Color(0xffb7b8b9),)),
            IconButton(onPressed: (){
              showDialog(context: context,
                  builder: (context) {
                    return
                    AlertDialog(
                      backgroundColor: Constants().darkgrey,
                        title: Text("Logout",style: TextStyle(color: Constants().textcolor),),
                        content: Text("Are you sure you want to logout",style: TextStyle(color: Constants().textcolor)),
                        actions: [
                          IconButton(onPressed: () {
                            Navigator.pop(context);
                          },
                              icon: Icon(Icons.cancel, color: Colors.red)
                          ),
                          IconButton(onPressed: () async {
                            await authservice.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => EntryPage()),
                                    (route) => false);


                          },
                              icon: Icon(Icons.done, color: Colors.green,)
                          ),
                        ],
                      );

                  });



            }, icon: Icon(Icons.logout,color: Color(0xffb7b8b9),)),
            
          ],
        ),
      ),

    );


  }

  Widget? conditional (String index){
    switch(index) {
      case "concert" :
        return Image.asset("assets/images/concert1.jpg") ;
      case "conferences" :
        return Image.asset("assets/images/conference1.jpg");
      case "workshop" :
        return Image.asset("assets/images/workshop.png");
      case "sporting event" :
        return Image.asset("assets/images/sports.jpg");
      case "trade show" :
        return Image.asset("assets/images/Trade1.png");
    }
  }









}



//
// Center(child: ElevatedButton(onPressed: () async {
// await authservice.signOut();
// Navigator.of(context).pushAndRemoveUntil(
// MaterialPageRoute(
// builder: (context) => EntryPage()),
// (route) => false);
// }, child: Text("Signout")),)



// TextFormField(
//
// decoration: textInputDecoration.copyWith(
// prefixIcon: Icon(Icons.search,color: Constants().primaryColor,),
// suffixIcon:IconButton(icon: Icon(
// Icons.notifications
// ),onPressed: (){
// //search button
// NotificationService().showNotification(title: "yes",body: "got");
// },),
// hintText: "Search"),
// ),