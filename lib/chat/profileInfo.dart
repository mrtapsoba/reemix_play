import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ProfileInfo {
  final String id; final String email; final String pseudo;
  final String nom; final String image; final String phone;
  final String bio; final String suiveur; final String suivi;
  final String musique; final String poste; final String date;

  ProfileInfo({this.id, this.email, this.pseudo, this.nom,
  this.image, this.phone, this.bio, this.suiveur, this.suivi,
  this.musique, this.poste, this.date});

  factory ProfileInfo.getProfile(Map<String, dynamic> item){

    return ProfileInfo(
      id: item['id'], email: item['email'], pseudo: item['pseudo'],
      nom: item['nom'], image: item['image'], phone: item['phone'],
      bio: item['bio'], suiveur: item['suiveur'], suivi: item['suivi'],
      musique: item['musique'],poste: item['poste'], date: item['date'],
    );
  }
}

class ProfileHttp {
  
  final String homeUrl= "http://store.yj.fr/wwwreemixcom/profile/userinfo.php";

  Future<List<ProfileInfo>> fromUser(String id) async{
    http.Response reponse= await http.post(
      Uri.parse(homeUrl),
      body: {"user": id,},
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);

      List<ProfileInfo> profiles = corps.map((dynamic item) => ProfileInfo.getProfile(item)).toList();

      return profiles;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }
  }

  Future<List<ProfileInfo>> fromChatting(String idChat, String me) async{
    http.Response reponse= await http.post(
      Uri.parse(homeUrl),
      body: {"chat": idChat, "me": me},
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);

      List<ProfileInfo> profiles = corps.map((dynamic item) => ProfileInfo.getProfile(item)).toList();

      return profiles;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }
  }

  Future<List<ProfileInfo>> fromMusic(String idSon) async{
    http.Response reponse= await http.post(
      Uri.parse(homeUrl),
      body: {"son": idSon,},
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);

      List<ProfileInfo> profiles = corps.map((dynamic item) => ProfileInfo.getProfile(item)).toList();

      return profiles;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }
  }

}