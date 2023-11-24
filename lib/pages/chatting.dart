import 'package:flutter/material.dart';
import '../chat/chatPage.dart';
import '../chat/discuteList.dart';
import '../chat/messages.dart';
import '../chat/newDiscute.dart';
import '../chat/storyTile.dart';
import '../main.dart';
import '../pages/profile.dart';
import '../pages/statutStory.dart';
import '../pages/videoYT.dart';
import '../sqflite/clientP.dart';
import '../sqflite/creatingDB.dart';

class ChattingHome extends StatefulWidget {
  final ClientMoi clientMoi;
  ChattingHome({this.clientMoi});
  @override
  _ChattingHomeState createState() => _ChattingHomeState();
}

class _ChattingHomeState extends State<ChattingHome> {

  int cpt=0;

  MSG msg = MSG();
  List<Discussion> allmsg;
  Future<List<Discussion>> chargement;

  // test de stream 
  final Stream<int> periodique = Stream.periodic(Duration(milliseconds: 7500), (i)=>i);
  final Stream<int> periodiqueS = Stream.periodic(Duration(milliseconds: 2000), (j)=>j);
  int ancienStream= 0;

  @override
  void initState() {

    setState(() {
      chargement= msg.discussionList(widget.clientMoi.identifiant);
    });
     
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        elevation: 0,
        title: Text("R69M!X Discussion"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 85.0,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only()
            ),
            child: StreamBuilder(
              stream: this.periodiqueS,
              builder: (context, snapshotx){
                if (snapshotx.hasData) {
                    return FutureBuilder(
                      future: msg.storyList(widget.clientMoi.identifiant),
                      builder: (contextS, snapshotS){
                        if (snapshotS.hasError) {
                          print(snapshotS.error);
                        }
                        if (snapshotS.hasData) {
                          print("${snapshotS.data.length}");
                          List<StoryMan> story = snapshotS.data;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: story.length + 1,
                            itemBuilder: (contextL, int iy) {
                              if (iy ==0) {
                                return StatutIcon(id: widget.clientMoi.identifiant, man: StoryMan(id: "${widget.clientMoi.identifiant}",
                                man: "${widget.clientMoi.pseudo}", image: "drapeau.png"),);
                              }
                              StoryMan one = story[iy - 1];
                              return StatutIcon(id: widget.clientMoi.identifiant, man: one,);
                            }
                          );
                        }
                        return CircularProgressIndicator();
                      }
                    );
                }
                return CircularProgressIndicator();
              }
            )
          ),
          Container(
            height: 550,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)
              )
            ),
            child: StreamBuilder(
              stream: this.periodique,
              builder: (context, snapshot){
                if (snapshot.hasData) {
                  if (ancienStream!=snapshot.data) {
                    chargement= msg.discussionList(widget.clientMoi.identifiant);
                    ancienStream = snapshot.data;
                  return FutureBuilder(
                    future: chargement,
                    builder: (BuildContext context3, AsyncSnapshot<List<Discussion>> snapshot3){
                      if(snapshot3.hasError){
                        print(snapshot3.error);
                      }
                      if (snapshot3.hasData) {
                        List<Discussion> chats= snapshot3.data;
                        allmsg = chats;
                        return ListView.builder(
                          itemCount: allmsg.length,
                          itemBuilder: (BuildContext context, int index){
                            return Card( child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage("http://store.yj.fr/wwwreemixcom/profile/"+allmsg[index].chatImage),
                              ),
                              title: Text(allmsg[index].chatName,style: TextStyle(color: Colors.white)),
                              subtitle: Text(allmsg[index].lastMsg,style: TextStyle(color: Colors.white)),
                              trailing: (allmsg[index].msgCount ==0) ? Text("") : Text("${allmsg[index].msgCount}", style: TextStyle(color: Colors.green),),
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context)=> ChatPage(discussion: allmsg[index],
                                  clientMoi: widget.clientMoi))
                                );
                              },
                            ));
                          }
                        );
                      }
                      if (cpt==1 || allmsg==null) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                        itemCount: allmsg.length,
                        itemBuilder: (BuildContext context, int index){
                          return Card( child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage("http://store.yj.fr/wwwreemixcom/profile/"+allmsg[index].chatImage),
                            ),
                            title: Text(allmsg[index].chatName),
                            subtitle: Text(allmsg[index].lastMsg),
                            trailing: CircleAvatar(
                              child: Text("${allmsg[index].msgCount}", style: TextStyle(color: Colors.white),),
                              backgroundColor: Color.fromRGBO(0, 200, 0, 1),
                            ),
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=> ChatPage(discussion: allmsg[index],
                                clientMoi: widget.clientMoi))
                              );
                            },
                          ));
                        }
                      );
                    }
                  );
                  }
                }
                return Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("cover/back.jpg")),
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
              }
            ),
          ),
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
              leading: Icon(Icons.music_note),
              title: Text("Musique en ligne"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.video_label),
              title: Text("R69M!X TV"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> VideoHome(clientMoi: widget.clientMoi,)));
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add,color: Colors.black),
        onPressed: (){
          showModalBottomSheet(
            context: context,
            builder: (context){
              return Container(
                color: Colors.black,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50))
                  ),
                  child: Column(children: <Widget>[
                    SizedBox(height: 20.0,),
                    Center(
                      child: Container(
                        height: 4, width: 50, color: Colors.orange,
                      )
                    ),
                    SizedBox(height: 20.0,),
                    ListTile(
                      title: Text("Nouvelle Discussion",style: TextStyle(color: Colors.white)),
                      leading: Icon(Icons.message),
                      onTap: (){
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> NewDiscute(user: widget.clientMoi.identifiant,) ));
                      }
                    ),
                    SizedBox(height: 20.0,),
                    ListTile(
                      title: Text("Mettre un statu",style: TextStyle(color: Colors.white)),
                      leading: Icon(Icons.short_text),
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> PosteStatu(me: widget.clientMoi.identifiant))
                        );
                      }
                    ),
                    SizedBox(height: 20.0,),
                    ListTile(
                      title: Text("Poster une photo",style: TextStyle(color: Colors.white)),
                      leading: Icon(Icons.add_a_photo),
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> PosteImage(me: widget.clientMoi.identifiant))
                        );
                      }
                    ),
                    OutlinedButton.icon(
            onPressed: (){},
            icon: Icon(Icons.music_note),
            label: Text("R69MIX Play"),
            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.orange),
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),),
          ),
                    SizedBox(height: 10.0,),
                  ],)
                ),
              );
            }
          );
        },
      ),
    );
  }
}

class StatutIcon extends StatelessWidget {

  final int id;
  final StoryMan man;
  StatutIcon({this.id, this.man});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: Container(
        padding: EdgeInsets.all(3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
            width: 2.0,
            color: Colors.black,
          )
        ),
        child: Container(
          width: 54.0,
          height: 54.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange[800],
                Colors.black45,
              ]
            ),
            borderRadius: BorderRadius.circular(50.0),
            image: DecorationImage(
              image: NetworkImage("http://store.yj.fr/wwwreemixcom/profile/"+this.man.image),
              fit: BoxFit.cover,
            )
          ),
          child: GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatuStory(
                  id: this.id, man: this.man,
                )),
              );
            }
          ),
        ),
      ),
    );
  }
}