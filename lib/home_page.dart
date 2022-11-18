// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:chat_app/AuthenticationFirebase/auth.dart';
import 'package:chat_app/Files/Properties.dart';
import 'package:chat_app/HelperFunctions.dart';
import 'package:chat_app/LoginPage.dart';
import 'package:chat_app/Shared/InitializationVariables.dart';
import 'package:chat_app/profilePage.dart';
import 'package:chat_app/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'AuthenticationFirebase/Database.dart';
import 'Group_Tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String username = "";
  String email = "";
  Auth auth = Auth();
  Stream? groups;
  bool _isLoading = true;
  String groupName = "";

  @override
  void initState() { 
    super.initState();
    getUserData();
  }

  getUserData() async
  {
    await HelperFunctions.getuserEmail().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getuserName().then((value){
      setState(() {
        username = value!;
      });
    });

    await HelperFunctions.getuserName().then((val) {
      setState(() {
        username = val!;
      });
    });
    // getting the list of snapshots in our stream
    await Dbs(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }
  
  @override

   String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: (){
          nextScreen(context, SearchPage());
        }, icon: Icon((Icons.search)))],
        elevation: 0,
        centerTitle: true,
        title: Text("Groups",
        style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold,fontSize: 27),
        ),
        backgroundColor: primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(Icons.account_circle,
            size: 150,
            color: Colors.teal,
            ),
            SizedBox(height: 10,),
            Text(username,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: 
            FontWeight.bold),),
            SizedBox(height: 30,),
            Divider(
              height: 2,
            ),
            ListTile(
              onTap: (){},
              selectedColor: primaryColor,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5,),
              leading: Icon(Icons.group),
              title: Text("Groups",style: TextStyle
              (color: Colors.black),),
            ),
            ListTile(
              onTap: (){
                nextScreen(context, ProfilePage(email: email, userName: username,));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5,),
              leading: Icon(Icons.group),
              title: Text("Profile",style: TextStyle
              (color: Colors.black),),
            ),
            ListTile(
              onTap: (){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure you want to Logout"),
                    actions: [
                      IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.cancel,color: Colors.red,)),


                      IconButton(onPressed: ()async{
                        await auth.signOut();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const LoginPage(),), (route) => false);
                        },icon: Icon(Icons.done,color: Colors.green,)),
                    ],
                    );
                });
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5,),
              leading: Icon(Icons.exit_to_app),
              title: Text("Log out",style: TextStyle
              (color: Colors.black),),
            ),
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a group",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == false
                      ? Center(
                          child: CircularProgressIndicator(
                              color: primaryColor),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: primaryColor),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      Dbs(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(username,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                            setState((){_isLoading = false;});
                        
                      });
                      Navigator.of(context).pop();
                      showbar(
                          context, Colors.green, "Group created successfully.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: primaryColor),
                  child: const Text("CREATE"),
                )
              ],
            );
          }));
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['fullName']);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

