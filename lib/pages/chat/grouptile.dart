import 'package:community/widgets/Constants.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import 'chatpage.dart';


class GroupTile extends StatefulWidget{
  final String userName;
  final String eventid;
  final String title;

  const GroupTile({Key? key,
    required this.title,
    required this.userName,
    required this.eventid})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        nextScreen(context, ChatPage(
            userName: widget.userName,
            title: widget.title,
            eventid: widget.eventid)
        );
      },
      child: Container(

        decoration: BoxDecoration(
          color: Constants().darkgrey,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Constants().greycol,
            child: Text(widget.title.substring(0,1).toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,fontWeight: FontWeight.w500
              ),),
          ),
          title: Text(widget.title,style: TextStyle(fontWeight: FontWeight.bold,color: Constants().textcolor),),
          subtitle: Text("Join the conversation as ${widget.userName}",style: TextStyle(fontSize: 13,color: Constants().textcolor),),
        ),
      ),
    );

  }
}