
import 'package:community/widgets/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../service/databaseservice.dart';

class GroupInfo extends StatefulWidget{
  final String eventid;
  final String title;
  final String adminName;


  const GroupInfo({Key? key,
    required this.title,
    required this.eventid,
    required this.adminName}) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? eventmembers;
  @override
  void initState() {
    // TODO: implement initState
    getMembers();
    super.initState();
  }
  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getEventMembers(widget.eventid)
        .then((val){
      setState(() {
        eventmembers = val;
      });
    });
  }
  String getName(String r){
    return r.substring(r.indexOf("_")+1);
  }
  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        elevation: 0,
        backgroundColor: Constants().primaryColor,
        title: Text("Event Info",style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: (){
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: Text("Exit"),
                    content: Text("Are you sure you want to exit?"),
                    actions: [
                      IconButton(onPressed:() {Navigator.pop(context);},
                          icon: Icon(Icons.cancel,color: Colors.red)
                      ),
                      IconButton(onPressed:() async {
                        // DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).toggleGroupJoin(
                        //     widget.groupId, getName(widget.adminName), widget.groupName).whenComplete((){
                        //   nextScreenReplace(context, Homepage());
                        // });
                      },
                          icon: Icon(Icons.done,color: Colors.green,)
                      ),
                    ],
                  );
                });
          }, icon: Icon(Icons.exit_to_app),color: Colors.white,)
        ],

      ),
      body: Container(
        // color: Constants().primaryColor,
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 13),
        child: Column(
          children: [
            Container(

              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                color: Constants().darkgrey,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(

                    radius: 30,
                    backgroundColor: Constants().primaryColor,
                    child: Text(widget.title.substring(0,1).toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Container(
                    color: Constants().darkgrey,
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Event : ${widget.title}",style: TextStyle(fontWeight: FontWeight.w500,color: Constants().textcolor),
                        ),
                        SizedBox(width: 6,),
                        Text("Admin: ${getName(widget.adminName)}",style: TextStyle(color: Constants().textcolor),)
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 5,),
            memberList(),
          ],
        ),
      ),

    );

  }
  memberList() {
    return  StreamBuilder(
        stream: eventmembers,
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data['buyer'] != null){
              if(snapshot.data['buyer'] != 0){
                return ListView.builder(
                    itemCount: snapshot.data['buyer'].length,
                    shrinkWrap: true,
                    itemBuilder:(context, index){
                      return Container(

                       decoration: BoxDecoration(
                        color: Constants().greycol,
                        borderRadius: BorderRadius.circular(22)
                       ),
                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10,),
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Constants().darkgrey,
                            child: Text(getName(snapshot.data['buyer'][index])
                                .substring(0,1).toUpperCase(),
                              style: TextStyle(
                                  color:  Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),),
                          ),
                          title:  Text(getName(snapshot.data['buyer'][index]),style: TextStyle(color: Constants().textcolor),),
                          subtitle: Text(getId(snapshot.data['buyer'][index]),style: TextStyle(color: Constants().textcolor)),
                        ),
                      );
                    }


                );

              }else{
                return Center(child: Text("NO MEMBERS"),);
              }

            }else{
              return Center(child: Text("NO MEMBERS"),);
            }

          }else{
            return Center(child: CircularProgressIndicator(color: Constants().primaryColor,),);
          }

        }

    );
  }
}
