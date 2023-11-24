import 'package:flutter/material.dart';
import '../pages/profile.dart';
import 'videoClasse.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayVideo extends StatefulWidget {
  final String me;
  final VideoInfo video; final bool isLive;
  PlayVideo({this.video, this.me, this.isLive});
  @override
  _PlayVideoState createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  
  YoutubePlayerController controller;

  @override
  void initState(){
    super.initState();
    String url = YoutubePlayer.convertUrlToId(widget.video.youtube);
    controller = YoutubePlayerController(
      initialVideoId: url,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        isLive: widget.isLive,
      )
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      /*appBar: AppBar(
        title: Text("Lecture de video en cours ..."),
      ),*/
      body: ListView(
        children: <Widget>[
          YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            onReady: (){
              print("la video se joue oklm");
            },
          ),
          Column(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage("http://store.yj.fr/wwwreemixcom/image/"+widget.video.image),
              ),
              Text(widget.video.artiste, style: TextStyle(fontSize: 20,color: Colors.white),),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.play_arrow, color: Colors.white),
                onPressed: (){
                  controller.play();
                }
              ),
              IconButton(
                icon: Icon(Icons.pause, color: Colors.white),
                onPressed: (){
                  controller.pause();
                }
              ),
              IconButton(
                icon: Icon(Icons.volume_off, color: Colors.white),
                onPressed: (){
                  controller.mute();
                }
              ),
              IconButton(
                icon: Icon(Icons.volume_up, color: Colors.white),
                onPressed: (){
                  controller.unMute();
                }
              ),
              IconButton(
                icon: Icon(Icons.fullscreen, color: Colors.white),
                onPressed: (){
                  controller.toggleFullScreenMode();
                }
              )
            ],
          ),
          Text(widget.video.titre, style: TextStyle(fontSize: 20,color: Colors.white),),
          Text("Partager par "+widget.video.sharer, style: TextStyle(fontSize: 20,color: Colors.white),),
          Text("le "+widget.video.date, style: TextStyle(fontSize: 20,color: Colors.white),),
          TextButton(
            child: Text("Information",style: TextStyle(fontSize: 25.0),),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context,
                MaterialPageRoute(builder: (context)=> ProfilePage(son: widget.video.id, me: widget.me,) ),
              );
            }
          ),
          SizedBox(height: 50),
          OutlinedButton.icon(
            onPressed: (){},
            icon: Icon(Icons.music_note),
            label: Text("R69MIX Play"),
            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.orange),
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),),
          ),
          Text("by TAPS", style: TextStyle(fontSize: 30,color: Colors.orange))
        ],
      )
    );
  }
}