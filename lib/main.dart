import 'package:flutter/material.dart';
import './sqflite/creatingDB.dart';
import './sqflite/clientP.dart';
import './pages/connection.dart';
import './pages/homePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REEMIX Play',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        backgroundColor: Colors.black87,
        cardColor: Colors.white12,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'REEMIX Play'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: R69MIXDB.r69mixDB.user(),
      builder: (BuildContext context, AsyncSnapshot<List<ClientMoi>> snapshot){
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (snapshot.hasData) {
          List<ClientMoi> lesInfo = snapshot.data;
          if (lesInfo.length==1) {
            return Authentification(); // pour la page d'inscription //
          }
          final mesInfo = lesInfo[1];
          return AccueilPage(clientMoi: mesInfo); // pour la page playing R69MIX //
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ))
          )
        );
      }
    );
  }
}
