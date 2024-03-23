import 'dart:async';

import 'package:community/pages/usermasterpage.dart';
import 'package:community/service/databaseservice.dart';
import 'package:community/widgets/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class AddEventPage extends StatefulWidget {
final String userName;

const AddEventPage({Key? key,
  required this.userName,
}) :super(key: key);


  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
 // String title = "";
  final formkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Constants().primaryColor,
      appBar: AppBar(
        backgroundColor: Constants().primaryColor,
      title: Text("Hii ${widget.userName} 👋",style: TextStyle(color: Constants().textcolor),),
      ),
      body: Form(
          key: formkey,
          child: AddEventBody(userName: widget.userName)),

    );
  }
}

class AddEventBody extends StatefulWidget {
  final String userName;


  const AddEventBody({Key? key,
    required this.userName,
  }) :super(key: key);

  @override
  State<AddEventBody> createState() => _AddEventBodyState();
}

class _AddEventBodyState extends State<AddEventBody> {
  bool _isloading = false;
  final formkey = GlobalKey<FormState>();
  String title = "";
  String location = "";
  String description = "";
  String type = "";
  String price ="";
  //String time ="";
  String datetaker = "";
  String timetaker = "";
  String locationtype = "";
  String number = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formkey,
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 10,right: 10,top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xfff2f3f4),
              ),

              child: TextFormField(

                decoration: textInputDecoration.copyWith(
                    prefixIcon: Icon(Icons.title,color: Constants().primaryColor,),
                    hintText: "Enter event title"),
                onChanged: (val){
                  setState(() {
                    title = val;
                  });
                },

                validator: (val){
                  if(val== ""){
                    return "Title Cannot be empty";
                  }
                  else{
                    return null;
                  }
                },
              ),
            ),
            SizedBox(height: 13,),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 10,right: 10,top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xfff2f3f4),
              ),

              child: TextFormField(

                decoration: textInputDecoration.copyWith(
                    prefixIcon: Icon(Icons.location_on_rounded,color: Constants().primaryColor,),
                    hintText: "Enter event location"),
                onChanged: (val){
                  setState(() {
                    location = val;
                  });
                },

                validator: (val){
                  if(val==""){
                    return "location Cannot be empty";
                  }
                  else{
                    return null;
                  }
                },
              ),
            ),
            SizedBox(height: 13,),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 10,right: 10,top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xfff2f3f4),
              ),

              child: TextFormField(
                maxLines: 3,
                decoration: textInputDecoration.copyWith(

                    prefixIcon: Icon(Icons.description,size: 50,color: Constants().primaryColor,),
                    hintText: "Enter event description"),
                onChanged: (val){
                  setState(() {
                    description = val;
                  });
                },

                validator: (val){
                  if(val==""){
                    return "Description Cannot be empty";
                  }
                  else{
                    return null;
                  }
                },
              ),
            ),
            SizedBox(height: 13,),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 10,right: 10,top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xfff2f3f4),
              ),

              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: textInputDecoration.copyWith(
                    prefixIcon: Icon(Icons.currency_rupee,color: Constants().primaryColor,),
                    hintText: "Enter event price"),
                onChanged: (val){
                  setState(() {
                    price = val;
                  });
                },

                validator: (val){
                  if(val==""){
                    return "Cannot be null enter 0 for free";
                  }
                  else{
                    return null;
                  }
                },
              ),
            ),
            SizedBox(height: 13,),
            Container(child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(

                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: DropdownButton<String>(

                      hint: Text('Select Event Type'),
                      value: type.isNotEmpty ? type : null, // If type is not empty, set it as the current value
                      onChanged: (String? newValue) {
                        setState(() {
                          type = newValue ?? ''; // Assign the selected value to type
                        });
                      },
                      items: <String>['concert', 'conferences', 'workshop', 'sporting event', 'trade show']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                   // margin: EdgeInsets.only(right: 180),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: DropdownButton<String>(

                      hint: Text('Select locationtype'),
                      value: locationtype.isNotEmpty ? locationtype : null, // If type is not empty, set it as the current value
                      onChanged: (String? newValue) {
                        setState(() {
                          locationtype = newValue ?? ''; // Assign the selected value to type
                        });
                      },
                      items: <String>[
                        'South Mumbai',
                        'Central Mumbai',
                        'Western Suburbs',
                        'Eastern Suburbs',
                        'Harbour Suburb'
                      ]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),

              ],),
            ),),

            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 10,right: 10,top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xfff2f3f4),
              ),

              child: TextFormField(

                keyboardType: TextInputType.number,
                decoration: textInputDecoration.copyWith(
                    prefixIcon: Icon(Icons.call,color: Constants().primaryColor,),
                    hintText: "Enter phone number"),
                onChanged: (val){
                  setState(() {
                    number = val;
                  });
                },


              ),
            ),


            Container(
              padding: EdgeInsets.only(left: 5,right: 5),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Select Date : ",

                    style: TextStyle(color: Constants().textcolor,fontSize: 16,fontWeight: FontWeight.bold),),
                  ElevatedButton(onPressed: () async {
                    DateTime? datepicked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2025));
                    if(datepicked!=null){
                    setState(() {
                      datetaker = "${datepicked.day}-${datepicked.month}-${datepicked.year}".toString();
                    });
                    }
                    },style: ElevatedButton.styleFrom(backgroundColor: Constants().darkgrey),
                      child: Text("Date",style: TextStyle(color: Constants().textcolor),)),


                  ElevatedButton(onPressed: () async{
                    TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode.input
                    );
                    if(pickedTime !=null){
                      setState(() {
                        timetaker = "${pickedTime.hour} : ${pickedTime.minute}".toString();
                      });


                    }

                  },style: ElevatedButton.styleFrom(
                    backgroundColor: Constants().darkgrey,
                  ),
                      child: Text("Time",style: TextStyle(color: Constants().textcolor),)),

                ],
              ),
            ),
            SizedBox(height: 10,),
            Text("Date selected : ${datetaker} \n Time selected : ${timetaker}",style: TextStyle(color: Constants().textcolor
            ,fontSize: 16,fontWeight: FontWeight.bold),),
           SizedBox(height:18 ,),
            SizedBox(
              height: 60,
              width: 350,
              child: ElevatedButton(onPressed: (){
                  listEvent();
                  nextScreen(context, UserMasterPage());
              },

                child: Text("Submit",style: TextStyle(color: Constants().textcolor,fontWeight: FontWeight.bold,fontSize: 17),),
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
    );
  }

  listEvent() async {
    if(formkey.currentState!.validate()) {
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .createEventCollection(
          widget.userName,
          FirebaseAuth.instance.currentUser!.uid,
          title,
          description,
          location,
          price,
          type,
          "${datetaker}_${timetaker}",
        locationtype,
        number


      );

      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .createEventUser(
          FirebaseAuth.instance.currentUser!.uid,
          title,
          description,
          location,
          price,
          type,
          "${datetaker}_${timetaker}");
    }


  }




}



