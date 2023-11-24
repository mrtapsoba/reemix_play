class ClientMoi {
  final int identifiant;
  final String email;
  final String pseudo;
  final String password;
  final String nom;
  final int phone;
  final int date;

  ClientMoi({this.identifiant,this.email,this.pseudo,this.password,this.date,this.nom,this.phone});

  factory ClientMoi.sqflite(Map<String, dynamic> json){
    return ClientMoi(
      identifiant: json['identifiant'] as int,
      email: json['email'] as String,
      pseudo: json['pseudo'] as String,
      password: json['password'] as String,
      date: json['date'] as int,
      nom: json['nom'] as String,
      phone: json['phone'] as int,
    );
  }

}