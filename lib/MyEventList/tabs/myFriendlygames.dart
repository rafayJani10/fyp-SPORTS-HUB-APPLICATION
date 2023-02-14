import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../UIcomponents/UIcomponents.dart';
import '../../databaseManager/databaseManager.dart';
import '../../homepage/EventsDetailsScreen/friendlyGameDetails.dart';
import '../MyEventsDetailsScreen/MyfriendlyGameDetails.dart';



class MyFriendlyGame extends StatefulWidget {
  const MyFriendlyGame({Key? key}) : super(key: key);

  @override
  State<MyFriendlyGame> createState() => _MyFriendlyGameState();
}

class _MyFriendlyGameState extends State<MyFriendlyGame> {
  var dbmanager = DatabaseManager();
  var loginUserid = "";
  var myProjectId = [];

  Future<dynamic> getUserData() async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    var userid = daaa['id'];
    print(userid);
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(userid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      var projectList = data?['projects'];
      setState(()  {
        // print(userData.length);
        var projLength = projectList.length;
        print(projLength);
        for (var i = 0; i < projLength; i++) {
          print(i);
          myProjectId.add(projectList[i]);
          print(myProjectId);
          //stream = FirebaseFirestore.instance.collection('events').doc(projectList[i]).snapshots();
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: SideMenueBar(),
        body: ListView.builder(
            itemCount: myProjectId.length,
            itemBuilder: (BuildContext context, int index){
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('events').doc(myProjectId[index]).snapshots(),
                builder: (context, snapshot){
                  if (snapshot.data == null ) {
                    return Center(
                      child:  Text("no data"),
                    );
                  }
                  return InkWell(
                    onTap: (){
                      print("cell click");
                      var idd = snapshot.data?['name'];
                      print(idd);
                      var authorId = snapshot.data?['eventAuthore'];
                      var eventIdd = snapshot.data?.reference.id;
                      var teamAJoindeList = snapshot.data?['teamA'];
                      var teamBJoindeList = snapshot.data?['teamB'];
                      print(authorId);
                      // print(eventIdd);
                      // print(teamAJoindeList);
                      // print(teamBJoindeList);
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) =>  MyFriendlyEventDetails(
                                AuthoreId: authorId, teamAlist: teamAJoindeList, teamBlist: teamBJoindeList, eventId: eventIdd!,
                              )
                          )
                      );
                    },
                    child:  Container(
                      margin: EdgeInsets.all(15),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 6,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 3,
                            child: SizedBox(
                              height: 130,
                              child: Center(
                                  child: snapshot.data?['picture'] == "" ?  Image.network("https://t3.ftcdn.net/jpg/02/48/42/64/360_F_248426448_NVKLywWqArG2ADUxDq6QprtIzsF82dMF.jpg",
                                    //height: 150,
                                    fit: BoxFit.fitHeight,
                                  ): Image.network(
                                    snapshot.data?['picture'],
                                    //height: 150,
                                    fit: BoxFit.fitHeight,
                                  )


                              ),
                            ),
                          ),
                          Flexible(
                              flex: 5,
                              child: Column(
                                children: [
                                  Flexible(
                                      flex: 2,
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(left: 10, top: 15),
                                        //color: Colors.yellow,
                                        height: 70,
                                        child: Text(snapshot.data?['name'],
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.bold,

                                                fontSize: 22)),
                                      )),
                                  Flexible(
                                      flex: 2,
                                      child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          padding: EdgeInsets.only(left: 10),
                                          //color: Colors.green,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_rounded,
                                                color: Colors.red,
                                                size: 20.0,
                                              ),
                                              Text(snapshot.data?['address'],
                                                  style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontSize: 14))

                                            ],
                                          )
                                      )),

                                  Flexible(
                                      flex: 3,
                                      child: Container(
                                        //color: Colors.red,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, top: 15),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 25,
//color: Colors.green,
                                                  child: Column(
                                                    children:  <Widget>[
                                                      Icon(
                                                        Icons.calendar_month,
                                                        color: Colors.grey,
                                                        size: 20.0,
                                                      ),
                                                      Text(snapshot.data?['date'],
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 9)),
                                                    ],
                                                  ),

                                                ),
                                                SizedBox(width: 5,),
                                                Container(
                                                  height: 50,
                                                  width: 25,
//color: Colors.green,
                                                  child: Column(
                                                    children:  <Widget>[
                                                      Icon(
                                                        Icons.timer,
                                                        color: Colors.black,
                                                        size: 20.0,
                                                      ),
                                                      Text(snapshot.data?['time'],
                                                          style: TextStyle(
                                                              fontSize: 8)),
                                                    ],
                                                  ),

                                                ),
                                                SizedBox(width: 5,),
                                              Container(
                                                height: 50,
                                                width: 25,
//color: Colors.green,
                                                child: Column(
                                                  children:  <Widget>[
                                                    Icon(
                                                      Icons.person,
                                                      color: Colors.black,
                                                      size: 20.0,
                                                    ),
                                                    Text(snapshot.data?['teamsATP'],
                                                        style: TextStyle(
                                                            fontSize: 9)),
                                                  ],
                                                ),

                                              ),
                                                SizedBox(width: 5,),
                                                Container(
                                                  height: 50,
                                                  width: 25,
//color: Colors.green,
                                                  child: Column(
                                                    children:  <Widget>[
                                                      Icon(
                                                        Icons.person,
                                                        color: Colors.black,
                                                        size: 20.0,
                                                      ),
                                                      Text(snapshot.data?['teambTP'],
                                                          style: TextStyle(
                                                              fontSize: 9)),
                                                    ],
                                                  ),

                                                ),
                                                SizedBox(width: 5,),
                                              Container(
                                                height: 50,
                                                width: 25,
//color: Colors.green,
                                                child: Column(
                                                  children:  <Widget>[
                                                    Icon(
                                                      Icons.person_add,
                                                      color: Colors.green,
                                                      size: 20.0,
                                                    ),
                                                    Text((snapshot.data?['JoindePersonTeamA']).toString(),
                                                        style: TextStyle(
                                                            fontSize: 9)),
                                                  ],
                                                ),

                                              ),
                                                SizedBox(width: 5,),

                                                Container(
                                                  height: 50,
                                                  width: 25,
//color: Colors.green,
                                                  child: Column(
                                                    children:  <Widget>[
                                                      Icon(
                                                        Icons.person_add,
                                                        color: Colors.green,
                                                        size: 20.0,
                                                      ),
                                                      Text((snapshot.data?['JoindePersonTeamB']).toString(),
                                                          style: TextStyle(
                                                              fontSize: 9)),
                                                    ],
                                                  ),

                                                ),
                                              ],
                                            )
                                        ),
                                      ))
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
        )

    );
  }
}