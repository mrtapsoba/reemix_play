import 'package:flutter/material.dart';
import '../https/videolist.dart';
import '../main.dart';
import '../pages/chatting.dart';
import '../pages/profile.dart';
import '../r69mixTV/oneVideo.dart';
import '../r69mixTV/videoClasse.dart';
import '../sqflite/clientP.dart';
import '../sqflite/creatingDB.dart';

class VideoHome extends StatefulWidget {
  final ClientMoi clientMoi;
  VideoHome({this.clientMoi});
  @override
  _VideoHomeState createState() => _VideoHomeState();
}

class _VideoHomeState extends State<VideoHome> {

  Videoslist videoslist = Videoslist();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: Text("R69M!X - TV"),
      ),
      body: FutureBuilder(
        future: videoslist.receiveVideolist(),
        builder: (context, snapshot){
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          
          if (snapshot.hasData) {
            List<VideoInfo> finalList = snapshot.data;
            return ListView.builder(
              itemCount: 1 + finalList.length,
              itemBuilder: (BuildContext context2, int index){
                if (index==0) {
                  return _buildProfileInfo();
                }
                VideoInfo video = finalList[index - 1];
                return _buildVideo(video);
              }
            );
          }
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("cover/back.jpg")),
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
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
              leading: Icon(Icons.music_note),
              title: Text("Musique en ligne"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text("Discussions"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ChattingHome(clientMoi: widget.clientMoi,)));
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
    );

  }


  _buildProfileInfo() {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: Offset(0, 1),
            blurRadius: 6.0,
          )
        ]
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 25.0,
            backgroundImage: AssetImage("cover/69.png"),
          ),
          SizedBox(width: 12.0,),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  "9.2.7 Empire",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    //fontWeight: FontWeight.w100,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Retrouver nous sur YT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    //fontWeight: FontWeight.w100,
                  ),
                ),
              ]
            )
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25.0,
            child: IconButton(
              icon: Icon(Icons.online_prediction, color: Colors.red),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> PlayVideo(
                  video: VideoInfo(image: "http://store.yj.fr/wwwreemixcom/live/image.png", titre: "Emission Live",
                  sharer: "", artiste: "Reemix Equipe", youtube: "", id: "", date: "Aujourd'hui"),
                  me: "${widget.clientMoi.identifiant}",isLive: true,
                )));
              }
            ),
          ),
        ],
      )
    );
  }

  _buildVideo(VideoInfo video) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> PlayVideo(
          video: video,
          me: "${widget.clientMoi.identifiant}",isLive: false,
        )));
      },
      child: Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      padding: EdgeInsets.all(10.0),
      height: 140.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white12,
            offset: Offset(0, 1),
            blurRadius: 6.0,
          )
        ]
      ),
      child: Row(
        children: <Widget>[
          Image(
            width: 150.0,
            image: NetworkImage("http://store.yj.fr/wwwreemixcom/image/"+video.image)
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  video.artiste+" "+video.titre,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  )
                ),
                Text(
                  "Partager par "+video.sharer,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  )
                ),
                Text(
                  "le "+video.date,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  )
                )
              ]
            )
          )
        ]
      ),
    ),
    );
  }
}