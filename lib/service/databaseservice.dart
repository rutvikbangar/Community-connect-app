import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //reference of our collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
 final CollectionReference eventCollection = FirebaseFirestore.instance.collection("event");
 // final CollectionReference notesCollection = FirebaseFirestore.instance.collection("notes");


  //update the userdata
  Future updateUserData(String fullname,String email) async {
    return await userCollection.doc(uid).set({
      "uid" : uid,
      "fullname": fullname,
      "email" : email,
      "buyer" : [],
    });

  }

//getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }




  // create an event
  createEventUser(String id,String title,String description,String location,String price,String type,String time) async {
    return userCollection
        .doc(id)
        .collection("event")
        .add({
      "title" : title,
      "description" : description,
      "location" : location,
      "price" : price,
      "type" : type,
      "time" : time,

    });

  }
  Future createEventCollection(
      String userName,String id, String title,String description,String location,String price,String type,
     String time,String locationtype,String number ) async {
    DocumentReference eventDocumentReference = await eventCollection.add({
      "title" : title,
      "admin" : "${id}_$userName",
      "buyer" : [] ,
      "type" : type,
      "description" : description,
      "location" : location,
      "price" : price,
      "eventid" : "",
      "time" : time,
      "locationtype" : locationtype,
      "recentMessage" : "",
      "recentMessageSender" : "",
      "number" : number


    });
    //update the buyer
    await eventDocumentReference.update({
      "buyer" : FieldValue.arrayUnion(["${uid}_$userName"]),
      "eventid" : eventDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "buyer" : FieldValue.arrayUnion(["${eventDocumentReference.id}_$title"])
    });

  }

  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  Future<Stream<QuerySnapshot>> gettotalevent () async {
    return await FirebaseFirestore.instance.collection("event").snapshots();
  }

  Future geteventAdmin(String eventid) async{
    DocumentReference d = eventCollection.doc(eventid);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }
  getChats(String eventid) async {
    return eventCollection
        .doc(eventid)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }
  sendMessage(String eventid,Map<String, dynamic> chatMessageData) async {
    eventCollection.doc(eventid).collection("messages").add(chatMessageData);
    eventCollection.doc(eventid).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime" : chatMessageData['time'].toString()

    });
  }
  getEventMembers(eventid) async {
    return eventCollection.doc(eventid).snapshots();
  }


  Future toggleGroupJoin(String eventid,String userName,String title) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference eventDocumentReference = eventCollection.doc(eventid);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> buyer = await documentSnapshot['buyer'];

    //if user has our groups --> then remove then or arise in other part re join
    if(buyer.contains("${eventid}_$title")){
      await userDocumentReference.update({
        "buyer" : FieldValue.arrayRemove(["${eventid}_$title"])
      });
      await eventDocumentReference.update({
        "buyer" : FieldValue.arrayRemove(["${uid}_$userName"])
      });
    }else{
      await userDocumentReference.update({
        "buyer" : FieldValue.arrayUnion(["${eventid}_$title"])
      });
      await eventDocumentReference.update({
        "buyer" : FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }
  Future<bool> isUserJoined(String title,String eventid,String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> buyer =  await documentSnapshot['buyer'];
    if(buyer.contains("${eventid}_$title")){
      return true;
    }else{
      return false;
    }
  }
  searchByType(String type){
    return eventCollection.where("type",isEqualTo: type).get();
  }
  searchByLocationType(String type){
    return eventCollection.where("locationtype",isEqualTo: type).get();
  }


  Future deleteeventfromevent(String id) async {
    FirebaseFirestore.instance.collection("event").doc(id).delete();

  }

  Future deleteeventfromuser(String eventid,String title) async{
    DocumentReference userDocumentReference = userCollection.doc(uid);



    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> buyer = await documentSnapshot['buyer'];

    if(buyer.contains("${eventid}_${title}")){
      await userDocumentReference.update({
        "buyer" : FieldValue.arrayRemove(["${eventid}_${title}"])
      });

    }



  }



  }




