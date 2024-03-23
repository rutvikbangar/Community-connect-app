import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/helper/helperfunction.dart';
import 'package:community/pages/eventdetail.dart';
import 'package:community/service/databaseservice.dart';
import 'package:community/widgets/Constants.dart';
import 'package:community/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchLocationPage extends StatefulWidget{
  @override
  State<SearchLocationPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchLocationPage> {
  TextEditingController searchController = TextEditingController();
  bool _isloading = false;
  QuerySnapshot? searchSnapshot;
  bool _hasUserSearched = false;
  bool _isJoined = false;
  String userName="";
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async {
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }
  String getName(String r){
    return r.substring(r.indexOf("_")+1);
  }
  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants().darkgrey,
        title: Text("Search Location",style: TextStyle(
            fontSize: 27,fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Constants().darkgrey,
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child:  Row(
              children: [
                Expanded(child: TextField(
                  controller: searchController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search location type ...",
                      hintStyle: TextStyle(color: Colors.white,fontSize: 16)
                  ),
                )),
                GestureDetector(
                  onTap: (){
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40)
                    ),
                    child: Icon(Icons.search,color: Colors.white,),
                  ),
                )
              ],
            ),
          ),
          _isloading? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),)
              : groupList(),
        ],
      ),
    );
  }
  initiateSearchMethod() async {
    if(searchController.text.isNotEmpty){
      setState(() {
        _isloading = true;
      });
      await DatabaseService().searchByLocationType(searchController.text).then((snapshot){
        setState(() {
          searchSnapshot= snapshot;
          _isloading = false;
          _hasUserSearched= true;
        });
      });
    }
  }
  groupList(){
    return _hasUserSearched? ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot!.docs.length,
        itemBuilder: (context, index){
          return groupTile(userName,
            searchSnapshot!.docs[index]['eventid'],
            searchSnapshot!.docs[index]['title'],
            searchSnapshot!.docs[index]['admin'],
            searchSnapshot!.docs[index]['type'],
            searchSnapshot!.docs[index]['description'],
            searchSnapshot!.docs[index]['price'],
            searchSnapshot!.docs[index]['time'],
            searchSnapshot!.docs[index]['location'],
              searchSnapshot!.docs[index]['number']



          );
        }

    )
        : Container();
  }
  joinedOrNot(String userName,String eventid,String title,String admin,) async{
    await DatabaseService(uid: user!.uid).isUserJoined(title, eventid, userName).then((value){
      setState(() {
        _isJoined = value;
      });
    });

  }

  Widget groupTile(String userName,String eventid,String title,String admin,String type,String description,String price,String time,String location,String number){
    // function to check whether th user already existed in a group
    joinedOrNot(userName,eventid,title,admin);
    return GestureDetector(
      onTap: (){
        nextScreen(context, DetailEventPage(
            title: title, description: description, type: type, time: time, price: price, location: location, admin: admin, eventid: eventid,number: number,));
      },
      child: Container(
        margin: EdgeInsets.only(top: 3,bottom: 3,left: 2,right: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Constants().primaryColor,
        ),

        child: ListTile(

          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Constants().darkgrey,
            child: Text(title.substring(0,1).toUpperCase(),
              style: TextStyle(color: Colors.white),),
          ),
          title: Text(title,style: TextStyle(fontWeight: FontWeight.w600,color: Constants().textcolor),),
          subtitle: Text("Organizer : ${getName(admin)}",style: TextStyle(color: Constants().textcolor),),
        ),
      ),
    );
  }

}