class VideoInfo {

  final String id;
  final String image;
  final String titre;
  final String sharer;
  final String artiste;
  final String youtube;
  final String date;

  VideoInfo({this.image, this.titre, this.sharer,
  this.artiste, this.youtube, this.id, this.date});
  
  factory VideoInfo.convert(Map<String, dynamic> json){
    return VideoInfo(
      image: json['imageson'], titre: json['titre'], id: json['id'],
       sharer: json['idshare'], 
      artiste: json['artiste'], youtube: json['youtube'], date: json['date'],
    );
  }
  
}