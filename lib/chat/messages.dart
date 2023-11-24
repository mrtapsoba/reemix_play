import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../chat/discuteList.dart';
import '../chat/msgList.dart';
import '../chat/storyTile.dart';

import 'package:path_provider/path_provider.dart';

class MSG {

  Future<List<Discussion>> discussionList(int id) async {

    http.Response reponse= await http.post(
      Uri.parse("http://store.yj.fr/wwwreemixcom/chatting/discussion.php"),
      body: {
        "iduser": "$id",
      }
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);

      List<Discussion> discussions = corps.map((dynamic item) => Discussion.getDiscussion(item)).toList();

      return discussions;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }

  }

  Future<List<Msg>> messagesList(String idchat, String user) async {

    http.Response reponse= await http.post(
      Uri.parse("http://store.yj.fr/wwwreemixcom/chatting/messages.php"),
      body: {
        "chatid": idchat, "user": user,
      }
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);

      List<Msg> discussions = corps.map((dynamic item) => Msg.getMsg(item)).toList();

      return discussions;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }

  }

  Future<List<Msg>> sendMessage(String idchat, String idUser, String contenu) async {

    http.Response reponse= await http.post(
      Uri.parse("http://store.yj.fr/wwwreemixcom/chatting/sendmsg.php"),
      body: {
        "chatid": idchat, "user": idUser, "message": contenu
      }
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);

      List<Msg> discussions = corps.map((dynamic item) => Msg.getMsg(item)).toList();

      return discussions;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }

  }

  Future<List<Msg>> sendNewMessage(String user, String receved, String message) async {

    http.Response reponse= await http.post(
      Uri.parse("http://store.yj.fr/wwwreemixcom/chatting/newdiscute.php"),
      body: {
        "user": user, "receved": receved, "message": message
      }
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);

      List<Msg> discussions = corps.map((dynamic item) => Msg.getMsg(item)).toList();

      return discussions;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }

  }

  Future<List<Msg>> following(suiveur, suivi) async {

    http.Response reponse= await http.post(
      Uri.parse("http://store.yj.fr/wwwreemixcom/profile/following.php"),
      body: {
        "suiveur": suiveur, "suivi": suivi
      }
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);

      List<Msg> discussions = corps.map((dynamic item) => Msg.getMsg(item)).toList();

      return discussions;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }

  }

  /////////
  Future<String> sendImage(String idchat, String idUser, String image, String fichier) async {

    http.Response reponse= await http.post(
      Uri.parse("http://store.yj.fr/wwwreemixcom/photo/telechargement.php"),
      body: {
        "image": image,
        "nom": fichier,
        "idchat": idchat, "iduser": idUser,
      }
    );
    print("en cours de telechargement");
    if(reponse.statusCode == 200){
      String resultat = reponse.body;
      print(resultat);
      return resultat;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }

  }

  Future<String> sendFile(String idchat, String idUser, String file, String nom) async {

    http.Response reponse= await http.post(
      
      Uri.parse("http://store.yj.fr/wwwreemixcom/fichier/telechargement.php"),
      body: {
        "fichier": file,
        "nom": nom,
        "idchat": idchat, "iduser": idUser,
      }
    );
    print("en cours de telechargement");
    if(reponse.statusCode == 200){
      String resultat = reponse.body;
      print(resultat);
      return resultat;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }

  }

  Future<File> downloadFile(String url, String filename) async {

    http.Client client = new http.Client();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;

}

  // le http des story h24
  Future<List<StoryMan>> storyList(int id) async {

    http.Response reponse= await http.post(
      
      Uri.parse("http://store.yj.fr/wwwreemixcom/stories/storylist.php"),
      body: {
        "iduser": "$id",
      }
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);

      List<StoryMan> men = corps.map((dynamic item) => StoryMan.myMen(item)).toList();

      return men;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }

  }

  Future<List<StoryTile>> oneStories(int id, String idSuivi) async {

    http.Response reponse= await http.post(
      Uri.parse("http://store.yj.fr/wwwreemixcom/stories/onestories.php"),
      body: {
        "iduser": "$id", "suivi": idSuivi,
      }
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);

      List<StoryTile> stories = corps.map((dynamic item) => StoryTile.getStory(item)).toList();

      return stories;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }

  }

  Future<List<StoryTile>> sendStatu(String idUser, String back, String contenu) async {

    http.Response reponse= await http.post(
      Uri.parse("http://store.yj.fr/wwwreemixcom/stories/sendstatu.php"),
      body: {
        "user": idUser, "message": contenu, "back": back
      }
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);

      List<StoryTile> discussions = corps.map((dynamic item) => StoryTile.getStory(item)).toList();

      return discussions;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }

  }

  Future<String> sendStory(String idUser, String back, String image, String fichier) async {

    http.Response reponse= await http.post(
      
      Uri.parse("http://store.yj.fr/wwwreemixcom/stories/telechargement.php"),
      body: {
        "image": image,
        "nom": fichier, "back": back,
        "iduser": idUser,
      }
    );
    print("en cours de telechargement");
    if(reponse.statusCode == 200){
      String resultat = reponse.body;
      print(resultat);
      return resultat;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }

  }

}