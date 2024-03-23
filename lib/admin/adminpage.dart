import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/admin/admineventpage.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: Text('users'),
        centerTitle: true,

      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context,snapshot){
          if  (snapshot.connectionState==ConnectionState.active){
            if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
              return ListTile(
                leading: CircleAvatar(
                  child: Text("${index + 1}"),
                ),
                title: Text("${snapshot.data!.docs[index]['fullname']}"),
              );
            });


          }else if(snapshot.hasError){
              return Center(child: Text('${snapshot.hasError.toString()}'),);

            }
            else{
              return Center(child: Text('No dta Found'),);
            }
    }
          else{
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
      drawer: Drawer(

        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(Icons.account_circle, size: 150, color: Colors.indigoAccent),
            SizedBox(height: 15),
            Text('Admin', textAlign: TextAlign.center, style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            Divider(height: 2),
            ListTile(
              onTap: () {},
              selectedColor: Theme
                  .of(context)
                  .primaryColor,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.group),
              title: Text("Users", style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(
                    context, AdminEventPage());
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.person),
              title: Text("Events", style: TextStyle(color: Colors.black),),
            ),
            // ListTile(
            //   onTap: () async {
            //     showDialog(context: context,
            //         builder: (context) {
            //           return AlertDialog(
            //             title: Text("Logout"),
            //             content: Text("Are you sure you want to logout"),
            //             actions: [
            //               IconButton(onPressed: () {
            //                 Navigator.pop(context);
            //               },
            //                   icon: Icon(Icons.cancel, color: Colors.red)
            //               ),
            //               IconButton(onPressed: () async {
            //                 await authservice.signOut();
            //                 Navigator.of(context).pushAndRemoveUntil(
            //                     MaterialPageRoute(
            //                         builder: (context) => Loginpage()),
            //                         (route) => false);
            //               },
            //                   icon: Icon(Icons.done, color: Colors.green,)
            //               ),
            //             ],
            //           );
            //         });
            //   },
            //   contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            //   leading: Icon(Icons.exit_to_app),
            //   title: Text("Logout", style: TextStyle(color: Colors.black),),
            // )


          ],
        ),
      ),
    );
  }
}
