import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class SendConnect {
  
  final String homeUrl= "http://store.yj.fr/wwwreemixcom/connecting/login.php";

  Future<List<Connect>> jeMeConnecte(String phone,String password) async{
    http.Response reponse= await http.post(
      Uri.parse(homeUrl),
      body: {"email": phone, "password": password},
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);

      List<Connect> connects = corps.map((dynamic item) => Connect.login(item)).toList();

      return connects;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }
  }

  Future<List<Connect>> jeMinscris(String noms,String telephone, String email, String pseudo, String bio, String password) async{
    http.Response reponse= await http.post(
      Uri.parse("http://store.yj.fr/wwwreemixcom/connecting/sign.php"),
      body: {"noms": noms, "phone": telephone, "email": email,
        "pseudo": pseudo, "bio": bio, "password": password},
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);

      List<Connect> connects = corps.map((dynamic item) => Connect.login(item)).toList();

      return connects;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }
  }
}

class Connect {
  int identifiant;
  String email;
  String password;
  String nom;
  String pseudo;
  int phone;
  int date;

  Connect({this.identifiant,this.password,this.nom,this.pseudo,this.email,this.phone,this.date});

  factory Connect.login(Map<String, dynamic> json){

    String fid = json['id'];
    int id = int.parse(fid);
    // *********************
    String fphone = json['phone'];
    int phone = int.parse(fphone);
    // *********************
    String fdate = json['time'];
    int date = int.parse(fdate);

    return Connect(
      identifiant: id, email: json['email'],
      password: json['password'], pseudo: json['pseudo'],
      nom: json['nom'],
      phone: phone, date: date,
    );
  }
}