import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../classed/musicClass.dart';

class Playlist {
  
  final String homeUrl= "http://store.yj.fr/wwwreemixcom/playlist/playlist.php";

  Future<List<SonInfo>> receivePlaylist(String id,String password) async{
    http.Response reponse= await http.post(
      Uri.parse(homeUrl),
      body: {"id": id, "password": password},
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);

      List<SonInfo> connects = corps.map((dynamic item) => SonInfo.info(item)).toList();

      return connects;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }
  }
}
