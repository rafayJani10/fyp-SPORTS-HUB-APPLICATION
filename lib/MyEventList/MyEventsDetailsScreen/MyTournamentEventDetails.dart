import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/CreateEvents/CreateEvents.dart';
import '../../MyEventList/MyEventList.dart';

import 'package:fyp/homepage/homepage.dart';
import 'package:fyp/login/view/LoginScreen.dart';
import 'package:fyp/services/firebase_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../UIcomponents/UIcomponents.dart';

import '/ProfilePage/ProfilePage.dart';
import '/databaseManager/databaseManager.dart';

class MyTournamentEventDetail extends StatefulWidget {
  final String? authoreId;
  final String? eventID;
  final List listJoinedUser ;

  MyTournamentEventDetail({required this.authoreId,required this.eventID, required this.listJoinedUser});

  @override
  State<MyTournamentEventDetail> createState() => _MyTournamentEventDetailState();
}

class _MyTournamentEventDetailState extends State<MyTournamentEventDetail> {

  var dbmanager = DatabaseManager();
  var LoginUserId = "";

  Future getLoginUserData()async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    var userid = daaa['id'];
    setState(() {
      LoginUserId = userid;
    });

  }

  Future joimSelectedEvent() async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    var userid = daaa['id'];

    await FirebaseFirestore.instance.collection("TourEvents").doc(widget.eventID)
        .update(
        {"joinedUserList": FieldValue.arrayUnion([LoginUserId])}
    ).then((value) {
      showAlertDialog(context,"Successfully Join","you successfully join the teams");
    });
  }

  Future deletemember() async{
    var collection = FirebaseFirestore.instance.collection('TourEvents');
    collection
        .doc(widget.eventID)
        .update(
        {
          'teamA': FieldValue.arrayRemove([LoginUserId]),
        }
    ).then((value) {
      showAlertDialog(context,"Success","you delete the user");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: SideMenueBar(),
      appBar: AppBar(
        title: const Text("Event List"),
        backgroundColor: Colors.teal[900],
      ),
      body: ListView.builder(
          itemCount: widget.listJoinedUser.length,//myProjectId.length,
          itemBuilder: (BuildContext context, int index){
            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(widget.listJoinedUser[index]).snapshots(),
              builder: (context, snapshot){
                if (snapshot.data == null ) {
                  return Center(child: Text('NO DATA'));
                }
                return Center(
                    child: Container(
                      margin: EdgeInsets.all(15),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 6, blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Flexible(
                              flex: 1,
                              child: Container(
                                height: 150,
                                color: Colors.teal[900],
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 50,
                                    child: ClipOval(
                                        child: snapshot.data?['picture'] != "" ?Image.network(snapshot.data?['picture'],  fit: BoxFit.fill) :Image.network("https://img.freepik.com/premium-vector/anonymous-user-circle-icon-vector-illustration-flat-style-with-long-shadow_520826-1931.jpg?w=2000",  fit: BoxFit.fill)
                                    ),
                                  ),
                                ),
                              )),
                          Flexible(
                              flex: 2,
                              child: Stack(
                                children: [
                                  Container(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 10,left: 10),
                                          child: Text(snapshot.data?['fullname'],
                                            softWrap: false,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 10,left: 10),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.email,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 4,),
                                                Text(snapshot.data?['email'],

                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 11,
//fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 3,left: 10),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.add_business_outlined,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 4,),
                                                Text(snapshot.data?['deptname'],

                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
//fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 3,left: 10),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.equalizer,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 4,),

                                                Text(snapshot.data?['skillset'],

                                                  softWrap: false,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,

                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
//fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 3,left: 10),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.phone_android_sharp,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 4,),
                                                Text(snapshot.data?['phoneNumber'],

                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
//fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ],
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      //color: Colors.red,
                                      child: InkWell(
                                        onTap: (){
                                          deletemember();

                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                          )
                        ],
                      ),

                    )
                );
              },
            );
          }
      ),
    );
  }
}
