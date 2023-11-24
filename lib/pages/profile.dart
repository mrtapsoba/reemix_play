import 'package:flutter/material.dart';
import '../chat/messages.dart';
import '../chat/profileInfo.dart';

class ProfilePage extends StatefulWidget {
  final String user; final String chat; final String me; final String son;
  ProfilePage({
    this.user, this.chat, this.me, this.son,
  });
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Future<List<ProfileInfo>> profileInfo;
  ProfileHttp profileHttp = ProfileHttp();
  MSG send = MSG();
  TextEditingController msg = TextEditingController();

  @override
  void initState() {
    if (widget.user != null) {
      setState(() {
        profileInfo = profileHttp.fromUser(widget.user);
      });
    }else if (widget.chat != null) {
      setState(() {
        profileInfo = profileHttp.fromChatting(widget.chat, widget.me);
      });
    } else {
      setState(() {
      profileInfo = profileHttp.fromMusic(widget.son);
    });
    }
    
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Profile Utilisateur"),
      ),
      body: FutureBuilder(
        future: profileInfo,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (snapshot.hasData) {
            List<ProfileInfo> profiles = snapshot.data;
            ProfileInfo proMe = profiles[0];
            return ListView(
              children: <Widget>[
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.5,0.9],
                      colors: [
                        Colors.orange,
                        Colors.black,
                      ]
                    ),
                  ),child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          CircleAvatar(
                            child: IconButton(icon: Icon(Icons.link, size: 30, color: Colors.white,),
                              onPressed: (){
                                if(widget.me!=proMe.id){
                                send.following(widget.me, proMe.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Action (Ne plus) Suivre cliquer !"))
                                );
                                }
                              },),
                            minRadius: 30,
                            backgroundColor: Colors.black,
                          ),
                          CircleAvatar(
                            child: CircleAvatar(
                              minRadius: 50,
                              backgroundImage: NetworkImage("http://store.yj.fr/wwwreemixcom/profile/"+proMe.image),
                              child: (widget.me==proMe.id) ? IconButton(
                                icon: Icon(Icons.edit, color: Colors.orange, size: 30),
                                onPressed: (){
                                  
                                },
                              ) : null,
                            ),
                            minRadius: 60,
                            backgroundColor: Colors.white,
                          ),
                          CircleAvatar(
                            child: IconButton(icon: Icon(Icons.message, size: 30, color: Colors.white,),
                              onPressed: (){
                                if(widget.me!=proMe.id){
                                showDialog<String>(
                                  context: context,
                                  builder: (context)=> AlertDialog(
                                    title: Text("Message a "+proMe.pseudo),
                                    content: TextFormField(
                                      controller: msg,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.message),
                                        labelText: "Ecrire son message ..."
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text("Annuler"),
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        }
                                      ),
                                      TextButton(
                                        child: Text("Envoyer"),
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),
                                        onPressed: (){
                                          if (msg.text!="") {
                                            send.sendNewMessage("${widget.user}", proMe.id, msg.text);
                                            Navigator.pop(context);
                                          }
                                        }
                                      ),
                                    ]
                                  ),
                      
                                );
                                }
                              }),
                            minRadius: 30,
                            backgroundColor: Colors.orange,
                          ),
                        ]
                      ),
                      SizedBox(height: 10),
                      Text(proMe.pseudo, style: TextStyle(fontSize: 22, color: Colors.white),),
                      Text(proMe.nom, style: TextStyle(fontSize: 15, color: Colors.grey),)
                    ]
                  ),
                ),
                Container(
                  child: Row(children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          color: Colors.black,
                          child: ListTile(
                            title: Text(proMe.suiveur, textAlign: TextAlign.center, style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24
                            )),
                            subtitle: Text("Abonnés", textAlign: TextAlign.center, style: TextStyle( color: Colors.orange)),
                          )
                        ),
                      )
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          color: Colors.orange,
                          child: ListTile(
                            title: Text(proMe.suivi, textAlign: TextAlign.center, style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24
                            )),
                            subtitle: Text("Abonnement", textAlign: TextAlign.center, style: TextStyle( color: Colors.black)),
                          )
                        ),
                      )
                    ),
                  ],)
                ),
                Container(
                  child: Row(children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          color: Colors.orange,
                          child: ListTile(
                            title: Text(proMe.musique, textAlign: TextAlign.center, style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24
                            )),
                            subtitle: Text("Musiques", textAlign: TextAlign.center, style: TextStyle( color: Colors.black)),
                          )
                        ),
                      )
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          color: Colors.black,
                          child: ListTile(
                            title: Text(proMe.poste, textAlign: TextAlign.center, style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24
                            )),
                            subtitle: Text("Postes", textAlign: TextAlign.center, style: TextStyle( color: Colors.orange)),
                          )
                        ),
                      )
                    ),
                  ],)
                ),
                Card(
                  child: Text(proMe.bio, style: TextStyle( color: Colors.white, fontSize: 20)),
                ),
                ListTile(
                  leading: Icon(Icons.call),
                  title: Text("Phone :", style: TextStyle(color: Colors.orange, fontSize: 12)),
                  subtitle: Text("+226 "+proMe.phone, style: TextStyle( fontSize: 18)),
                ),
                ListTile(
                  leading: Icon(Icons.mail),
                  title: Text("Email :", style: TextStyle(color: Colors.orange, fontSize: 12)),
                  subtitle: Text(proMe.email, style: TextStyle( fontSize: 18)),
                ),
              ]
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
    );
  }
}