import 'package:flutter/material.dart';
import 'SideBar//SideMenuBar.dart';
//import 'package:';
//import 'package:auto_layout/auto_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  //
  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer:
        const SideMenueBar(),
        appBar: AppBar(
          title: const Text("Event List"),
          // leading: InkWell(
          //   child: const Icon(
          //     Icons.menu,
          //     size: 25,
          //     color: Colors.white,
          //   ),
          //   onTap: (){
          //     print("click on menue button :::::::::::::::");
          //     SideMenueBar();
          //   },
          // )
        ),
        body:ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            for (var i = 0; i < 5; i++) ...[
              Container(
                margin: EdgeInsets.only(left: 5, top: 30, right: 10, bottom: 5),
                height: 150,
                //width: double.infinity,
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
                    SizedBox(
                      height: 150,
                      width: 100,
                      //color: Colors.red,
                      child: Center(
                          child:  Image.network(
                            'https://picsum.photos/250?image=9',
                            height: 150,
                            fit: BoxFit.fitHeight,
                          )
                      ),
                    ),
                    Container(
                      height: 150,
                      width: 200,
                      //color: Colors.green,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:const EdgeInsets.only(right: 90.0,top: 5),
                            child: Text("FutSoll",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25)),
                          ),
                          Padding(
                              padding:const EdgeInsets.only(left: 10.0,top: 5),
                              child: Row(
                                children: [
                                  Container(
                                      height: 25,
                                      width: 25,
                                      // color: Colors.yellow,
                                      child:  const Icon(
                                        Icons.location_on_rounded,
                                        color: Colors.black,
                                        size: 20.0,
                                      )
                                  ),
                                  Text("defense ",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                              )
                          ),
                          Container(
                            height: 11,
                          ),
                          Padding(
                              padding:const EdgeInsets.only(left: 10.0,top: 5),
                              child: Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 45,
                                    //color: Colors.green,
                                    child: Column(
                                      children: const <Widget>[
                                        Icon(
                                          Icons.calendar_month,
                                          color: Colors.grey,
                                          size: 30.0,
                                        ),
                                        Text("22/dec",
                                            style: TextStyle(
                                                fontSize: 12)),
                                      ],
                                    ),

                                  ),
                                  Container(
                                    height: 50,
                                    width: 45,
                                    //color: Colors.green,
                                    child: Column(
                                      children: const <Widget>[
                                        Icon(
                                          Icons.timer,
                                          color: Colors.black,
                                          size: 30.0,
                                        ),
                                        Text("5:44p",
                                            style: TextStyle(
                                                fontSize: 12)),
                                      ],
                                    ),

                                  ),
                                  Container(
                                    height: 50,
                                    width: 45,
                                    //color: Colors.green,
                                    child: Column(
                                      children: const <Widget>[
                                        Icon(
                                          Icons.person,
                                          color: Colors.black,
                                          size: 30.0,
                                        ),
                                        Text("35",
                                            style: TextStyle(
                                                fontSize: 12)),
                                      ],
                                    ),

                                  ),
                                  Container(
                                    height: 50,
                                    width: 45,
                                    //color: Colors.green,
                                    child: Column(
                                      children: const <Widget>[
                                        Icon(
                                          Icons.person_add,
                                          color: Colors.green,
                                          size: 30.0,
                                        ),
                                        Text("5",
                                            style: TextStyle(
                                                fontSize: 12)),
                                      ],
                                    ),

                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: Container(
                        height: 150,
                        width: 25,
                        color: Colors.green,
                        child: Column(
                          children: const [
                            Text("A",style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                            Text("P",style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                            Text("P",style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                            Text("L",style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                            Text("Y",style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                          ],
                        ),
                      ),
                      onTap: (){
                        print("button pressed : ${i!}");
                      },
                    )
                  ],
                ),
              )
            ]
          ],
        )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
