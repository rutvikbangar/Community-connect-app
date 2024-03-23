import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/admin/adminpage.dart';
import 'package:community/service/databaseservice.dart';
import 'package:community/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminEventPage extends StatelessWidget {
  const AdminEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        centerTitle: true,

      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('event').snapshots(),
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
                      title: Text("${snapshot.data!.docs[index]['title']}"),
                      trailing: IconButton(onPressed: (){

                        DatabaseService(uid : FirebaseAuth.instance.currentUser!.uid)
                            .deleteeventfromevent(snapshot.data!.docs[index]['eventid']);

                        DatabaseService(uid : FirebaseAuth.instance.currentUser!.uid).
                        deleteeventfromuser(snapshot.data!.docs[index]['eventid'],snapshot.data!.docs[index]['title']).whenComplete(() {
                          nextScreenReplace(context, AdminPage());

                        });

                      }


                          , icon: Icon(Icons.delete)),
                    );
                  });


            }else if(snapshot.hasError){
              return Center(child: Text('${snapshot.hasError.toString()}'),);

            }
            else{
              return Center(child: Text('No data Found'),);
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
              onTap: () {nextScreenReplace(context, AdminPage());},

              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.group),
              title: Text("Users", style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: () {
                // nextScreenReplace(
                //     context, ProfilePage(email: email, userName: userName));
              },
              selectedColor: Theme
                  .of(context)
                  .primaryColor,
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
