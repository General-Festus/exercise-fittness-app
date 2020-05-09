import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:work_space/screen/exercise_hub.dart';
import 'package:audioplayers/audioplayers.dart';
 
class ExerciseScreen extends StatefulWidget {

  final Exercises exercises;
   final int seconds;

  ExerciseScreen ({this.exercises, this.seconds});

 

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {

  bool _isCompleted;
  int _elapsedSeconds =0;

  Timer timer;

  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();

  @override
  void initState() {
   timer = Timer.periodic(
      Duration(seconds: 1), 
      (t) {
        if (t.tick == widget.seconds) {
          t.cancel();
          setState(() {
            _isCompleted = true;
          });

          playerAudio();

        }
        setState(() {
          _elapsedSeconds = t.tick;
        });

      }
      );
    super.initState();
  }

  void playerAudio() {
    audioCache.play('burna.mp3');
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: CachedNetworkImage(
                imageUrl: widget.exercises.gif,
                placeholder: (context, url) => Image(
                  image: AssetImage('assets/placeholder.jpg'),
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                  width:  MediaQuery.of(context).size.width,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                ),
          ),
          _isCompleted != true ? SafeArea(
              child: Container(
              alignment: Alignment.topCenter,
              child: Text('$_elapsedSeconds/${widget.seconds} s'),
            ),
          ):Container(),

          SafeArea(
            child: IconButton(icon: Icon(Icons.close), 
            onPressed: (){
              Navigator.of(context).pop();
            }
            ),
            ),
        ],
      ),
    );
  }
}