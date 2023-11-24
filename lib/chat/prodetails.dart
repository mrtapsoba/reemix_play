import 'package:flutter/material.dart';

class ProDetails extends StatefulWidget {
  @override
  _ProDetailsState createState() => _ProDetailsState();
}

class _ProDetailsState extends State<ProDetails> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nom d'utilisateur ..."),
        elevation: 0,
        bottom: TabBar(
          tabs: <Tab>[
            Tab(icon: Icon(Icons.group_add),),
            Tab(icon: Icon(Icons.person_add)),
            Tab(icon: Icon(Icons.music_note)),
            Tab(icon: Icon(Icons.image)),
          ]
        ),
      ),
      body: TabBarView(
        children: [
          Center(child: Icon(Icons.person, size: 70)),
          Center(child: Icon(Icons.person, size: 70)),
          Center(child: Icon(Icons.person, size: 70)),
          Center(child: Icon(Icons.person, size: 70)),
        ]
      )
    );
  }
}