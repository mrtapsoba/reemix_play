import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../r69mixTV/videoClasse.dart';

class Videoslist {
  
  final String homeUrl= "http://store.yj.fr/wwwreemixcom/playlist/videolist.php";

  Future<List<VideoInfo>> receiveVideolist() async{
    http.Response reponse= await http.post(
      Uri.parse(homeUrl),
      body: {"id": "1"},
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);
      
      List<VideoInfo> connects = corps.map((dynamic item) => VideoInfo.convert(item)).toList();
      
      return connects;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }
  }
}
