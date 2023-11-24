import 'dart:ui';
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';
import '../classed/musicClass.dart';
import '../https/playlist.dart';
import '../pages/profile.dart';
import '../r69mixTV/oneVideo.dart';
import '../r69mixTV/videoClasse.dart';
import '../sqflite/clientP.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() => _MusicPageState();
  final List<SonInfo> playlist;
  int userId;
  MusicPage({this.playlist,this.userId});
}

class _MusicPageState extends State<MusicPage> {

  bool isPlaying = false;
  Duration _duration;
  Duration _position;
  double _slider;
  String _error;
  num curIndex = 0;
  PlayMode playMode = AudioManager.instance.playMode;

  // *******************************
  Future setLiked(String son, String user) async{
    await http.post(
      Uri.parse("http://store.yj.fr/wwwreemixcom/liked/liked.php"),
      body: {
        "idson": son, "iduser": user,
      }
    );
  }

  Future setStream(String son, String user) async{
    await http.post(
      Uri.parse("http://store.yj.fr/wwwreemixcom/stream/stream.php"),
      body: {
        "idson": son, "iduser": user,
      }
    );
  }

  bool fliked=false;
  bool fstream=false;
  @override
  void initState() {
    super.initState();
    setupAudio();
  }

  @override
  void dispose() {
    AudioManager.instance.release();
    super.dispose();
  }

  void setupAudio() {
    List<AudioInfo> _list = [];
    widget.playlist.forEach((item) => 
      _list.add(AudioInfo(
        "https://store.yj.fr/wwwreemixcom/playlist/tout/"+item.fichierMP3, title: item.artiste,
        desc: item.titre, coverUrl: "http://store.yj.fr/wwwreemixcom/image/"+item.imageSon
      ))
    );

    AudioManager.instance.audioList = _list;
    AudioManager.instance.intercepter = true;
    AudioManager.instance.play(auto: false);

    AudioManager.instance.onEvents((events, args) {
      print("$events, $args");
      switch (events) {
        case AudioManagerEvents.start:
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          _slider = 0;
          fstream = false;
          setState(() {});
          break;
        case AudioManagerEvents.ready:
          _error = null;
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          setState(() {});
          break;
        case AudioManagerEvents.seekComplete:
          _position = AudioManager.instance.position;
          _slider = _position.inMilliseconds / _duration.inMilliseconds;
          setState(() {});
          break;
        case AudioManagerEvents.buffering:
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = AudioManager.instance.isPlaying;
          setState(() {});
          break;
        case AudioManagerEvents.timeupdate:
          _position = AudioManager.instance.position;
          _slider = _position.inMilliseconds / _duration.inMilliseconds;
          setState(() {});
          AudioManager.instance.updateLrc(args["position"].toString());
          break;
        case AudioManagerEvents.error:
          _error = args;
          setState(() {});
          break;
        case AudioManagerEvents.ended:
          AudioManager.instance.next();
          break;
        case AudioManagerEvents.volumeChange:
          setState(() {});
          break;
        default:
      }
      if (_slider>=0.6 && fstream==false) {
        fstream = true;
        setStream(widget.playlist[AudioManager.instance.curIndex].id, "${widget.userId}");
      }
    });
  }

  Widget getPlayModeIcon(PlayMode playMode) {
    switch (playMode) {
      case PlayMode.sequence:
        return Icon(
          Icons.repeat,
          color: Colors.black,
        );
      case PlayMode.shuffle:
        return Icon(
          Icons.shuffle,
          color: Colors.black,
        );
      case PlayMode.single:
        return Icon(
          Icons.repeat_one,
          color: Colors.black,
        );
    }
    return Container();
  }

