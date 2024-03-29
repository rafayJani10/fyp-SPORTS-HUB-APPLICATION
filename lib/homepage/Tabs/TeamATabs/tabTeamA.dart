import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../UIcomponents/UIcomponents.dart';
import '../../../databaseManager/databaseManager.dart';


class TeamATab extends StatefulWidget {

  final String AuthoreId ;
  final List teamAlist;
  final List teamBlist;
  final String eventId;

  TeamATab({super.key, required this.AuthoreId,required this.teamAlist,required this.teamBlist,required this.eventId});

  @override
  State<TeamATab> createState() => _TeamATabState();
}
class _TeamATabState extends State<TeamATab> {

  var dbmanager = DatabaseManager();
  var useriddd = "";
  var pic = "";
  var name = "";
  var email = "";
  var department = "";
  var phoneNo = "";
  var skillset = "" ;
  var teamtp = "";
  var TeamA_joinUser = [];
  var joinPersoTeamA = 0;
  var joinedUserStatus = false;
  var _isloading = true;
  //var _isNodataAlert = false;
  var role_check = false;
  var admin_delete_team_status = false;

  Future getAuthoreData() async{
    var collection = FirebaseFirestore.instance.collection('users');
    //print(widget.AuthoreId);
    var docSnapshot = await collection.doc(widget.AuthoreId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      //print(data?['fullname']);

      setState(()  {
        pic = data?['picture'];
        name = data?['fullname'];
        email = data?['email'];
        department = data?['deptname'];
        phoneNo = data?['phoneNumber'];
        skillset = data?['skillset'];



      });
    }
  }
  Future getLoginUserData()async{
    var data =  await dbmanager.getData('userBioData');
    var daaa = json.decode(data);
    var userid = daaa['id'];
    setState(() {
      useriddd = userid;
      if(daaa?['roles'] == 2){
        role_check = true;
        admin_delete_team_status = false;
      }else{
        role_check = false;
        admin_delete_team_status = true;
      }
    });

  }
  Future getTeamJoinUserList() async{
    var collection = FirebaseFirestore.instance.collection('events');
    var docSnapshot = await collection.doc(widget.eventId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var teamAlist = data?['teamA'];
      setState(()  {
        // print(userData.length);
        var projLength = teamAlist.length;
        var joinedUserStatus = data?['JoindePersonTeamA'];
        teamtp = data?['teambTP'];
        print(projLength);
        setState(() {
          for (var i = 0; i < projLength; i++) {
            print(i);
            if(teamAlist[i] == widget.AuthoreId){
              print("already be a part of team");
              setState(() {
                joinedUserStatus = true;
              });
            }else{
              TeamA_joinUser.add(teamAlist[i]);

            }
            print("sdmasdmgadsjgdasjsad");
            print(TeamA_joinUser);
            //stream = FirebaseFirestore.instance.collection('events').doc(projectList[i]).snapshots();
          }
          if(TeamA_joinUser.isNotEmpty){
            _isloading = false;
          }else{
            //_isNodataAlert = true;
            _isloading = false;
          }
        });

      });
    }

  }
  Future joindeTeam()async{
    var joinedUserLength = TeamA_joinUser.length;
    print(":::::::::WEE:E:::::::::;");
    print(joinedUserLength);
    await FirebaseFirestore.instance.collection('events').doc(widget.eventId).update(
        {
          'teamA': FieldValue.arrayUnion([useriddd]),
          'JoindePersonTeamA': joinedUserLength.toString()
        }).then((value) {
          //_isNodataAlert = false;
      setState(() {
        TeamA_joinUser.add(useriddd);
        print(TeamA_joinUser.length + 1);
        FirebaseFirestore.instance.collection('events').doc(widget.eventId).update(
            {
              'JoindePersonTeamA': (TeamA_joinUser.length + 1).toString()
            }).then((value) {
          showAlertDialog(context,"Success","Successfully join the group");
        });
      });

      });


  }
  Future deleteTeam(deleteMemeberID) async{
    var collection = FirebaseFirestore.instance.collection('events');
    collection
        .doc(widget.eventId)
        .update(
        {
          'teamA': FieldValue.arrayRemove([deleteMemeberID]),
        }
    ).then((value){

      showAlertDialog(context,"Successfull","you deleted from this toyrnament");
      TeamA_joinUser = [];
      getTeamJoinUserList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAuthoreData();
    getLoginUserData();
    getTeamJoinUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
              flex: 1,
              child: Container(
                width: double.infinity,
                child:  Center(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 6, blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: Stack(
                                  children: [
                                    // Circular avatar with image or placeholder

                                    CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.grey, // Placeholder color
                                        backgroundImage: pic == null || pic == ""
                                            ?  NetworkImage("https://img.freepik.com/premium-vector/anonymous-user-circle-icon-vector-illustration-flat-style-with-long-shadow_520826-1931.jpg?w=2000")
                                            : NetworkImage(pic)
                                    ),

                                    // // Loader
                                    // if (is_image_loading)
                                    //   Positioned.fill(
                                    //     child: CircularProgressIndicator(),
                                    //   ),
                                  ],
                                ),),
                            Flexible(
                                flex: 2,
                                child: Container(
                                  height: 150,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 10,left: 10),
                                        child: Text(name,
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
                                              Text(email,
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,

                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,

//fontWeight: FontWeight.bold
                                                ),

                                               // overflow: TextOverflow.fade,
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
                                              Text(department,
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,

                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
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
                                                Icons.equalizer,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(width: 4,),
                                              Text(skillset,
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
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
                                              Text(phoneNo,
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,

                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
//fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    )
                ),
              )),
          Divider(color: Colors.grey,),
          Flexible(
              flex: 3,
              child: Container(
                width: double.infinity,
                child: Stack(
                  children: [
                    ListView.builder(
                        itemCount: TeamA_joinUser.length,//myProjectId.length,
                        itemBuilder: (BuildContext context, int index){
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('users').doc(TeamA_joinUser[index]).snapshots(),
                            builder: (context, snapshot){
                              if (snapshot.data == null ) {
                                return Center(child: Text('NO DATA'));
                              }
                              return Center(
                                  child: Container(
                                    margin: EdgeInsets.all(8),
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 6, blurRadius: 7,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),

                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Stack(
                                              children: [
                                                // Circular avatar with image or placeholder
                                                CircleAvatar(
                                                    radius: 40,
                                                    backgroundColor: Colors.grey, // Placeholder color
                                                    backgroundImage: snapshot.data?['picture'] == null || snapshot.data?['picture'] == ""
                                                        ?  NetworkImage("https://img.freepik.com/premium-vector/anonymous-user-circle-icon-vector-illustration-flat-style-with-long-shadow_520826-1931.jpg?w=2000")
                                                        : NetworkImage(snapshot.data?['picture'])
                                                ),

                                                // // Loader
                                                // if (is_image_loading)
                                                //   Positioned.fill(
                                                //     child: CircularProgressIndicator(),
                                                //   ),
                                              ],
                                            ),),
                                          Flexible(
                                              flex: 3,
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
                                                                    fontSize: 12,
//fontWeight: FontWeight.bold
                                                                  ),
                                                                  //softWrap: false,
                                                                  // maxLines: 1,
                                                                  // overflow: TextOverflow.ellipsis,
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
                                                                    fontSize: 12,
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
                                                                  Icons.equalizer,
                                                                  size: 20,
                                                                  color: Colors.grey,
                                                                ),
                                                                SizedBox(width: 4,),
                                                                Text(snapshot.data?['skillset'],

                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 12,
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
                                                                    fontSize: 12,
//fontWeight: FontWeight.bold
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                        )
                                                      ],
                                                    ),
                                                  ),

                                                    Visibility(
                                                      visible: admin_delete_team_status,
                                                      child: Align(
                                                        alignment: Alignment.bottomRight,
                                                        child: InkWell(
                                                          onTap: (){
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text("Want to delete the team member ?"),
                                                                  actions: <Widget>[
                                                                    ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          primary: Colors.red
                                                                        //onPrimary: Colors.black,
                                                                      ),
                                                                      child: Text("No"),
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                    ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                        primary: Colors.teal[900],
                                                                        //onPrimary: Colors.black,
                                                                      ),
                                                                      child: Text("Yes"),
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          print(snapshot.data?.id);
                                                                          deleteTeam(snapshot.data?.id);
                                                                        });
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );


                                                          },
                                                          child:  Container(
                                                            height: 50,
                                                            width: 50,
                                                            // color: Colors.green,
                                                            child: Icon(Icons.delete,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        )
                                                    ),),
                                                  if(snapshot.data?['id'] == useriddd)
                                                    Align(
                                                        alignment: Alignment.bottomRight,
                                                        child: InkWell(
                                                          onTap: (){
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text("Want to quit???"),
                                                                  actions: <Widget>[
                                                                    ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          primary: Colors.red
                                                                        //onPrimary: Colors.black,
                                                                      ),
                                                                      child: Text("No"),
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                    ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                        primary: Colors.teal[900],
                                                                        //onPrimary: Colors.black,
                                                                      ),
                                                                      child: Text("Yes"),
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          deleteTeam(snapshot.data?['id']);
                                                                        });
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );


                                                          },
                                                          child:  Container(
                                                            height: 50,
                                                            width: 50,
                                                            // color: Colors.green,
                                                            child: Icon(Icons.delete,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        )
                                                    )
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),

                                  )
                              );
                            },
                          );
                        }
                    ),
                    Visibility(visible:_isloading,child: Center(child: CircularProgressIndicator(),)),

                  ],
                )
              )
          )
        ],
      ),
      floatingActionButton: Visibility(
        visible: role_check,
        child: FloatingActionButton.extended(
          onPressed: () {
            getLoginUserData();
            if (joinPersoTeamA != teamtp){
              if(useriddd != widget.AuthoreId){
                if(TeamA_joinUser.contains(useriddd)){
                  showAlertDialog(context,"Error","You are already join in Team A");
                }
                else if (widget.teamBlist.contains(useriddd)){
                  showAlertDialog(context,"Error","You are already join in Team B");
                }else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Want To Join??"),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.red
                              //onPrimary: Colors.black,
                            ),
                            child: Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.teal[900]
                              //onPrimary: Colors.black,
                            ),
                            child: Text("Yes"),
                            onPressed: () {
                              joindeTeam();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }else{
                showAlertDialog(context,"Error","You are already joined");
              }
            }else{
              showAlertDialog(context,"Housfull","Sorry member are on its capacity ?");
            }
          },
          label:  Text('Join Team',
            style: TextStyle(color: Colors.white),),
          icon:  Icon(Icons.add,color: Colors.white,),
          backgroundColor: Colors.teal[900],
        ),
      )
    );
  }
}
