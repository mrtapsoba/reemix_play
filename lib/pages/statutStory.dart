import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../chat/messages.dart';
import '../chat/storyTile.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

class StatuStory extends StatelessWidget {
  final int id;
  final StoryMan man;
  StatuStory({this.id, this.man});

  MSG _msg = MSG();

  @override
  Widget build(BuildContext context) {
    final controller = StoryController();
    List<StoryItem> storyStatu = [];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: Text(this.man.man + "..."),
      ),
      body: FutureBuilder(
          future: _msg.oneStories(this.id, this.man.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            if (snapshot.hasData) {
              List<StoryTile> stories = snapshot.data;
              for (var i = 0; i < stories.length; i++) {
                if (stories[i].type == "text") {
                  storyStatu.add(StoryItem.text(
                      title: stories[i].contenu,
                      backgroundColor: (stories[i].back == "black"
                          ? Colors.black
                          : (stories[i].back == "red"
                              ? Colors.red
                              : (stories[i].back == "blue"
                                  ? Colors.blue
                                  : Colors.green)))));
                } else {
                  if (stories[i].type == "image") {
                    storyStatu.add(StoryItem.pageImage(
                        url: "http://store.yj.fr/wwwreemixcom/stories/" +
                            stories[i].contenu,
                        controller: controller,
                        caption: stories[i].back));
                  } else {
                    storyStatu.add(StoryItem.pageVideo(
                        "http://store.yj.fr/wwwreemixcom/stories/" +
                            stories[i].contenu,
                        controller: controller,
                        caption: stories[i].back));
                  }
                }
              }
              return StoryView(
                storyItems: storyStatu,
                controller: controller,
                inline: false,
                repeat: false,
                onComplete: () {
                  Navigator.pop(context, "next");
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class PosteStatu extends StatefulWidget {
  final int me;
  PosteStatu({this.me});
  @override
  _PosteStatuState createState() => _PosteStatuState();
}

class _PosteStatuState extends State<PosteStatu> {
  String colorS = "";
  Color colorR = Colors.black;

  TextEditingController statuText = TextEditingController();
  MSG _msg = MSG();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorR,
      appBar: AppBar(
        title: Text("Ecrire votre statu"),
      ),
      body: Container(
          child: ListView(children: <Widget>[
        TextFormField(
            style: TextStyle(color: Colors.white, fontSize: 20),
            controller: statuText,
            decoration: InputDecoration(
              labelText: "Veuillez saisir votre texte",
            ),
            maxLines: 10),
        Card(
            child: Row(children: <Widget>[
          Expanded(
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)),
                child: Text(
                  "Noir",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    colorS = "black";
                    colorR = Colors.black;
                  });
                }),
          ),
          Expanded(
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                child: Text(
                  "Rouge",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    colorS = "red";
                    colorR = Colors.red;
                  });
                }),
          ),
          Expanded(
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                child: Text(
                  "bleue",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    colorS = "blue";
                    colorR = Colors.blue;
                  });
                }),
          ),
          Expanded(
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
                child: Text(
                  "Vert",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    colorS = "green";
                    colorR = Colors.green;
                  });
                }),
          ),
        ])),
        TextButton(
            child: Text("Envoyer"),
            onPressed: () {
              if (statuText.text != "") {
                _msg.sendStatu("${widget.me}", colorS, statuText.text);
                Navigator.pop(context);
              }
            })
      ])),
    );
  }
}

class PosteImage extends StatefulWidget {
  final int me;
  PosteImage({this.me});
  @override
  _PosteImageState createState() => _PosteImageState();
}

class _PosteImageState extends State<PosteImage> {
  File image;
  String statu = "";
  String error = "Erreur de telechargement de l'image !";
  String base69Image;
  TextEditingController statuText = TextEditingController();
  MSG _msg = MSG();
  final picker = ImagePicker();

  choisirGalery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
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
      if (pickedFile != null) {
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

    _msg.sendStory("${widget.me}", statuText.text, base69Image, fichier);

    setState(() {
      image = null;
    });
  }

  Widget showImage() {
    return (image != null)
        ? Flexible(
            child: Image.file(image),
          )
        : Text("Aucune image selectionnée");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image a poster ..."),
      ),
      body: Container(
          child: ListView(children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  prendrePhoto();
                }),
            IconButton(
                icon: Icon(Icons.image),
                onPressed: () {
                  choisirGalery();
                }),
          ],
        ),
        showImage(),
        TextFormField(
            controller: statuText,
            decoration: InputDecoration(
              labelText: "Veuillez saisir votre texte",
            ),
            maxLines: 2),
        TextButton(
            child: Text("Envoyer"),
            onPressed: () {
              if (image != null) {
                startUpload();
                Navigator.pop(context);
              }
            })
      ])),
    );
  }
}
