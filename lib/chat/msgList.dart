class Msg {
  final String id;
  final String idChat; final String idSend; final String type;
  final String contenu; final String date;
  final String supp;

  Msg({this.id, this.idChat, this.idSend, this.type,
  this.contenu, this.date, this.supp});

  factory Msg.getMsg(Map<String, dynamic> json){
    return Msg( id: json['id'],
      idChat: json['idchat'], idSend: json['idsend'],
      type: json['type'], contenu: json['contenu'],
      date: json['date'], supp: json['supp'],
    );
  }
}