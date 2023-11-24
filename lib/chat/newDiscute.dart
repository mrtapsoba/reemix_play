import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../chat/messages.dart';
import '../pages/profile.dart';
/*
class NewDiscute extends SearchDelegate<String> {

  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _history = [];
  allUser() async {
    http.Response reponse = await http.post(
      "",
      body: {
        
      }
    );
    if(reponse.statusCode == 200) {
      List<dynamic> resultats = jsonDecode(reponse.body);
      _users = resultats;
      return resultats;
    }
  }

  @override
  
  Widget buildLeading(BuildContext context){
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        this.close(context, null);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context){
    allUser();

    final Iterable<Map<String, dynamic>> suggestions = this.query.isEmpty ?
    _history : _users.where((word) => null);

    return SuggestionList(
      query: this.query,
      suggestions: null,
      onSelected: (String suggestion) {
        this.query = suggestion;
        showResults(context);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context){
    return <Widget>[
      query.isEmpty ? IconButton(icon: Icon(Icons.people_outline), onPressed: null)
      : IconButton(icon: Icon(Icons.clear), onPressed: (){
        query = ""; showSuggestions(context);
      })
    ];
  }
}

class SuggestionList extends StatelessWidget {

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;
  const SuggestionList({this.suggestions, this.query, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: TextStyle(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(text: suggestion.substring(query.length), )
              ]
            )
          ),
          onTap: (){
            onSelected(suggestion);
          },
        );
      }
    );
  }
}*/

class NewDiscute extends StatefulWidget {
  final int user;
  NewDiscute({this.user});
  @override
  _NewDiscuteState createState() => _NewDiscuteState();
}

class _NewDiscuteState extends State<NewDiscute> {

  Uhttp user = Uhttp();
  MSG send = MSG();
  TextEditingController msg = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Utilisateurs ...")),
      body: FutureBuilder(
        future: user.allUsers(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            print(snapshot.error);
          }
          if(snapshot.hasData){
            List<User> users = snapshot.data;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context2, int index) {
                return Card( child: ListTile(
                  leading: Image.network("http://store.yj.fr/wwwreemixcom/profile/"+users[index].image),
                  title: Text(users[index].pseudo, style: TextStyle(color: Colors.white)),
                  subtitle: Text(users[index].nom, style: TextStyle(color: Colors.white)),
                  onTap: () {
                    showDialog<String>(
                      context: context,
                      builder: (context)=> AlertDialog(
                        title: Text("Message a "+users[index].pseudo),
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
                            child: Text("Info +"),
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage(user: users[index].id, me: "${widget.user}",)));
                            }
                          ),
                          TextButton(
                            child: Text("Envoyer"),
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),
                            onPressed: (){
                              if (msg.text!="") {
                                send.sendNewMessage("${widget.user}", users[index].id, msg.text);
                                Navigator.pop(context);
                              }
                            }
                          ),
                        ]
                      ),
                      
                    );
                  }
                ));
              }
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      )
    );
  }
}

class User {
  final String id; final String nom; final String pseudo; final String image;
  User({this.id, this.nom, this.pseudo, this.image});
  factory User.getAll(Map<String, dynamic> json){
    return User(
      id: json['id'], nom: json['nom'], pseudo: json['pseudo'], image: json['image'],
    );
  }
}

class Uhttp {
  Future<List<User>> allUsers() async {
    http.Response reponse = await http.post(
      Uri.parse("http://store.yj.fr/wwwreemixcom/profile/allusers.php"),
      body: {
        "all": "all"
      }
    );

    if(reponse.statusCode == 200){
      List<dynamic> corps = jsonDecode(reponse.body);

      List<User> connects = corps.map((dynamic item) => User.getAll(item)).toList();

      return connects;
    }else{
      throw Exception("Erreur lors du chargement des comptes !!!");
    }
  }
}

