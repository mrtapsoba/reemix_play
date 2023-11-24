class StoryTile {
  
  final String id; final String user;
  final String type; final String contenu;
  final String date; final String image; final String back;

  StoryTile({this.id, this.user, this.back, this.type, this.contenu, this.date, this.image});

  factory StoryTile.getStory(Map<String, dynamic> json) {

    return StoryTile(
      id: json['id'], user: json['iduser'],
      type: json['type'], contenu: json['contenu'],
      date: json['date'], image: json['image'],
      back: json['back'],
    );

  }
}

class StoryMan {
  final String man; final String image; final String id;
  StoryMan({this.id, this.man, this.image});
  factory StoryMan.myMen(Map<String, dynamic> json) {
    return StoryMan(
      id: json['id'], man: json['nom'], image: json['image'],
    );
  }
}