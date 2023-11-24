class Discussion {
  final String idChat; final String chatImage;
  final String chatName; final String date; final int msgCount;
  final String lastMsg;

  Discussion({this.idChat, this.chatImage, this.chatName,
  this.lastMsg, this.date, this.msgCount});

  factory Discussion.getDiscussion(Map<String, dynamic> json){
    return Discussion(
      idChat: json['idchat'], chatImage: json['image'],
      chatName: json['nom'], lastMsg: json['message'],
      msgCount: json['compte'], date: json['date']
    );
  }

}

/**
SELECT c.id AS idchat, c.groupe as nom, c.image as image, m.contenu as message, MAX(m.date) as date, COUNT(m.id) as compte
FROM chatting c, chatusers u, messages m
WHERE (c.id=u.idchat) AND (m.idchat=c.id) AND (u.idsend=1)
ORDER by m.date DESC

puis on soustrait les vu du compte

SELECT c.id AS idchat, COUNT(v.id) as compte
FROM chatting c, chatusers u, chatvu v
WHERE (c.id=u.idchat) AND (v.idchat=c.id) AND (u.idsend=1)
ORDER by v.date DESC

insertion des vu

for chat1
  insertCpt=0
  for chat2
    if chat1 == chat 2
      cpt1-cpt2
      insertcpt++
    finif
  finfor
  if insertcpt==0
    requete sql d'insertion de vu
    "INSERT INTO CHATVU(idchat, iduser, date) VALUES("chat1", "moi", "date")";
  finif
finfor

nombre de membre de la discussion

SELECT c.id as idchat, COUNT(u.idsend) as nombre
FROM chatting c, chatusers u
WHERE c.id=u.idchat

lautre utilisateur que moi

SELECT c.id AS idchat, s.pseudo, s.email
FROM chatting c, chatusers u, users s
WHERE (c.id=u.idchat) and (u.idsend=s.id) and (s.id!=1)
 */