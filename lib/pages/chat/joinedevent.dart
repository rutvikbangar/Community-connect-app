import 'package:community/helper/helperfunction.dart';
import 'package:community/pages/chat/grouptile.dart';
import 'package:community/service/databaseservice.dart';
import 'package:community/widgets/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../service/authservice.dart';

class JoinedEventMain extends StatefulWidget {
  const JoinedEventMain({super.key});

  @override
  State<JoinedEventMain> createState() => _JoinedEventMainState();
}

class _JoinedEventMainState extends State<JoinedEventMain> {
  String userName = "";
  String email = "";
  Authservice authservice = Authservice();
  Stream? buyer;
  bool _isloading = false;
  String groupName = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
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
    // getting the list of snapshot in out stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        buyer = snapshot;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().primaryColor,
      appBar: AppBar(
        title: Text("Joined Events",style: TextStyle(color: Constants().textcolor,fontSize: 22,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Constants().primaryColor,
      ),
    body: groupList() ,

    );
  }
  groupList() {
    return StreamBuilder(
      stream: buyer,
      builder: (context, AsyncSnapshot snapshot) {
        //checks
        if (snapshot.hasData) {
          if (snapshot.data['buyer'] != null) {
            if (snapshot.data['buyer'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['buyer'].length,

                  itemBuilder: (context, index){
                //    int reverseIndex = snapshot.data['buyer'].length - index - 1;
                    return GroupTile(
                        title: getName(snapshot.data['buyer'][index]),
                        userName: snapshot.data['fullname'],
                        eventid : getId(snapshot.data['buyer'][index])

                    );
                  }

              );
            } else {
              return noGroupsWidget();
            }
          } else {
            return noGroupsWidget();
          }
        } else {
          return Center(child: CircularProgressIndicator(color: Theme
              .of(context)
              .primaryColor));
        }
      },
    );
  }

  noGroupsWidget() {
    return Center(
      child: Container(
        color: Constants().primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.add_circle, color: Colors.white, size: 75,),
             SizedBox(height: 20,),
      
            Text("You have not joined any event.",
              textAlign: TextAlign.center,style: TextStyle(color: Constants().textcolor),),
          ],
        ),
      ),
    );
  }











}
