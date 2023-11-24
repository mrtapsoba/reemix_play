import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../chat/discuteList.dart';
import '../chat/messages.dart';
import '../chat/msgList.dart';
import '../pages/profile.dart';
import '../sqflite/clientP.dart';

class ChatPage extends StatefulWidget {
  final Discussion discussion;
  final ClientMoi clientMoi;
  ChatPage({this.discussion, this.clientMoi});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  //
  File image;
  String statu = "";
  String error = "Erreur de telechargement de l'image !";
  String base69Image;
  MSG _msg = MSG();
  int compte=0;
  final picker = ImagePicker();

  choisirGalery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile!= null) {
        image = File(pickedFile.path);
        base69Image = base64Encode(image.readAsBytesSync());
      } else {
        print("pas d'image selectionnee");
      }
    });
  }

  prendrePhoto() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile!= null) {
        image = File(pickedFile.path);
        base69Image = base64Encode(image.readAsBytesSync());
      } else {
        print("pas d'image selectionnee");
      }
    });
  }

  setStatus(String message) {
    setState(() {
      statu = message;
    });
  }

  startUpload() {
    setStatus("Telechargement de l'image ...");
    if (null == image) {
      setStatus(error);
      return;
    }
    String fichier = image.path.split('/').last;
    
    _msg.sendImage("${widget.discussion.idChat}", "${widget.clientMoi.identifiant}", base69Image, fichier);

    setState(() {
      image = null;
    });
  }

  Widget showImage() {
    return (image != null) ?
      
      Expanded(
        child: Container(
          margin: const EdgeInsets.fromLTRB(50, 5, 50, 5),
          height: 700,
          width: 700,
          decoration: BoxDecoration(
            color: Colors.white12,
            image: DecorationImage(
              image: FileImage(image),
            )
          ),
          child: Column(
            children: <Widget>[
              Text(statu),
              TextButton(
                child: Text("ANNULER..."),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white12),foregroundColor: MaterialStateProperty.all(Colors.white12)),
                onPressed: (){
                  setState(() {
                    image = null;
                  });
                }
              ),
            ]
          )
        )
      )
     : Container(
        color: Colors.black12,
        height: 70.0,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle, color: Colors.orange),
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
                            title: Text("Camera",style: TextStyle(color: Colors.white)),
                            leading: Icon(Icons.photo_camera),
                            onTap: (){
                              Navigator.pop(context);
                              prendrePhoto();
                            }
                          ),
                          SizedBox(height: 20.0,),
                          ListTile(
                            title: Text("Bibliotheque Photo",style: TextStyle(color: Colors.white)),
                            leading: Icon(Icons.image),
                            onTap: (){
                              Navigator.pop(context);
                              choisirGalery();
                            }
                          ),
                          SizedBox(height: 20.0,),
                          ListTile(
                            title: Text("Documents",style: TextStyle(color: Colors.white)),
                            leading: Icon(Icons.insert_drive_file),
                            onTap: null
                          ),
                          SizedBox(height: 20.0,),
                          ListTile(
                            title: Text("Appel video",style: TextStyle(color: Colors.white)),
                            leading: Icon(Icons.video_call),
                            onTap: null
                          ),
                          SizedBox(height: 10.0,),
                        ],)
                      ),
                    );
                  }
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 1.0, 4.0, 1.0),
                child: Material(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey.withOpacity(0.2),
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: TextFormField(
                      controller: _msgTextController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: "Envoyer message",
                        hintText: "Entrer votre message a envoye",
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  )
                ),
              ),
            ),
          ]
        )
      );
  }
  List<Msg> messages= [];
  TextEditingController _msgTextController = TextEditingController();
  //

  Future<List<Msg>> chargementM;
  // test de stream 
  final Stream<int> periodique2 = Stream.periodic(Duration(milliseconds: 3000), (i)=>i);
  String ancienStream= "0";

  @override
  void initState() {
    setState(() {
      chargementM= _msg.messagesList(widget.discussion.idChat, "${widget.clientMoi.identifiant}");
    });
    super.initState();
    
  }

  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        elevation: 0,
        title: GestureDetector(child: Text(widget.discussion.chatName+" ..."),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(chat: widget.discussion.idChat,me: "${widget.clientMoi.identifiant}",)),
            );
          }
        ),
        actions: <Widget>[
          GestureDetector(child: CircleAvatar(backgroundImage: NetworkImage("http://store.yj.fr/wwwreemixcom/profile/"+widget.discussion.chatImage),),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(chat: widget.discussion.idChat,me: "${widget.clientMoi.identifiant}",)),
            );
          },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream: this.periodique2,
            builder: (context2, snapshot2){
              if (snapshot2.hasData) {
                chargementM= _msg.messagesList(widget.discussion.idChat, "${widget.clientMoi.identifiant}");
                return FutureBuilder(
                  future: chargementM,
                  builder: (context, snapshot){
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    }
                    if (snapshot.hasData) {
                      messages = snapshot.data;

                      return Flexible( child: ListView.builder(
                        itemCount: messages.length,
                        reverse: true,
                        itemBuilder: (BuildContext context, int index){

                          return _buildMessages(messages[index]);
                        }
                      ));
                    }
                    return Expanded(child: Center(child: Text("Chargement des messages ...")));
                  }
                );
              }
              return Expanded(child: Center(child: Text("Chargement des messages ...")));
            }
          ),
          SizedBox(height: 5.0),
          showImage(),
          
        ]
      ),
      floatingActionButton: IconButton(
        color: Colors.orange,
        icon: Icon(Icons.send,),
        onPressed: (){
          setState(() {
            if (image == null) {
              if (_msgTextController.text.isNotEmpty) {
                _msg.sendMessage(widget.discussion.idChat, "${widget.clientMoi.identifiant}", _msgTextController.text);
                _msgTextController.text= "";
              }
            } else {
              startUpload();
            }
          });
          
        }
      ),
    );
  }
  
  _buildMessages(Msg message){
    return Padding(
      padding: EdgeInsets.only(
        top: 10.0,
        left: (message.idSend =="${widget.clientMoi.identifiant}") ? 65 : 10,
        right: (message.idSend =="${widget.clientMoi.identifiant}") ? 10 : 65,
      ),
      child: GestureDetector(child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: (message.idSend =="${widget.clientMoi.identifiant}")
            ? Colors.orange.withOpacity(0.95)
            : Colors.grey.withOpacity(0.8),
          //borderRadius: BorderRadius.circular(10.0),
          borderRadius: (message.idSend =="${widget.clientMoi.identifiant}")
            ? BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(0))
            : BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(30)),
        ),
        child: Column(
          children: <Widget>[
            message.supp!="0" ? Text("message supprime")
            : (message.type=="text" 
              ? Text(message.contenu, style: TextStyle(color: Colors.white, fontSize: 17.0),)
              : Image.network("http://store.yj.fr/wwwreemixcom/photo/"+message.contenu)
            ),
            (message.type=="text" 
              ? SizedBox(height: 0, width: 0)
              : IconButton(
                icon: Icon(Icons.file_download),
                onPressed: () {
                  showDialog(context: context,
                  builder: (context)=> AlertDialog(
                    title: Text("Telechargement de l'image"),
                    content: FutureBuilder(
                      future: _msg.downloadFile("http://store.yj.fr/wwwreemixcom/photo/"+message.contenu, "reemixImage"+message.contenu),
                      builder: (context, snapshot){
                        if (snapshot.hasError) {
                          print(snapshot.error);
                        }
                        if (snapshot.hasData) {
                          return Image.file(snapshot.data);
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                  ));
                  
                }
              )
            )
            //: Text(message.contenu, style: TextStyle(color: Colors.white, fontSize: 17.0),),
          ],
        )
      ),
      onLongPress: (){

      },
      ),
    );
  }

}