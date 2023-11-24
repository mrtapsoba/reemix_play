
class SonInfo {
  String id; String artiste;
  String imageSon; String titre; String fichierMP3;
  String youtube; String liked; String likeCount;
  String streamCount; String shareId; String date;
  /* nouveau */ String ifAlbum;

  SonInfo({
    this.id, this.artiste, this.imageSon,
    this.titre, this.fichierMP3, this.youtube, this.liked,
    this.likeCount, this.streamCount,this.shareId, this.date,
    this.ifAlbum
  });

  factory SonInfo.info(Map<String, dynamic> json){
    return SonInfo(
      id: json['id'], artiste: json['artiste'],
      imageSon: json['imageson'], titre: json['titre'], fichierMP3: json['fichier'],
      youtube: json['youtube'], liked: json['liked'], likeCount: json['likedcount'],
      streamCount: json['streamcount'], shareId: json['idshare'], date: json['date'],
      ifAlbum: json['ifalbum'],
    );
  }
}