  Widget songProgress(BuildContext context) {
    return Slider(
      value: _slider ?? 0,
      onChanged: (value) {
        setState(() {
          _slider = value;
        });
      },
      onChangeEnd: (value) {
        if (_duration != null) {
          Duration msec = Duration(
            milliseconds: (_duration.inMilliseconds * value).round()
          );
          AudioManager.instance.seekTo(msec);
        }
      },
    );
  }

  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column( children: <Widget>[
      Flexible(child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange,
              Colors.black,
              Colors.black,
            ]
          ),
        ),
        child: ListView.builder(
          itemCount: widget.playlist.length,
          itemBuilder: (BuildContext context, int index){
            int sIndex = index+1;
            return Card( child: Container( height: 65.0,
              child:
              Row(
                children: <Widget>[
                  Expanded(child: GestureDetector(
                    child: Row(children: <Widget>[
                      SizedBox(width: 15.0),
                      CircleAvatar(
                        child: Text("$sIndex"),
                        backgroundImage: NetworkImage("http://store.yj.fr/wwwreemixcom/image/"+widget.playlist[index].imageSon,),
                      ),
                      SizedBox(width: 15.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Text(widget.playlist[index].artiste,style: TextStyle(color: Colors.white)),
                        Text(widget.playlist[index].titre,style: TextStyle(color: Colors.white)),
                        Text("Ecoutée "+widget.playlist[index].streamCount+" fois",style: TextStyle(color: Colors.white)),
                      ],)
                    ],),
                    onTap: () => AudioManager.instance.play(index: index),
                  )),
                  IconButton(
                    icon: Icon(Icons.info, color: Colors.white),
                    onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(widget.playlist[index].artiste),
                    content: Container(height: 80, child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Text(widget.playlist[index].titre,style: TextStyle(color: Colors.black)),
                        Text("Ecoutée "+widget.playlist[index].streamCount+" fois",style: TextStyle(color: Colors.black)),
                        Text(widget.playlist[index].likeCount+" mention(s) J'aime",style: TextStyle(color: Colors.red)),
                        Text("Publier par "+widget.playlist[index].shareId,style: TextStyle(color: Colors.black)),
                      ],
                    )),
                    actions: <Widget>[
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context)=> ProfilePage(son: widget.playlist[index].id) ),
                          );
                        },
                        child: Text("info +", style: TextStyle(color: Colors.black),),
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                          if (widget.playlist[index].youtube != "") {
                            
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context)=> PlayVideo(isLive: false,
                              video: VideoInfo(image: widget.playlist[index].imageSon, titre: widget.playlist[index].titre,
                              sharer: widget.playlist[index].shareId, artiste: widget.playlist[index].artiste,
                              youtube: widget.playlist[index].youtube, id: widget.playlist[index].id,
                              date: widget.playlist[index].date),
                            )),
                          );
                          }
                        },
                        child: Icon(Icons.video_label, color: Colors.blue)
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                          setLiked(widget.playlist[index].id, "${widget.userId}");
                          if (widget.playlist[index].liked=="1") {
                            widget.playlist[index].liked="0";
                          } else {
                            widget.playlist[index].liked="1";
                          }
                        },
                        child: Icon(widget.playlist[index].liked =="1" ? Icons.favorite : Icons.favorite_border),
                      )
                    ],
                  ),
                );
              })
                ],
              ),
            )
            );
          }
        )
      )),
      Container(
        height: 115.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0)
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Colors.orange,
            ]
          ),
        ),
        child: Column(children: <Widget>[
        songProgress(context),
        Row(
        children: <Widget>[
          Column(children: <Widget>[
            IconButton(
              icon: Icon(widget.playlist[AudioManager.instance.curIndex].liked == "1" ? Icons.favorite : Icons.favorite_border),
              color: Colors.red,
              onPressed: (){

                setLiked(widget.playlist[AudioManager.instance.curIndex].id, "${widget.userId}");
              }
            ),
            Text(widget.playlist[AudioManager.instance.curIndex].likeCount,
              style:TextStyle(color:Colors.red)
            ),
          ],),
          Expanded(
            child:GestureDetector(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(AudioManager.instance.info.coverUrl,),
                ),
                SizedBox(width: 15.0,),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(AudioManager.instance.info.title,style: TextStyle(color: Colors.white)),
                      Text(AudioManager.instance.info.desc.substring(0,(AudioManager.instance.info.title.length<=20)?AudioManager.instance.info.title.length:20),style: TextStyle(color: Colors.white)),
                  ],)
              ]
            ),
            onTap: (){
              showModalBottomSheet(
                useRootNavigator: true,
                context: context,
                builder: (context) {
                  return Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.black87,
                            image: DecorationImage(
                              image: NetworkImage(AudioManager.instance.info.coverUrl),
                            )
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5.0,
                              sigmaY: 5.0,
                            ),
                            child: Container(
                              color: Colors.white.withOpacity(0.0),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50.0),
                                topRight: Radius.circular(50.0),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                                colors: [
                                  Colors.orange, Colors.black,
                                ],
                                stops: [
                                  0.1, 0.9,
                                ]
                              )
                            )
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(height: 130.0),
                                    Container(
                                      width: 70.0,
                                      padding: EdgeInsets.symmetric(vertical: 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.all(Radius.circular(16.0))
                                      ),
                                      child: Icon(Icons.keyboard_arrow_down),
                                    ),
                                    SizedBox(height: 17.0),
                                    ClipRRect(
                                      child: Image.network(
                                        AudioManager.instance.info.coverUrl,
                                        width: 200.0,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(48.0)),
                                    )
                                  ]
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Text(
                                  "Artiste: "+AudioManager.instance.info.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Text(
                                  "Titre: "+AudioManager.instance.info.desc,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Text(
                                  "Publier par: "+widget.playlist[AudioManager.instance.curIndex].shareId,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 7.0,
                              ),
                              Center(
                                child: Text(
                                  "Musique écoutée "+widget.playlist[AudioManager.instance.curIndex].streamCount+" fois",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(children: <Widget>[
                                    IconButton(
                                      iconSize: 35.0,
                                      icon: Icon(widget.playlist[AudioManager.instance.curIndex].liked == "1" ? Icons.favorite : Icons.favorite_border),
                                      color: Colors.red,
                                      onPressed: (){
                                        setState(() {
                                          if (!fliked) {
                                            widget.playlist[AudioManager.instance.curIndex].liked="1";
                                            fliked = true;
                                          } else {
                                            widget.playlist[AudioManager.instance.curIndex].liked="0";
                                            fliked = false;
                                          }
                                        });
                                        setLiked(widget.playlist[AudioManager.instance.curIndex].id, "${widget.userId}");
                                        Navigator.pop(context);
                                      }
                                    ),
                                    Text(widget.playlist[AudioManager.instance.curIndex].likeCount,
                                      style:TextStyle(color:Colors.red)
                                    ),
                                  ],),
                                  IconButton(
                                    iconSize: 35.0,
                                    icon: Icon(Icons.message),
                                    color: Colors.white,
                                    onPressed: (){
                                      
                                    }
                                  ),
                                  IconButton(
                                    iconSize: 35.0,
                                    icon: Icon(Icons.mic),
                                    color: Colors.white,
                                    onPressed: (){
                                      
                                    }
                                  ),
                                  IconButton(
                                    iconSize: 35.0,
                                    icon: getPlayModeIcon(playMode),
                                    color: Colors.white,
                                    onPressed: (){
                                      playMode = AudioManager.instance.nextMode();
                                      Navigator.pop(context);
                                    }
                                  ),
                                  IconButton(
                                    iconSize: 35.0,
                                    icon: Icon(Icons.video_label),
                                    color: Color.fromRGBO(0, 0, 200, 1),
                                    onPressed: (){
                                      if(widget.playlist[AudioManager.instance.curIndex].youtube!=""){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> PlayVideo(isLive: false,
                                          video: VideoInfo(image: widget.playlist[AudioManager.instance.curIndex].imageSon, titre: widget.playlist[AudioManager.instance.curIndex].titre,
                                          sharer: widget.playlist[AudioManager.instance.curIndex].shareId, artiste: widget.playlist[AudioManager.instance.curIndex].artiste,
                                          youtube: widget.playlist[AudioManager.instance.curIndex].youtube, id: widget.playlist[AudioManager.instance.curIndex].id,
                                          date: widget.playlist[AudioManager.instance.curIndex].date),
                                        )));
                                      }
                                    }
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.skip_previous),
                                    color: Colors.white,
                                    iconSize: 45.0,
                                    onPressed: (){
                                      AudioManager.instance.previous();
                                      Navigator.pop(context);
                                    }
                                  ),
                                  IconButton(
                                    icon: isPlaying ? Icon(Icons.pause_circle_outline) : Icon(Icons.play_circle_outline),
                                    color: Colors.white,
                                    iconSize: 45.0,
                                    onPressed: () async{
                                      bool playing = await AudioManager.instance.playOrPause();
                                      print("$playing");
                                      Navigator.pop(context);
                                    }
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.skip_next),
                                    color: Colors.white,
                                    iconSize: 45.0,
                                    onPressed: (){
                                      AudioManager.instance.next();
                                      Navigator.pop(context);
                                    }
                                  ),
                                  Expanded(
                                    child: TextButton(
                                      child: Text("Information",style: TextStyle(fontSize: 25.0),),
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                                      onPressed: (){
                                        Navigator.pop(context);
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context)=> ProfilePage(son: widget.playlist[AudioManager.instance.curIndex].id, me: "${widget.userId}",) ),
                                        );
                                      }
                                    )
                                  )
                                ],
                              ),
                              SizedBox(height: 7.0),
                              
                            ],
                          )
                        )
                      ]
                    )
                  );
                },
                isScrollControlled: true,
                isDismissible: false,
              );
            }
          ),),
          IconButton(
            icon: Icon(Icons.skip_previous),
            color: Colors.white,
            iconSize: 30.0,
            onPressed: (){
              AudioManager.instance.previous();
            }
          ),
          IconButton(
            icon: isPlaying ? Icon(Icons.pause_circle_outline) : Icon(Icons.play_circle_outline),
            color: Colors.white,
            iconSize: 40.0,
            onPressed: () async{
              await AudioManager.instance.playOrPause();
            }
          ),
          IconButton(
            icon: Icon(Icons.skip_next),
            color: Colors.white,
            iconSize: 30.0,
            onPressed: (){
              AudioManager.instance.next();
            }
          ),
        ]
        )]))
      ]),
    );
  }

}

class MusicLoad extends StatefulWidget {
  @override
  _MusicLoadState createState() => _MusicLoadState();
  final ClientMoi clientMoi;
  MusicLoad({this.clientMoi});
}

class _MusicLoadState extends State<MusicLoad> {

  Playlist playlist = Playlist();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: playlist.receivePlaylist("${widget.clientMoi.identifiant}", widget.clientMoi.password),
        builder: (BuildContext context, AsyncSnapshot<List<SonInfo>> snapshot){
          
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (snapshot.hasData) {
            List<SonInfo> lesSons = snapshot.data;
            return MusicPage(playlist: lesSons,userId: widget.clientMoi.identifiant,);
          }
          return Container(
            child: Center(
            child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ))
          )
          );
        }
      ),
    );
  }
}