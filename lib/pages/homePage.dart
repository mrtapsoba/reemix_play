import 'package:flutter/material.dart';
import '../chat/newDiscute.dart';
import '../main.dart';
import '../pages/chatting.dart';
import '../pages/musicPage.dart';
import '../pages/profile.dart';
import '../pages/videoYT.dart';
import '../sqflite/clientP.dart';
import '../sqflite/creatingDB.dart';

class AccueilPage extends StatefulWidget {
  @override
  _AccueilPageState createState() => _AccueilPageState();
  final ClientMoi clientMoi;
  AccueilPage({this.clientMoi});
}

class _AccueilPageState extends State<AccueilPage> {

  int indexPage=1;

  @override
  Widget build(BuildContext context) {

    final thePages = <Widget>[
      VideoHome(clientMoi: widget.clientMoi,),
      MusicLoad(clientMoi: widget.clientMoi,),
      ChattingHome(clientMoi: widget.clientMoi,),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        title: Text("R69M!X - Musique en ligne",style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.notifications, color: Colors.black), onPressed: (){
            
          }),
          IconButton(icon: Icon(Icons.search, color: Colors.black), onPressed: (){
            Navigator.push(context,
            MaterialPageRoute(builder: (context)=> NewDiscute(user: widget.clientMoi.identifiant,) ));
          })
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("R69MIX Play"),
              accountEmail: Text("info@reemix.com"),
              currentAccountPicture: CircleAvatar(
                child: Text("69",style: TextStyle(fontSize: 50,color: Colors.black)),
                backgroundColor: Colors.white,
              ),
            ),
            ListTile(
              leading: Icon(Icons.video_label),
              title: Text("R69M!X TV"),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> thePages[0]));
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text("Discussions"),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> thePages[2]));
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(widget.clientMoi.pseudo),
              subtitle: Text(widget.clientMoi.nom),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage(user: "${widget.clientMoi.identifiant}", me: "${widget.clientMoi.identifiant}",)));
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("Besoin de nous"),
              onTap: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context)=> thePages[2]));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Deconnexion"),
              onTap: (){
                R69MIXDB.r69mixDB.delConnect(widget.clientMoi.identifiant);
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context)=> MyHomePage()));
              },
            ),
            ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (Rect taps){
                return RadialGradient(
                  center: Alignment.bottomLeft,
                  radius: 2.5,
                  colors: <Color>[
                    Color.fromRGBO(0, 0, 0, 1),
                    Colors.orange,
                    Color.fromRGBO(255, 215, 0, 1),
                  ]
                ).createShader(taps);
              },
              child: ListTile(
                leading: Text("Powered by"),
                title: Text("TAPS FAMILY",style: TextStyle(fontSize: 17.5)),
                onTap: (){
                  
                }
              )
            )
          ]
        )
      ),
      body: thePages[indexPage],
    );
  }
}