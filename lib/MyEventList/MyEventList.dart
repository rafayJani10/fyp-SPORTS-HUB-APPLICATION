
import 'package:flutter/material.dart';
import 'package:fyp/MyEventList/tabs/myFriendlygames.dart';
import 'package:fyp/MyEventList/tabs/myTournaments.dart';

class MyEventList extends StatefulWidget {
  const MyEventList({super.key,  required this.title});
  final String title;
  @override
  State<MyEventList> createState() => _MyEventList();
}

class _MyEventList extends State<MyEventList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> myTabs =  <Tab>[
    const Tab(text: 'a'),
    const Tab(text: 'b'),
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
        //drawer: SideMenueBar(),
        appBar: AppBar(
          title: const Text("My Events"),
          backgroundColor: Colors.teal[900],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                child: Text('Frinedly Games',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
              Tab(
                child: Text('Tournament',
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
          children: const [
            MyFriendlyGame(),
            MytournamentEventList()
          ],
        )
    );
  }
}

