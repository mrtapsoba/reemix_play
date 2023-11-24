class PArticle {
  final int id;
  final String nom;
  final String marque;
  final int idstockage;
  final int disponibilite;
  final int quantite;
  final int date;
  final String image;
  final int prix;

  PArticle({this.id,this.nom,this.marque,
  this.idstockage,this.disponibilite,this.quantite,this.date,this.image,this.prix});

  factory PArticle.fromMap(Map<String, dynamic> json){
    return PArticle(
      id: json['id'] as int,
      nom: json['nom'] as String,
      marque: json['marque'] as String,
      idstockage: json['idstockage'] as int,
      disponibilite: json['disponibilite'] as int,
      quantite: json['quantite'] as int,
      date: json['date'] as int,
      image: json['image'] as String,
      prix: json['prix'] as int,
    );
  }

}
