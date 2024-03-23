import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/pages/chat/groupinfo.dart';
import 'package:community/pages/chat/messagetile.dart';
import 'package:community/service/databaseservice.dart';
import 'package:community/widgets/Constants.dart';
import 'package:community/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget{
  final String eventid;
  final String title;
  final String userName;

  const ChatPage({Key? key,
    required this.userName,
    required this.title,
    required this.eventid}) :super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = "" ;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatandAdmin();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.eventid).then((val){
      setState(() {
        chats = val;
      });

    });
    DatabaseService().geteventAdmin(widget.eventid).then((val){
      setState(() {
        admin = val;

      });
    });
  }


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        elevation: 0,
        title: Text(widget.title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Constants().primaryColor,
        actions: [
          IconButton(onPressed: (){
            nextScreen(context, GroupInfo(
                title: widget.title,
                eventid: widget.eventid,
                adminName: admin));
          }, icon: Icon(Icons.info,color: Colors.white,))
        ],
      ),
      body: Stack(
        children: <Widget> [
          //chat messages here
          chatMessages(),
          Container(
          //  color: Constants().primaryColor,
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 18,horizontal: 20),
              width: MediaQuery.of(context).size.width,
              color: Color(0xFFEDECF4),
              child: Row(
                children: [
                  Expanded(child: TextFormField(
                    controller: messageController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Send a message.....",
                      hintStyle: TextStyle(color: Colors.black,fontSize: 16),
                      border: InputBorder.none,
                    ),
                  )),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: (){
                      sendMessage();
                    },
                    child: Container(
                      height: 50, width: 50,
                      decoration: BoxDecoration(
                        color: Constants().greycol,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.send,color: Colors.white,),
                    ),
                  )
                ],),
            ),

          )


        ],
      ),
    );

  }
  chatMessages(){
    return StreamBuilder(
        stream: chats,
        builder: (context,AsyncSnapshot snapshot){
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,index){
                return MessageTile(
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    sentByMe: widget.userName==snapshot.data.docs[index]['sender']);

              }
          ) : Container();
        }

    );
  }
  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time" : DateTime.now().microsecondsSinceEpoch,

      };
      DatabaseService().sendMessage(widget.eventid, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }

  }
}