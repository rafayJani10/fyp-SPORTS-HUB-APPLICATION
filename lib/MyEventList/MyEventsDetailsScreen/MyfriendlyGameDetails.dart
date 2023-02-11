import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/CreateEvents/CreateEvents.dart';
import 'package:fyp/homepage/homepage.dart';
import '../../MyEventList/MyEventList.dart';

import 'package:fyp/login/view/LoginScreen.dart';
import 'package:fyp/services/firebase_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../UIcomponents/UIcomponents.dart';

import '../tabs/subtabs/MytabTeamA.dart';
import '../tabs/subtabs/MytabTeamB.dart';
import '/ProfilePage/ProfilePage.dart';
import '/databaseManager/databaseManager.dart';

class MyFriendlyEventDetails extends StatefulWidget {
  final String AuthoreId ;
  final List teamAlist;
  final List teamBlist;
  final String eventId;
  MyFriendlyEventDetails({required this.AuthoreId,required this.teamAlist,required this.teamBlist,required this.eventId});

  @override
  State<MyFriendlyEventDetails> createState() => _MyFriendlyEventDetailsState();
}

class _MyFriendlyEventDetailsState extends State<MyFriendlyEventDetails> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  final List<Tab> myTabs =  <Tab>[
    new Tab(text: 'a'),
    new Tab(text: 'b'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event List"),
        backgroundColor: Colors.teal[900],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text('Teams A',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            Tab(
              child: Text('Team B',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MyTeamATab(AuthoreId: widget.AuthoreId, teamAlist: widget.teamAlist, teamBlist: widget.teamBlist, eventId: widget.eventId),
          MyTeamBTab(AuthoreId: widget.AuthoreId, teamAlist: widget.teamAlist, teamBlist: widget.teamBlist, eventId: widget.eventId),

        ],
      ),
    );
  }
}
