import 'package:flutter/material.dart';
import '../https/login.dart';
import '../main.dart';
import '../sqflite/creatingDB.dart';

class Authentification extends StatefulWidget {
  @override
  _AuthentificationState createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {

  bool formVisible;
  int _formsIndex;
  
  @override
  void initState(){
    super.initState();
    formVisible = false;
    _formsIndex = 1;
  }

  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("cover/back.jpg"),
            fit: BoxFit.cover,
          )
        ),
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.black54,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 125,),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Bienvenue !",
                          style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                        ),
                        Text(
                          " Ecouter et partager de la musique, regarder des videos et discuter avec vos artistes et amis !",
                          style: TextStyle(color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                        ),
                      ]
                    )
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 15),
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),)),
                          ),
                          child: Text("Connexion"),
                          onPressed: (){
                            setState((){
                              formVisible = true;
                              _formsIndex = 1;
                            });
                          }
                        )
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),)),
                          ),
                          child: Text("Inscription"),
                          onPressed: (){
                            setState((){
                              formVisible = true;
                              _formsIndex = 2;
                            });
                          }
                        )
                      ),
                      SizedBox(width: 15),
                    ]
                  ),
                  OutlinedButton.icon(
                    onPressed: (){},
                    icon: Icon(Icons.music_note),
                    label: Text("R69MIX Play"),
                    style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.orange),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),),
                  ),
                  SizedBox(height: 20.0),
                ]
              )
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 250),
              child: (!formVisible)
              ? null
              : Container(
                color: Colors.black54,
                alignment: Alignment.center,
                child: Column(mainAxisSize: MainAxisSize.min,children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(_formsIndex == 1 ?
                        Colors.orange : Colors.white,),
                        foregroundColor: MaterialStateProperty.all(_formsIndex == 1 ?
                        Colors.white : Colors.orange,),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),)),
                        ),
                        child: Text("Connexion"),
                        onPressed: (){
                          setState(() {
                            _formsIndex = 1;
                          });
                        }
                      ),
                      SizedBox(width: 10),
                      TextButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(_formsIndex == 2 ?
                        Colors.orange : Colors.white,),
                        foregroundColor: MaterialStateProperty.all(_formsIndex == 2 ?
                        Colors.white : Colors.orange,),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),)),
                        ),
                        child: Text("Inscription"),
                        onPressed: (){
                          setState(() {
                            _formsIndex = 2;
                          });
                        }
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.close),
                        color: Colors.red,
                        onPressed: (){
                          setState(() {
                            formVisible = false;
                          });
                        }
                      ),
                    ]
                  ),
                  Container(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _formsIndex == 1
                      ? Connexion() : Inscription(),
                    )
                  )
                ],)
              ),
            )
          ]
        )
      )
    );

  }
}

class Connexion extends StatefulWidget {
  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {

  TextEditingController _phoneTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white70,borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            controller: _phoneTextController,
            decoration: InputDecoration(
              labelText: "Telephone ou Email ...",
              border: OutlineInputBorder(),
              icon: Icon(Icons.short_text),
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _passwordTextController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Mot de passe",
              border: OutlineInputBorder(),
              icon: Icon(Icons.lock),
            ),
          ),
          SizedBox(height: 10.0),
          TextButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),)),
            ),
            child: Text("Connexion"),
            onPressed: (){
              if (_phoneTextController.text!="" && _passwordTextController.text!="") {
                Navigator.push(context,
                MaterialPageRoute(builder: (context)=> Chargement(
                  phone: _phoneTextController.text,
                  password: _passwordTextController.text,
                )));
              }
            }
          )
        ]
      ),
    );
  }
}
class Inscription extends StatefulWidget {
  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {

  TextEditingController noms = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pseudo = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController pass1 = TextEditingController();
  TextEditingController pass2 = TextEditingController();

  SendConnect connect = SendConnect();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 600,
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white70,borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            controller: noms,
            decoration: InputDecoration(
              labelText: "Nom & Prenoms",
              border: OutlineInputBorder(),
              icon: Icon(Icons.person),
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: phone,
            decoration: InputDecoration(
              labelText: "Telephone",
              border: OutlineInputBorder(),
              icon: Icon(Icons.phone),
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: email,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
              icon: Icon(Icons.mail_outline),
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: pseudo,
            decoration: InputDecoration(
              labelText: "Pseudo / Surnom",
              border: OutlineInputBorder(),
              icon: Icon(Icons.account_circle_outlined),
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: bio,
            decoration: InputDecoration(
              labelText: "Biographie",
              border: OutlineInputBorder(),
              icon: Icon(Icons.textsms),
            ),
            maxLines: 2,
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: pass1,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Mot de passe",
              border: OutlineInputBorder(),
              icon: Icon(Icons.lock),
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: pass2,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Mot de passe (Repeter)",
              border: OutlineInputBorder(),
              icon: Icon(Icons.lock_outline),
            ),
          ),
          SizedBox(height: 10.0),
          TextButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),)),
            ),
            child: Text("Inscription"),
            onPressed: (){
              if (noms.text!="" && phone.text!="" && pseudo.text!="" && bio.text!="" && pass1.text!="") {
                if (pass1.text==pass2.text) {
                  connect.jeMinscris(noms.text, phone.text, email.text, pseudo.text, bio.text, pass1.text);
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> Chargement(
                    phone: phone.text,
                    password: pass1.text,
                  )));
                }
              }
            }
          )
        ]
      ),
    );
  }
}

class Chargement extends StatefulWidget {
  final String phone;
  final String password;
  Chargement({this.phone, this.password});

  @override
  _ChargementState createState() => _ChargementState();
}

class _ChargementState extends State<Chargement> {
  SendConnect connect = SendConnect();

  @override
  void initState(){
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: connect.jeMeConnecte(widget.phone, widget.password),
        builder: (context, snapshot){
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (snapshot.hasData) {
            List<Connect> liste = snapshot.data;
            if (liste.length ==0) {
              return Center(child: Text("Veuillez verifier vos identifiants ou nous contacter car aucun compte n'est retrouve"));
            }
            if (liste.length==1) {
              Connect compte = liste[0];
              compte.password = widget.password;
              R69MIXDB.r69mixDB.insertConnect(compte);
              return MyHomePage();
            }else {
              return Center(child: Text("Plusieurs compte possede les memes identifiants veuillez nous contacter"));
            }
          }
          return Center(child: CircularProgressIndicator(),);
        },
      )
    );
  }
}